#!/bin/bash
helm upgrade --install search-test ./quick-cluster --namespace mongodb \
 --set name="searchtest" --set namespace="mongodb" \
 --set omPublicKey="$OM_PUBLIC_KEY" \
 --set omPrivateKey="$OM_PRIVATE_KEY"\
 --set projectName="helm-test-4" \
 --set type="replicaSet" \
 --set authEnabled=true \
 --set searchEnabled=true