#!/usr/bin/env bash

cluster_name=vault-demo

# Hashicorp: instructions from
# - https://developer.hashicorp.com/vault/tutorials/kubernetes/kubernetes-amazon-eks#start-cluster

TOOLING() {
  mkdir -p $HOME/.local/bin
  cd $_
  
  # Install kubectl
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  chmod +x kubectl
  
  # Enable bash autocompletion on kubectl
  sudo yum install -y bash-completion
  source <(kubectl completion bash)
  echo 'source <(kubectl completion bash)' >> ~/.bashrc
  
  # Install eksctl
  # Install the latest version of the eksctl tool
  curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
  sudo mv /tmp/eksctl $HOME/.local/bin
  
  # Install Helm
  export VERIFY_CHECKSUM=false
  curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
  sudo mv /usr/local/bin/helm $HOME/.local/bin
  
  # Generate SSH key
  aws ec2 create-key-pair --key-name vault
}

CLUSTER_DELETE() {
    time eksctl delete cluster $cluster_name
}

CLUSTER_CONFIGURE() {
    set -x
    eksctl create iamserviceaccount --name ebs-csi-controller-sa --namespace kube-system --cluster $cluster_name \
      	--role-name AmazonEKS_EBS_CSI_DriverRole --role-only \
	--attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy --approve
    set +x

    # Hashicorp:
    #eksctl create iamserviceaccount --name ebs-csi-controller-sa --namespace kube-system --cluster learn-vault 
    #    --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy --approve \
    #    --role-only --role-name AmazonEKS_EBS_CSI_DriverRole

    set -x
    #eksctl create addon --cluster $cluster_name --name aws-ebs-csi-driver --version latest --force
    SA_ROLE_ARN="arn:aws:iam::$(aws sts get-caller-identity --query Account --output text):role/AmazonEKS_EBS_CSI_DriverRole"

    eksctl create addon --name aws-ebs-csi-driver --cluster $cluster_name --service-account-role-arn $SA_ROLE_ARN
    set +x
    # Hashicorp:
    # eksctl create addon --name aws-ebs-csi-driver --cluster learn-vault \
    #     --service-account-role-arn arn:aws:iam::$(aws sts get-caller-identity --query Account --output text):role/AmazonEKS_EBS_CSI_DriverRole


}

CLUSTER_CREATE() {
    cd $HOME

    set -x
    time eksctl create cluster --name $cluster_name --nodes 3 --with-oidc --ssh-access --ssh-public-key vault --managed
    set +x
    # Hashicorp:
    # eksctl create cluster --name learn-vault --nodes 3 --with-oidc --ssh-access --ssh-public-key learn-vault --managed

    kubectl get no
}

CREATE_GP3_STORAGE_CLASS() {
    cat > sc.gp3.yaml <<EOF
apiVersion: storage.k8s.io/v1
kind: StorageClass
provisioner: ebs.csi.aws.com # <-- The same name as the CSIDriver
metadata:
  name: gp3
  parameters: # <-- parameters for this CSIDriver
    encrypted: "true"
      type: gp3
      allowVolumeExpansion: true
      volumeBindingMode: Immediate
EOF
    kubectl apply -f sc.gp3.yaml
}

UNUSED_INSTALL_EBS_CSI() {
    aws eks describe-addon-versions --addon-name aws-ebs-csi-driver
    oidc_id=$(aws eks describe-cluster --name $cluster_name --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)
    echo oidc_id=$oidc_id 
    aws iam list-open-id-connect-providers | grep $oidc_id | cut -d "/" -f4


    aws eks describe-addon-versions --addon-name aws-ebs-csi-driver
    eksctl create addon --cluster $cluster_name --name aws-ebs-csi-driver --version latest --force
}

MYSQL_INSTALL() {
    helm list | grep mysql && { set -x; helm uninstall mysql; set +x; }

    #helm install mysql bitnami/mysql --set global.defaultStorageClass=ebs-sc
    kubectl delete pvc data-mysql-0 
    # helm install mysql bitnami/mysql --set global.defaultStorageClass=gp2
    kubectl patch storageclass gp2 -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
    helm install mysql bitnami/mysql
    #helm install mysql bitnami/mysql --set global.defaultStorageClass=gp3
}

exit
## ================================================================================


cat > sc.yaml <<EOF
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: ebs-sc
provisioner: ebs.csi.aws.com
volumeBindingMode: WaitForFirstConsumer
allowVolumeExpansion: true
EOF

kubectl create -f sc.yaml 

kubectl get sc

kubectl delete pvc data-mysql-0 
helm install mysql bitnami/mysql --set global.defaultStorageClass=ebs-sc
kubectl get pv,pvc
kubectl get po -A

================================================================================


# Check OIDC_ID:
oidc_id=$(aws eks describe-cluster --name $cluster_name --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)
echo $oidc_id 

  367  aws iam list-open-id-connect-providers | grep $oidc_id | cut -d "/" -f4
  369  eksctl create iamserviceaccount         --name ebs-csi-controller-sa         --namespace kube-system         --cluster $cluster_name         --role-name AmazonEKS_EBS_CSI_DriverRole         --role-only         --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy         --approve
  370  helm uninstall aws-ebs-csi-driver --namespace kube-system
  371  helm list -A
  372  eksctl utils describe-addon-versions --kubernetes-version 1.30 | grep AddonName
  373  eksctl utils describe-addon-versions --kubernetes-version 1.30 --name name-of-addon | grep AddonVersion
  374  eksctl utils describe-addon-versions --kubernetes-version 1.30 --name aws-ebs-csi-driver | grep AddonVersion
  375  eksctl utils describe-addon-versions --kubernetes-version 1.30 --name aws-ebs-csi-driver  | grep ProductUrl
  376  eksctl create addon --cluster my-cluster --name name-of-addon --version latest \
  377  eksctl create addon --cluster $cluster_name --name aws-ebs-csi-driver --version latest --service-account-role-arn arn:aws:iam::111122223333:role/role-name --force
  378  aws sts get-caller-identity
  379  eksctl create addon --cluster $cluster_name --name aws-ebs-csi-driver --version latest --service-account-role-arn arn:aws:iam::891377237285:role/role-name --force
  380  kubectl get pods
  381  kubectl get pods -A
  382  kubectl get pods,pv,pvc
  383  ll
  384  ll -rte
  385  kubectl delete -f pvc-gp2.yaml 
  386  kubectl delete -f pvc-ebs.yaml 
  387  helm uninstall aws-ebs-csi-driver --namespace kube-system
  388   helm uninstall mysql

eksctl create addon --cluster $cluster_name --name aws-ebs-csi-driver --version latest --force

