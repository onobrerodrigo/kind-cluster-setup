#!/usr/bin/env bash

# Delete a Local Kubernetes Cluster with KinD

# Check if the cluster name argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 --name-cluster <cluster-name>"
  exit 1
fi

# Parse the --name-cluster argument
if [[ "$1" == "--name-cluster" ]]; then
  shift
  NAME_CLUSTER=$1
else
  echo "Invalid argument. Usage: $0 --name-cluster <cluster-name>"
  exit 1
fi

# Delete Kubernetes cluster with KinD
kind delete cluster --name $NAME_CLUSTER || exit 1
