#!/bin/bash

### Enterprise Advanced Clusters ###

# Must set following environment variables:
# OM_PUBLIC_KEY
# OM_PRIVATE_KEY
# OM_ORG_ID
# PROJECT_NAME
# OM_URL
# CLUSTER_1
# CLUSTER_2

# Don't forget to install the necessary operators! See install_operators.sh for reference.

### Notes ###
# - When testing on k3s, the built in load balancer has some limitations that only allow for one mongodb node per kubernetes node.

### Setup ###
kubectl mongodb multicluster setup   \
--central-cluster="$CLUSTER_1"   \
--member-clusters="$CLUSTER_1,$CLUSTER_2"   \
--member-cluster-namespace="mongodb"   \
--central-cluster-namespace="mongodb"   \
--create-service-account-secrets   \
--cluster-scoped=true \
--install-database-roles=true

helm upgrade --install kubernetes-operator mongodb/mongodb-kubernetes \
--namespace mongodb \
--create-namespace \
--set operator.name=mongodb-kubernetes-operator-multi-cluster \
--set operator.createOperatorServiceAccount=false \
--set operator.createResourcesServiceAccountsAndRoles=false \
--set operator.mdbDefaultArchitecture=static \
--set multiCluster.performFailover=true \
--set-json multiCluster.clusters="[\"$CLUSTER_1\",\"$CLUSTER_2\"]" \
--set operator.watchNamespace="*" \
--kube-context="$CLUSTER_1"

# Create namespaces and apply database roles for each namespace
# This way tests can run in independent namespaces to prevent conflicts
for CLUSTER in "$CLUSTER_1" "$CLUSTER_2"; do
    for ns in mongodb-0 mongodb-1 mongodb-2 mongodb-3; do
    kubectl create ns $ns --context="$CLUSTER"
    helm template mongodb/mongodb-kubernetes \
        --set operator.namespace=$ns \
        --show-only templates/database-roles.yaml | kubectl apply -f - -n $ns --context="$CLUSTER"
    done
done

### End Setup ###

## Deploy a replica set
helm upgrade --install test-cluster ./quick-cluster --namespace mongodb-0 \
 --set name="test-cluster" \
 --set omPublicKey="$OM_PUBLIC_KEY" \
 --set omPrivateKey="$OM_PRIVATE_KEY"\
 --set projectName="$PROJECT_NAME-0" \
 --set omOrgId="$OM_ORG_ID" \
 --set omUrl="$OM_URL" \
 --set authEnabled=true \
 --set type="multicluster-replicaSet" \
 --set launchClientPod=true \
 --set-json multicluster.clusters="[{\"name\":\"$CLUSTER_1\",\"externalDomain\":\"$CLUSTER_1\"},{\"name\":\"$CLUSTER_2\",\"externalDomain\":\"$CLUSTER_2\"}]"
  
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
 --set tlsEnabled=true \
 --set type="multicluster-replicaSet" \
 --set launchClientPod=true \
 --set-json multicluster.clusters="[{"name":\"$CLUSTER_1\",\"externalDomain\":\"$CLUSTER_1\"},{\"name\":\"$CLUSTER_2\",\"externalDomain\":\"$CLUSTER_2\"}]"


## Deploy a sharded cluster no tls
helm upgrade --install test-cluster ./quick-cluster --namespace mongodb-2 \
 --set name="test-cluster" \
 --set omPublicKey="$OM_PUBLIC_KEY" \
 --set omPrivateKey="$OM_PRIVATE_KEY"\
 --set omUrl="$OM_URL" \
 --set projectName="$PROJECT_NAME-2" \
 --set omOrgId="$OM_ORG_ID" \
 --set type="shardedCluster" \
 --set authEnabled=true \
 --set searchEnabled=true \
 --set type="multicluster-shardedCluster" \
 --set launchClientPod=true \
 --set-json multicluster.clusters="[{"name":\"$CLUSTER_1\",\"externalDomain\":\"$CLUSTER_1\"},{\"name\":\"$CLUSTER_2\",\"externalDomain\":\"$CLUSTER_2\"}]"

## Deploy a sharded cluster with TLS
helm upgrade --install test-cluster ./quick-cluster --namespace mongodb-3 \
 --set name="test-cluster" \
 --set omPublicKey="$OM_PUBLIC_KEY" \
 --set omPrivateKey="$OM_PRIVATE_KEY"\
 --set omUrl="$OM_URL" \
 --set projectName="$PROJECT_NAME-3" \
 --set omOrgId="$OM_ORG_ID" \
 --set type="shardedCluster" \
 --set authEnabled=true \
 --set searchEnabled=true \
 --set tlsEnabled=true \
 --set type="multicluster-shardedCluster" \
 --set launchClientPod=true \
 --set-json multicluster.clusters="[{"name":\"$CLUSTER_1\",\"externalDomain\":\"$CLUSTER_1\"},{\"name\":\"$CLUSTER_2\",\"externalDomain\":\"$CLUSTER_2\"}]"

