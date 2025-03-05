# Makefile for managing KinD cluster and deployment

CLUSTER_CONFIG=cluster/kind-cluster-config.yaml
CLUSTER_NAME=gitops-cluster

.PHONY: create-cluster delete-cluster cluster-info load-image deploy-argocd port-forward-argocd argocd-password list-clusters

# Create KinD cluster
create-cluster:
	kind create cluster --name $(CLUSTER_NAME) --config $(CLUSTER_CONFIG)

# Delete KinD cluster
delete-cluster:
	kind delete cluster --name $(CLUSTER_NAME)

# Get cluster info
cluster-info:
	kubectl cluster-info --context kind-$(CLUSTER_NAME)


# Apply ArgoCD manifests (when ArgoCD is added)
deploy-argocd:
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Port-forward ArgoCD UI to localhost
port-forward-argocd:
	kubectl port-forward svc/argocd-server -n argocd 8080:443

# Get ArgoCD initial admin password
argocd-password:
	@echo "ArgoCD admin password:"
	kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

# List KinD clusters
list-clusters:
	kind get clusters


help:
	@echo "Available commands:"
	@echo "  make create-cluster        - Create a KinD cluster using the specified config"
	@echo "  make delete-cluster        - Delete the KinD cluster"
	@echo "  make cluster-info          - Get cluster info"
	@echo "  make deploy-argocd         - Deploy ArgoCD to the cluster"
	@echo "  make port-forward-argocd   - Forward ArgoCD UI to localhost (access via https://localhost:8080)"
	@echo "  make argocd-password       - Retrieve the initial ArgoCD admin password"
	@echo "  make list-clusters         - List existing KinD clusters"