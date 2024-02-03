# Spring Boot 3.2 ArgoCD K8s Application
Demo Spring Boot application that show how to configure ArgoCD and Kubernetes

## Requirements
- [Argo CD](https://argo-cd.readthedocs.io/)
- [Kunernetes](https://kubernetes.io/)
- Install [kubectl](https://kubernetes.io/docs/tasks/tools/).
- [Spring Boot](https://start.spring.io/)
- Java 21
- Ranker Desktop ( - for docker )
- Maven 3.9
- [kubectx and kubens](https://github.com/ahmetb/kubectx?tab=readme-ov-file#kubectl-plugins-macos-and-linux)

Assuming k8s is up and running:
### 1. create the new Argo Cd namespace as follows
```
kubectl create namespace argocd
```

### 2. Install Argo CD
```
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
#### How it works

Argo CD follows the GitOps pattern of using Git repositories as the source of truth for defining the desired application state. Kubernetes manifests can be specified in several ways:
- [kustomize](https://kustomize.io/) applications
- [helm](https://helm.sh/) charts
- [jsonnet](https://jsonnet.org/) files
- Plain directory of YAML/json manifests
- Any custom config management tool configured as a config management plugin

Argo CD automates the deployment of the desired application states in the specified target environments. Application deployments can track updates to branches, tags, or pinned to a specific version of manifests at a Git commit. 
Read more on [link](https://argo-cd.readthedocs.io/en/stable/)

### 3. Change Service Type
By default, the Argo CD API server is not exposed with an external IP. To access the API server, I will change the service type to LoadBalancer as follows:
```
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

### 4. Getting the Argo CD default password
The initial password for the admin account is auto-generated and stored as clear text in the field password in a secret named argocd-initial-admin-secret in your Argo CD installation namespace.
```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```
The copy password that is shown on your commandline up to the character before % .

You can change the admin password by following these steps: (note required for this demo though)
#### - Invalidating Admin Credentials

```
kubectl patch secret argocd-secret -n argocd -p '{"data": {"admin.password": null, "admin.passwordMtime": null}}'
```

#### -  Restarting ArgoCD Server Pods
```
kubectl delete pods -n argocd -l app.kubernetes.io/name=argocd-server
```

#### -  Decrypting the New Password
```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### 5 Expose Argo CD Server using Port Forwarding
Kubectl port-forwarding can also be used to connect to the API server without exposing the service.
```
kubectl port-forward svc/argocd-server -n argocd 8080:443
```
The API server can then be accessed using https://localhost:8080 .

Login using `admin` and password the one shown by step 4 above.