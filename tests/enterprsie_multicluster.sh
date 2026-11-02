#!/bin/bash

### Enterprise Advanced Clusters ###

# Must set following environment variables:
# OM_PUBLIC_KEY
# OM_PRIVATE_KEY
# OM_ORG_ID
# PROJECT_NAME
# OM_URL

# Don't forget to install the necessary operators! See install_operators.sh for reference.

## Deploy a replica set
helm upgrade --install rs-test ./quick-cluster --namespace mongodb \
 --set name="rs-test" \
 --set omPublicKey="$OM_PUBLIC_KEY" \
 --set omPrivateKey="$OM_PRIVATE_KEY"\
 --set projectName="$PROJECT_NAME-0" \
 --set omOrgId="$OM_ORG_ID" \
 --set omUrl="$OM_URL" \
 --set type="replicaSet" \
 --set authEnabled=true

## Deploy a replica set with TLS
helm upgrade --install rs-tls-test ./quick-cluster --namespace mongodb \
 --set name="rs-tls-test" \
 --set omPublicKey="$OM_PUBLIC_KEY" \
 --set omPrivateKey="$OM_PRIVATE_KEY"\
 --set omUrl="$OM_URL" \
 --set omOrgId="$OM_ORG_ID" \
 --set projectName="$PROJECT_NAME-1" \
 --set type="replicaSet" \
 --set authEnabled=true \
 --set tlsEnabled=true

## Deploy a replica set with search (no tls)
helm upgrade --install rs-search-test ./quick-cluster --namespace mongodb \
 --set name="rs-search-test" \
 --set omPublicKey="$OM_PUBLIC_KEY" \
 --set omPrivateKey="$OM_PRIVATE_KEY"\
 --set omUrl="$OM_URL" \
 --set projectName="$PROJECT_NAME-2" \
 --set omOrgId="$OM_ORG_ID" \
 --set type="replicaSet" \
 --set authEnabled=true \
 --set searchEnabled=true

## Deploy a replica set with search (tls)
helm upgrade --install rs-search-test-tls ./quick-cluster --namespace mongodb \
 --set name="rs-search-test-tls" \
 --set omPublicKey="$OM_PUBLIC_KEY" \
 --set omPrivateKey="$OM_PRIVATE_KEY"\
 --set omUrl="$OM_URL" \
 --set projectName="$PROJECT_NAME-2" \
 --set omOrgId="$OM_ORG_ID" \
 --set type="replicaSet" \
 --set authEnabled=true \
 --set searchEnabled=true \
 --set tlsEnabled=true

## Deploy a sharded cluster with search (always requires tls)
helm upgrade --install rs-search-test-sharded ./quick-cluster --namespace mongodb \
 --set name="rs-search-test-sharded" \
 --set omPublicKey="$OM_PUBLIC_KEY" \
 --set omPrivateKey="$OM_PRIVATE_KEY"\
 --set omUrl="$OM_URL" \
 --set projectName="$PROJECT_NAME-2" \
 --set omOrgId="$OM_ORG_ID" \
 --set type="shardedCluster" \
 --set authEnabled=true \
 --set searchEnabled=true \
 --set tlsEnabled=true

