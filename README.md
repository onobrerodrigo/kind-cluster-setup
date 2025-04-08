### Description
The kind-cluster-setup repository provides an automation script for creating and configuring a local Kubernetes cluster using KinD, along with the installation of essential services such as MetalLB, Ingress Nginx Controller, Cert-Manager, Metrics Server, Infisical, and Velero. This setup is ideal for developers and testers looking for a complete and functional Kubernetes environment with minimal manual configuration.

## Prerequisites
To run this script, you will need to have the following tools installed on your machine:

* [Docker](https://docs.docker.com/engine/install/)
* [Helm](https://helm.sh/docs/intro/quickstart/)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [Kind](https://kind.sigs.k8s.io/docs/user/quickstart/)
* [Velero](https://velero.io/docs/v1.3.0/velero-install/)

## MetalLB Configuration
The file metallb-config.yaml is used to configure MetalLB with an IP address pool defined by you. To ensure that MetalLB uses the custom network you created with Docker, it is essential to correctly configure the subnet.

If you have created your own Docker network with the name kindnet (or another name of your preference), do this before running the script to create the cluster with Kind. You can create a Docker network with a specific subnet using the following command:

```bash
docker network create --driver bridge --subnet=172.19.0.0/16 kind
```
After creating the custom Docker network, use the IP range you defined in the above command to update the addresses section in the metallb-config.yaml file. For example, if you used the subnet 172.19.0.0/16, you could configure an IP range in metallb-config.yaml as follows:

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

## Cert-Manager Configuration
The file cert-manager-cluster-issuer.yaml defines two ClusterIssuers for Cert-Manager, one for the staging environment and another for production, both using the ACME server from Let's Encrypt and configured to resolve challenges via ingress with Nginx.

## Running the Script

To run the script and set up your local Kubernetes cluster, follow the steps below:

1. Clone this repository to your local machine.

2. Ensure all prerequisites are installed and configured.

3. Define the name of the cluster you wish to create.

4. Run the script with the cluster name as an argument:

```bash
./kind_create.sh --name-cluster meu-cluster-k8s
```
The script will create the cluster, install the mentioned services, and apply the specific configurations for each service.

## File Structure
* ```kind.yaml```: Defines the Kubernetes cluster configuration with Kind, including nodes, images, and port mappings.
* ```metallb-config.yaml```: IP pool configuration for MetalLB.
* ```cert-manager-cluster-issuer.yaml```:  Configuration of certificate issuers for Cert-Manager.
* ```kind_create.sh```: Main script for automating cluster creation and service installation.

## Final Example of How the Script Should Work

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

## Additional Information
Cloud Credentials: The cloud-credentials file contains the necessary credentials for Velero to interact with cloud storage. Make sure to replace the key_id and access_key values with your actual credentials.

## Contribution
Contributions are welcome! Feel free to open issues or send pull requests with improvements, bug fixes, or adaptations for different cloud providers and cluster configurations.

## Disclaimer
This script is provided as is, without any warranties. It is important that you review and adjust the configurations to meet the specific needs of your project and adhere to security best practices.