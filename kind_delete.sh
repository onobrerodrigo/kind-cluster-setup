#!/usr/bin/env bash

# Delete a Local Kubernetes Cluster with Kind

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

# Create Kubernetes cluster with Kind
kind delete cluster --name $NAME_CLUSTER || exit 1
