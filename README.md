### Descrição
O repositório ```kind-cluster-setup``` oferece um script de automação para a criação e configuração de um cluster Kubernetes local utilizando ```KinD```, juntamente com a instalação de serviços essenciais como ```MetalLB```, ```Ingress Nginx Controller```, ```Cert-Manager```, ```Metrics Server```, [Infisical](https://infisical.com/) e [Velero](https://velero.io/docs/v1.3.0/basic-install/). Este setup é ideal para desenvolvedores e testadores que buscam um ambiente Kubernetes completo e funcional com mínima configuração manual.

## Pré-requisitos
Para executar este script, você precisará ter as seguintes ferramentas instaladas em sua máquina:

* [Docker](https://docs.docker.com/engine/install/)
* [Helm](https://helm.sh/docs/intro/quickstart/)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [Kind](https://kind.sigs.k8s.io/docs/user/quickstart/)
* [Velero](https://velero.io/docs/v1.3.0/velero-install/)

## Configuração do MetalLB
O arquivo metallb-config.yaml é utilizado para configurar o MetalLB com um pool de endereços IP definido por você. Para assegurar que o MetalLB utilize a rede personalizada que você criou com Docker, é essencial configurar a subnet corretamente.

Caso você tenha criado sua própria rede Docker com o nome kindnet (ou outro nome de sua preferência), faça isso antes de executar o script para criar o cluster com Kind. Você pode criar uma rede Docker com uma subnet específica usando o seguinte comando:

```bash
docker network create --driver bridge --subnet=172.19.0.0/16 kindnet
```
Após criar a rede Docker personalizada, utilize o intervalo de IP que você definiu no comando acima para atualizar a seção addresses no arquivo metallb-config.yaml. Por exemplo, se você utilizou a subnet ```172.19.0.0/16```, você poderia configurar um range de IPs no ```metallb-config.yaml``` da seguinte forma:

```bash
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: ginga
  namespace: metallb-system
spec:
  addresses:
  - 172.19.0.100-172.19.0.105
```

## Configuração do Cert-Manager
O arquivo ```cert-manager-cluster-issuer.yaml``` define dois ClusterIssuers para o Cert-Manager, um para o ambiente de staging e outro para produção, ambos usando o ACME server da Let's Encrypt e configurados para resolver desafios via ingress com o Nginx.

## Execução do Script

Para executar o script e configurar seu cluster Kubernetes local, siga os passos abaixo:

1. Clone este repositório para a sua máquina local.

2. Verifique se todos os pré-requisitos estão instalados e configurados.

3. Defina o nome do cluster que deseja criar.

4. Execute o script com o nome do cluster como argumento:

```bash
./kind_create.sh --name-cluster meu-cluster-k8s
```
O script irá criar o cluster, instalar os serviços mencionados e aplicar as configurações específicas de cada serviço.

## Estrutura de Arquivos
* ```kind.yaml```: Define a configuração do cluster Kubernetes com Kind, incluindo nodes, imagens e mapeamentos de portas.
* ```metallb-config.yaml```: Configuração do pool de IPs para o MetalLB.
* ```cert-manager-cluster-issuer.yaml```: Configuração dos emissores de certificado para o Cert-Manager.
* ```kind_create.sh```: Script principal para automação da criação do cluster e instalação dos serviços.


## Exemplo final de como deve funcionar o script

```bash
./kind_create.sh --name-cluster ginga                                                                                                                                                    

Creating cluster "ginga" ...
 ✓ Ensuring node image (docker.io/kindest/node:v1.31.2) 🖼
 ✓ Preparing nodes 📦 📦 📦  
 ✓ Writing configuration 📜 
 ✓ Starting control-plane 🕹️ 
 ✓ Installing CNI 🔌 
 ✓ Installing StorageClass 💾 
 ✓ Joining worker nodes 🚜 
Set kubectl context to "kind-ginga"
You can now use your cluster with:

kubectl cluster-info --context kind-ginga

Not sure what to do next? 😅  Check out https://kind.sigs.k8s.io/docs/user/quick-start/
Installing MetalLB 🔄
✓ MetalLB Installed
Waiting for MetalLB pods to start 🔄
✓ Pods initialized
Creating Custom Layers MetalLB 🔄
✓ Custom Layers MetalLB Created
Installing Ingress Nginx Controller 🌐
✓ Ingress Nginx Controller Installed
Installing Cert Manager CRD 🔑
✓ Cert Manager CRD Installed
Installing Cert Manager 🔑
✓ Cert Manager Installed
Creating Custom Cluster Issuer 🔑
✓ Custom Cluster Issuer Created
Installing Metrics Server 📊
✓ Metrics Server Installed
Installing Infisical 🙈
✓ Infisicall Installed
Installing Velero ⛵
✓ Velero Installed
```

## Informações Adicionais
Credenciais de Nuvem: O arquivo ```cloud-credentials``` contém as credenciais necessárias para o Velero interagir com o armazenamento em nuvem. Certifique-se de substituir os valores ```key_id``` e ```access_key``` pelas suas credenciais reais.

## Contribuição
Contribuições são bem-vindas! Sinta-se livre para abrir issues ou enviar pull requests com melhorias, correções de bugs ou adaptações para diferentes provedores de nuvem e configurações de cluster.

## Disclaimer
Este script é fornecido como está, sem garantias de qualquer tipo. É importante que você revise e ajuste as configurações para atender às necessidades específicas do seu projeto e às melhores práticas de segurança.