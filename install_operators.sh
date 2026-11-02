#!/bin/bash

## Example script to install necessary Kubernetes operators using Helm
helm repo add mongodb https://mongodb.github.io/helm-charts
helm repo add jetstack https://charts.jetstack.io

helm install kubernetes-operator mongodb/mongodb-kubernetes --namespace mongodb --create-namespace --set operator.watchNamespace="*"
helm install cert-manager oci://quay.io/jetstack/charts/cert-manager --namespace cert-manager --create-namespace --set crds.enabled=true
helm install trust-manager jetstack/trust-manager --namespace cert-manager --set app.trust.namespace=cert-manager