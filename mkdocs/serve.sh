
set -x

cd $( dirname $0 )

which mkdocs || sudo apt-get install -y mkdocs-material

# local:
# mkdocs serve
mkdocs serve -a 0.0.0.0:8889


