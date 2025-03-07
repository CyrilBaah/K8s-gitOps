# K8s-GitOps
This project demonstrates a kubernetes GitOps pipeline using:
- [ArgoCD](https://argo-cd.readthedocs.io/en/stable/ "ArgoCD") for continuous delivery
- [Kind](https://kind.sigs.k8s.io/ "Kind") for local cluster setup
- [Python Flask ](https://flask.palletsprojects.com/en/stable/ "Python Flask") as a sample application


## How to set up locally using Docker - **Recommended**
### Prerequisite
- Make sure **Docker** is installed locally. *Checkout installation here* [Docker](https://www.docker.com/ "Docker")
- Make sure **Kind** is installed locally. *Checkout installation here* [Kind](https://kind.sigs.k8s.io/ "Kind")

# Refer to [Makefile](./Makefile) for easy command execution


##  Clone the Repository  

```sh
git clone  https://github.com/CyrilBaah/K8s-gitOps.git
```

## How to setup kubernetes cluster

1. Set up Kubernetes environment
```sh
 make create-cluster
```

## How to install ArgoCD


1. Install Argocd
```sh
 kubectl create namespace argocd
 kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

2. List dependencies
```sh
 kubectl get svc -n argocd 
```

3. Change the argocd-server service type to LoadBalancer:
```sh
 kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

4. Check for available secrets
```sh
 kubectl get secrets -n argocd
```

5. Get the password - the username is admin

```sh
kubectl get secret -n argocd argocd-secret -o jsonpath="{.data.admin\.password}" | base64 --decode && echo
```

5. Reset ArgoCD Admin Password

```sh
 kubectl -n argocd patch secret argocd-secret -p '{"stringData": {"admin.password": "your-password-here"}}'
```

6. Restart the ArgoCD server

```sh
 kubectl delete pod -n argocd -l app.kubernetes.io/name=argocd-server
```

7. Port Forwarding
```sh
 kubectl port-forward svc/argocd-server -n argocd 8080:443
```

## Few Troubleshooting Commands on ArgoCD
1. Check internet Connectivity - Ensure your KinD cluster can access the internet
```sh
kubectl run curl-test --image=busybox --restart=Never --rm -it -- wget -q --spider https://google.com && echo "Internet OK" || echo "No Internet"
```

2. Verify ArgoCD Image Pull Policy - Check the image pull errors
```sh
kubectl describe pod -n argocd argocd-pod-name
```

3.  Restart Failing Pods - If network and image issues are resolved, restart ArgoCD:
```sh
kubectl delete pod -n argocd --all
```
Wait for few minutes
```sh
kubectl get pods -n argocd
```

4. Check for Missing Secrets - The error CreateContainerConfigError often happens due to missing secrets.
```sh
kubectl get secrets -n argocd
```

5. Manually reset the admin password
```sh
NEW_PASSWORD="your-password-here"
HASHED_PASSWORD=$(htpasswd -nbBC 10 "" "$NEW_PASSWORD" | tr -d ':\n' | sed 's/$2y/$2a/')

kubectl patch secret -n argocd argocd-secret -p "{\"stringData\": {\"admin.password\": \"$HASHED_PASSWORD\", \"admin.passwordMtime\": \"$(date -u +'%Y-%m-%dT%H:%M:%SZ')\"}}"
```
Reset ArgoCD Server
```sh
kubectl delete pod -n argocd -l app.kubernetes.io/name=argocd-server
```
