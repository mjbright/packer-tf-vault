# Install Vault   

# Overview
This lab explains how to install and get started with Vault.   

## Install Vault binary   

Download Vault binary   
<!-- wget https://releases.hashicorp.com/vault/1.10.2/vault_1.10.2_linux_amd64.zip -->

```
wget https://releases.hashicorp.com/vault/1.18.1/vault_1.18.1_linux_amd64.zip
```

Install `unzip`
<!-- ``` sudo apt install -y unzip ``` or on yum systems: -->

```
sudo yum install -y unzip
```
Note: or use 'apt' on apt-based systems such as ubuntu

Extract Vault   
<!-- unzip vault_1.10.2_linux_amd64.zip -->
```
unzip vault_1.18.1_linux_amd64.zip
```

Move the binary into the `$PATH`   
<!-- sudo cp vault /usr/local/bin/ -->
```
sudo mv vault ~/.local/bin/
```

Confirm Vault is installed correctly.   
```
vault version
```

Remove the vault.zip file
```
rm vault_1.18.1_linux_amd64.zip 
```

## Start Vault server

Now that Vault is installed let's start up the server and play around

Start vault in `dev` mode. 
```
vault server -dev -dev-listen-address=0.0.0.0:8200
```

The server will start and print out a bunch of information. 

Output: 
```
==> Vault server configuration:

             Api Address: http://127.0.0.1:8200
                     Cgo: disabled
         Cluster Address: https://127.0.0.1:8201
              Go Version: go1.15.11
              Listener 1: tcp (addr: "127.0.0.1:8200", cluster address: "127.0.0.1:8201", max_request_duration: "1m30s", max_request_size: "33554432", tls: "disabled")
               Log Level: info
                   Mlock: supported: true, enabled: false
           Recovery Mode: false
                 Storage: inmem
                 Version: Vault v1.7.1
             Version Sha: 917142287996a005cb1ed9d96d00d06a0590e44e
```

When running Vault in `dev` mode it also takes over your terminal. 

Copy the `Unseal Key` and `Root Token`, and save them for future labs. 

Open a new terminal window and SSH into the server. 

**Note:** If working in the ```AWS CloudShell``` environment, you can create a new terminal by typing &lt;ctrl-b&gt; then 'c'

In the new terminal export the following: 
```
export VAULT_ADDR='http://0.0.0.0:8200'
export VAULT_TOKEN=<token saved from previous step in lab>
```

For example if running the vault server produced the following lines as part of it's output:
```
    Unseal Key: dW28I8tv4kzseZ3JUeQTPuDiAE7kGsfS2xRN1mVagAI=
    Root Token: just-an-example
```

You would set variables as follows (**but replace with your root token**):

```
    export VAULT_ADDR='http://0.0.0.0:8200'
    export VAULT_TOKEN='just-an-example'
```

Confirm you can connect to Vault 
```
vault status
```

You should see something like this: 
```
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
Total Shares    1
Threshold       1
Version         1.7.1
Storage Type    inmem
Cluster Name    vault-cluster-35585da9
Cluster ID      1f4e38fc-8657-d0ad-199b-adbddeb86c10
HA Enabled      false
```


## Creating your first secret
Now that the dev server is up and running, let's get straight to it and read and write your first secret.

One of the core features of Vault is the ability to read and write arbitrary secrets securely. Secrets written to Vault are encrypted and then written to backend storage. Therefore, the backend storage mechanism never sees the unencrypted value and doesn't have the means necessary to decrypt it without Vault.

We are going to use the `kv` or `Kev/Value v2` secrets engine, it is used to store arbitrary secrets within the configured physical storage for Vault.

Key names must always be strings. If you write non-string values directly via the CLI, they will be converted into strings. However, you can preserve non-string values by writing the key/value pairs to Vault from a `JSON` file or using the HTTP API.  

Let's write a secret to Key/Value v2 secrets engine when running a dev server. 

Use the vault kv put &lt;path&gt; &lt;key&gt;=&lt;value&gt; command.

```
vault kv put secret/hello foo=world
```

This writes the pair `foo=world` to the path `secret/hello`. You'll learn paths in more detail later, but for now it is important that the path is prefixed with `secret/`, otherwise this example won't work. The `secret/` prefix is where arbitrary secrets can be read and written.


It is also possible to write multiple pieces of data.
```
vault kv put secret/hello foo=world excited=yes
```   
Notice that the `version` is now `2`. The `vault kv put` command creates a new version of the secrets and replaces any pre-existing data at the path if any.


After creating a secret we can retrieve it using the `vault kv get &lt;path&gt;` command. 

For our example execute: 
```
vault kv get secret/hello
```

You will see that Vault returns the the latest version (version 2) of the secrets key/value data submitted earlier. 

Output:
```
====== Metadata ======
Key              Value
---              -----
created_time     2020-09-02T21:41:17.568155Z
deletion_time    n/a
destroyed        false
version          2

===== Data =====
Key        Value
---        -----
excited    yes
foo        world
```

To print only the value of a given field, use the `-field=&lt;key_name&gt;` flag.   

```
vault kv get -field=excited secret/hello
```

Optional JSON output is very useful for scripts. For example, you can use the `jq` tool to extract the value of the `excited` secret.


Install `jq`
```
sudo yum install -y jq
```
<!--
sudo apt update 
sudo apt install -y jq
-->
Note: or use 'apt' on apt-based systems such as ubuntu


Pipe `vault kv get` output into `jq` to extract results.   
```
vault kv get -format=json secret/hello | jq -r .data.data.excited
```

You can also view the secret in the UI by visiting the server's public IP address on port `8200`. 

**Note:** If running in the ```AWS CloudShell``` we don't have access to that port.


Now that you've learned how to read and write a secret, let's go ahead and delete it. You can do so using the `vault kv delete` command.

First let's list what secrets are available:
```
vault kv list secret
```

You should see the ```hello``` secret is listed

```
vault kv delete -mount=secret hello
```
<!-- old style: vault kv delete -mount=secret hello -->

Then validate that the secret no longer exists.

```
vault kv list secret
```

**What happened?**

Well in fact the key is still present, but if you perform a ```vault kv get secret/hello``` we see that there is no longer a value associated, only the metadata.

You should see the ```hello``` secret is no longer listed

**Note:** To delete all versions and metadata, see the "vault kv metadata" subcommand.

# Congratulations !
Go back to the [lab index](../../)

