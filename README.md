# MongoDB Kubernetes Demo Cluster Generator

This project packages a Helm chart that creates a MongoDB test or demo environment on Kubernetes. It is designed to quickly spin up MongoDB workloads managed by MongoDB Ops Manager, with support for:

- Replica set deployments
- Sharded cluster deployments
- Optional MongoDB Search
- Optional TLS enabled by cert-manager and trust-manager
- Optional client pod for ad-hoc connectivity testing

The chart is intentionally focused on quick validation and demo scenarios, not production hardening.

## Prerequisites

Before deploying, make sure the following are available:

- A Kubernetes cluster
- Helm 3 installed locally
- `kubectl` configured to the correct cluster
- MongoDB Kubernetes Operator installed in the target cluster
- MongoDB Ops Manager reachable from the cluster
- A valid MongoDB Ops Manager public/private key pair
- A project in Ops Manager where the cluster will be created
- `cert-manager` and `trust-manager` installed if you plan to enable TLS

> The chart assumes a MongoDB Ops Manager environment and a project configuration compatible with MongoDB's Kubernetes Operator.


### Key values

| Value | Description | Typical use |
|---|---|---|
| `type` | Cluster type. Supported values are `replicaSet` and `shardedCluster` | Choose one based on the demo scenario |
| `name` | Metadata name used for the MongoDB resource and related objects | Example: `searchtest` |
| `projectName` | Ops Manager project name used for configMap and secret naming | Example: `helm-test-4` |
| `omPublicKey` / `omPrivateKey` | Credentials used to authenticate the operator to Ops Manager | Required |
| `authEnabled` | Enables MongoDB SCRAM authentication | Usually `true` |
| `searchEnabled` | Deploys MongoDB Search alongside the cluster | Optional |
| `tlsEnabled` | Generates TLS certs and configures MongoDB to use them | Optional |
| `launchClientPod` | Creates a `mongosh` pod for direct access | Helpful for testing |

## Deployment patterns

### 1. Replica set with Search

This is the most common quick demo pattern. It creates a MongoDB replica set and attaches a MongoDB Search deployment.

```bash
helm upgrade --install search-test ./quick-cluster --namespace mongodb \
  --set name="searchtest" \
  --set omPublicKey="$OM_PUBLIC_KEY" \
  --set omPrivateKey="$OM_PRIVATE_KEY" \
  --set projectName="helm-test-4" \
  --set type="replicaSet" \
  --set authEnabled=true \
  --set searchEnabled=true
```

This template creates:

- a `MongoDB` replica set resource
- a `MongoDBSearch` resource
- secret-based Ops Manager credentials
- certificate resources only if TLS is enabled

### 2. Sharded cluster with Search and TLS

This example provisions a sharded cluster with search enabled and TLS configured.

```bash
helm upgrade --install search-test ./quick-cluster --namespace mongodb \
  --set name="searchtest" \
  --set omPublicKey="$OM_PUBLIC_KEY" \
  --set omPrivateKey="$OM_PRIVATE_KEY" \
  --set projectName="helm-test-4" \
  --set type="shardedCluster" \
  --set authEnabled=true \
  --set searchEnabled=true \
  --set tlsEnabled=true \
  --set searchLoadBalancerReplicas=2 \
  --set launchClientPod=true
```

### Client pod

When `launchClientPod` is true, the chart creates a pod named `{{ .Values.name }}-mongoclient` using the official `mongo` image. It includes TLS certificate mounts and a helper init-container to combine the cert and key into a PEM file.

The template also includes an example connection command:

```bash
kubectl exec -it -n {{ .Values.namespace }} {{ .Values.name }}-mongoclient -- /bin/mongosh "mongodb://root:password@{{ .Values.name }}-svc.{{ .Values.namespace }}.svc.cluster.local/admin" \
  --tls \
  --tlsCertificateKeyFile=/etc/ssl/mongoclient/pem/mongoclient.pem \
  --tlsCAFile=/etc/ssl/mongoclient/ca/ca.pem
```

## Security notes

This project is intended for test and demo use. The chart includes settings that are acceptable in dev environments but not recommended for production. For example, a default root password of "password"