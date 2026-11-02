#!/bin/bash

### Enterprise Advanced Clusters ###

# Must set following environment variables:
# OM_PUBLIC_KEY
# OM_PRIVATE_KEY
# OM_ORG_ID
# PROJECT_NAME
# OM_URL

# Don't forget to install the necessary operators! See install_operators.sh for reference.

### Setup ###
# Create namespaces and apply database roles for each namespace
# This way tests can run in independent namespaces to prevent conflicts
for ns in mongodb-0 mongodb-1 mongodb-2 mongodb-3 mongodb-4 mongodb-5; do
  kubectl create ns $ns
  helm template mongodb/mongodb-kubernetes \
    --set operator.namespace=$ns \
    --show-only templates/database-roles.yaml | kubectl apply -f - -n $ns
done


## Deploy a replica set
helm upgrade --install test-cluster ./quick-cluster --namespace mongodb-0 \
 --set name="test-cluster" \
 --set omPublicKey="$OM_PUBLIC_KEY" \
 --set omPrivateKey="$OM_PRIVATE_KEY"\
 --set projectName="$PROJECT_NAME-0" \
 --set omOrgId="$OM_ORG_ID" \
 --set omUrl="$OM_URL" \
 --set type="replicaSet" \
 --set authEnabled=true \
 --set launchClientPod=true

## Deploy a replica set with TLS
helm upgrade --install test-cluster ./quick-cluster --namespace mongodb-1 \
 --set name="test-cluster" \
 --set omPublicKey="$OM_PUBLIC_KEY" \
 --set omPrivateKey="$OM_PRIVATE_KEY"\
 --set omUrl="$OM_URL" \
 --set omOrgId="$OM_ORG_ID" \
 --set projectName="$PROJECT_NAME-1" \
 --set type="replicaSet" \
 --set authEnabled=true \
 --set launchClientPod=true \
 --set tlsEnabled=true

## Deploy a replica set with search (no tls)
helm upgrade --install test-cluster ./quick-cluster --namespace mongodb-2 \
 --set name="test-cluster" \
 --set omPublicKey="$OM_PUBLIC_KEY" \
 --set omPrivateKey="$OM_PRIVATE_KEY"\
 --set omUrl="$OM_URL" \
 --set projectName="$PROJECT_NAME-2" \
 --set omOrgId="$OM_ORG_ID" \
 --set type="replicaSet" \
 --set authEnabled=true \
 --set launchClientPod=true \
 --set searchEnabled=true

## Deploy a replica set with search (tls)
helm upgrade --install test-cluster ./quick-cluster --namespace mongodb-3 \
 --set name="test-cluster" \
 --set omPublicKey="$OM_PUBLIC_KEY" \
 --set omPrivateKey="$OM_PRIVATE_KEY"\
 --set omUrl="$OM_URL" \
 --set projectName="$PROJECT_NAME-3" \
 --set omOrgId="$OM_ORG_ID" \
 --set type="replicaSet" \
 --set authEnabled=true \
 --set launchClientPod=true \
 --set searchEnabled=true \
 --set tlsEnabled=true

## Deploy a sharded cluster with tls
helm upgrade --install test-cluster ./quick-cluster --namespace mongodb-4 \
 --set name="test-cluster" \
 --set omPublicKey="$OM_PUBLIC_KEY" \
 --set omPrivateKey="$OM_PRIVATE_KEY"\
 --set omUrl="$OM_URL" \
 --set projectName="$PROJECT_NAME-4" \
 --set omOrgId="$OM_ORG_ID" \
 --set type="shardedCluster" \
 --set authEnabled=true \
 --set launchClientPod=true \
 --set tlsEnabled=true

## Deploy a sharded cluster with tls and search (TLS always required with sharded + search)
helm upgrade --install test-cluster ./quick-cluster --namespace mongodb-5 \
 --set name="test-cluster" \
 --set omPublicKey="$OM_PUBLIC_KEY" \
 --set omPrivateKey="$OM_PRIVATE_KEY"\
 --set omUrl="$OM_URL" \
 --set projectName="$PROJECT_NAME-4" \
 --set omOrgId="$OM_ORG_ID" \
 --set type="shardedCluster" \
 --set authEnabled=true \
 --set launchClientPod=true \
 --set tlsEnabled=true \
 --set searchEnabled=true
