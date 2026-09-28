#!/bin/bash

## Example script to install necessary Kubernetes operators using Helm

helm install kubernetes-operator mongodb/mongodb-kubernetes --namespace mongodb --create-namespace
helm install   cert-manager oci://quay.io/jetstack/charts/cert-manager   --namespace cert-manager   --create-namespace   --set crds.enabled=true
helm install trust-manager jetstack/trust-manager   --namespace cert-manager   --set app.trust.namespace=cert-manager