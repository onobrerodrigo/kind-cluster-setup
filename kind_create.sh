#!/usr/bin/env bash

# Cria um cluster Kubernetes local com Kind e instale serviços importantes

# Verifique se o argumento do nome do cluster foi fornecido
if [ -z "$1" ]; then
  echo "Usage: $0 --name-cluster <cluster-name>"
  exit 1
fi

# Analisa o argumento --name-cluster
if [[ "$1" == "--name-cluster" ]]; then
  shift
  NAME_CLUSTER=$1
else
  echo "Invalid argument. Usage: $0 --name-cluster <cluster-name>"
  exit 1
fi

# Define as variáveis do script
VER_METALLB='v0.14.9'
VER_INGRESS='4.12.1'
VER_CERT_MANAGER='v1.17.1'
VER_METRICS_SERVER='3.12.2'
VER_INFISICAL='0.8.15'
VELERO_BUCKET_NAME='velero-backup-example'
VELERO_S3_URL='https://s3.eu-central-1.amazonaws.com,region=eu-central-1'
VELERO_SECRET_FILE_DIR='./cloud-credentials-sample'

# Criando um cluster Kubernetes com o KinD
kind create cluster --name $NAME_CLUSTER --config ./kind.yaml || exit 1

# Instalando o serviço do MetalLB
echo "Installing MetalLB 🔄"
helm upgrade --install metallb metallb/metallb --version $VER_METALLB --create-namespace --namespace metallb-system > /dev/null || exit 1
echo "✓ MetalLB Installed"

# Aguardando Pods MetalLB serem inicializados
echo "Waiting for MetalLB pods to start 🔄"
sleep 60
echo "✓ Pods initialized"

# Criando as camadas customizadas do MetalLB
echo "Creating Custom Layers MetalLB 🔄"
kubectl create --filename ./metallb-config.yaml > /dev/null || exit 1
echo "✓ Custom Layers MetalLB Created"

# Instalando o serviço do Ingress-Nginx-Controller
echo "Installing Ingress Nginx Controller 🌐"
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx --version $VER_INGRESS --create-namespace --namespace ingress-nginx > /dev/null || exit 1
echo "✓ Ingress Nginx Controller Installed"

# Instalando o serviço do Cert-Manager e CRDs
echo "Installing Cert Manager and CRDs 🔑"
helm upgrade --install cert-manager jetstack/cert-manager --version $VER_CERT_MANAGER --create-namespace --namespace cert-manager --set crds.enabled=true > /dev/null || exit 1
echo "✓ Cert Manager and CRDs Installed"

# Criando um Cluster Issuer customizado
echo "Creating Custom Cluster Issuer 🔑"
kubectl create --filename ./cert-manager-cluster-issuer.yaml > /dev/null || exit 1
echo "✓ Custom Cluster Issuer Created"

# Instalando o serviço do Metrics Server com SECURE TLS desabilitado
echo "Installing Metrics Server 📊"
helm upgrade --install metrics-server metrics-server/metrics-server --create-namespace --namespace metrics-server --version $VER_METRICS_SERVER --set args={--kubelet-insecure-tls} > /dev/null || exit 1
echo "✓ Metrics Server Installed"

# Instalando o serviço do Infisical
echo "Installing Infisical 🙈"
helm install --generate-name infisical-helm-charts/secrets-operator --create-namespace --namespace infisical --version $VER_INFISICAL > /dev/null || exit 1
echo "✓ Infisicall Installed"

# Instalando o serviço do Velero
echo "Installing Velero ⛵"
velero install --provider velero.io/aws --bucket $VELERO_BUCKET_NAME --plugins velero/velero-plugin-for-aws:v1.0.1,displague/velero-plugin-linode:v0.0.1 --backup-location-config "s3Url=$VELERO_S3_URL" --use-volume-snapshots=false --secret-file="$VELERO_SECRET_FILE_DIR" > /dev/null || exit 1
echo "✓ Velero Installed"
