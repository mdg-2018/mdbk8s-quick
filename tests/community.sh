### Community Clusters ###

## Deploy a community cluster
helm upgrade --install community-search-test ./quick-cluster --namespace mongodb  \
--set name="community-search-test"  \
--set community=true  \
--set authEnabled=true  \
--set launchClientPod=true

## Deploy a community cluster (tls)
helm upgrade --install community-search-test-tls ./quick-cluster --namespace mongodb  \
--set name="community-search-test-tls"  \
--set community=true  \
--set authEnabled=true  \
--set launchClientPod=true \
--set tlsEnabled=true

## Deploy a community cluster with search
helm upgrade --install community-search-test ./quick-cluster --namespace mongodb  \
--set name="community-search-test"  \
--set community=true  \
--set authEnabled=true  \
--set launchClientPod=true \
--set searchEnabled=true

## Deploy a community cluster with search (tls)
helm upgrade --install community-search-test-tls ./quick-cluster --namespace mongodb  \
--set name="community-search-test-tls"  \
--set community=true  \
--set authEnabled=true  \
--set launchClientPod=true \
--set searchEnabled=true \
--set tlsEnabled=true