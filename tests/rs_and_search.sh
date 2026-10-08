#!/bin/bash

## Deploy a replica set with search
helm upgrade --install search-test ./quick-cluster --namespace mongodb \
 --set name="searchtest" \
 --set omPublicKey="$OM_PUBLIC_KEY" \
 --set omPrivateKey="$OM_PRIVATE_KEY"\
 --set projectName="helm-test-4" \
 --set type="replicaSet" \
 --set authEnabled=true \
 --set searchEnabled=false

## Deploy a sharded cluster with search
helm upgrade --install search-test ./quick-cluster --namespace mongodb  \
 --set name="searchtest" \
 --set omPublicKey="$OM_PUBLIC_KEY"  \
 --set omPrivateKey="$OM_PRIVATE_KEY" \
 --set projectName="helm-test-4"  \
 --set type="shardedCluster"  \
 --set authEnabled=true  \
 --set searchEnabled=true \
 --set tlsEnabled=true \
 --set searchLoadBalancerReplicas=2 \
 --set launchClientPod=true

## Deploy a community cluster
# Note: Community clusters do not require a type to be set, as they are always replica sets.
helm upgrade --install community-search-test ./quick-cluster --namespace mongodb  \
--set name="community-search-test"  \
--set community=true  \
--set authEnabled=true  \
--set searchEnabled=true \
--set launchClientPod=true