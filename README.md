# Real-Time-K8-RBAC

##### admin-sa.yml

```bash
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin   
  namespace: default
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: admin-role
rules:
  - apiGroups: ["*"]
    resources: ["*"]
    verbs: ["*"]

---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-rolebinding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: admin-role
subjects:
  - kind: ServiceAccount
    name: admin
    namespace: default
```

##### genreal-sa.yml

```bash

apiVersion: v1
kind: ServiceAccount
metadata:
  name: general   
  namespace: default
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: general-role
rules:
  - apiGroups: [""]
    resources: ["pods", "services", "endpoints", "namespaces"]
    verbs: ["get", "list", "watch"]

  - apiGroups: ["apps", "extensions"]
    resources: ["deployments", "replicasets", "daemonsets", "statefulsets"]
    verbs: ["get", "list", "watch"]

  - apiGroups: ["batch"]
    resources: ["jobs", "cronjobs"]
    verbs: ["get", "list", "watch"]  

---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: general-rolebinding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: general-role
subjects:
  - kind: ServiceAccount
    name: general
    namespace: default

```

##### others-sa.yml

```bash

apiVersion: v1
kind: ServiceAccount
metadata:
  name: others  
  namespace: default
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: others-role
rules:
  - apiGroups: [""]
    resources:  ["namespaces"]
    verbs: ["get", "list", "watch"]

---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: others-rolebinding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: others-role
subjects:
  - kind: ServiceAccount
    name: others
    namespace: default

```

# Apply these configuration
```bash
kubectl apply -f admin-sa.yml
kubectl apply -f general-sa.yml
kubectl apply -f others-sa.yml

```
# Generate Tokens for ServiceAccounts
```bash
# for admin service account
kubectl create token admin -n default
# for general service account
kubectl create token general -n default
# for others service account
kubectl create token others -n default
```

# 3. Create Kubeconfig files

Use the tokens generated in the previous step to create kubconfig files for each Serviceacccount

##### Example:admin-kubconfig.yml

Save the content to `admin-kubeconfig.yml`

```bash
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJZCt1WDRNSjVsVU13RFF
    server: https://172.31.45.104:6443   # Your K8s API server endpoint
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: admin
  name: admin-context
current-context: admin-context
kind: Config
preferences: {}
users:
- name: admin
  user:
    token: <admin-token>   # Replace with the generated token

```
### Replace <admin-token> with the acutal token generated for the admin serviceAccount.
#### Repeat this process for the general and others serviceaccount ,creating separate kubeconfig files.

`general-kubeconfig.yml`

Save this content to `general-kubeconfig.yml`
```bash

apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJZCt1WDRNSjVsVU13RFF
    server: https://172.31.45.104:6443   # Your K8s API server endpoint
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: general
  name: general-context
current-context: general-context
kind: Config
preferences: {}
users:
- name: general
  user:
    token: <general-token>   # Replace with the generated token

```
`others-kubeconfig.yml`

Save this content to `others-kubeconfig.yml`
```bash

apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJZCt1WDRNSjVsVU13RFF
    server: https://172.31.45.104:6443   # Your K8s API server endpoint
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: others
  name: others-context
current-context: others-context
kind: Config
preferences: {}
users:
- name: others
  user:
    token: <others-token>   # Replace with the generated token

```

# 4. Use the kubconfig files

Set the `KUBECONFIG` environment variable to point to the desired kubconfig file.

```bash
export KUBECONFIG=/path/to/admin-kubconfig.yml
```
You can now use `kubectl` with permission of the admin seviceaccount .similarly,switch the `KUBECONFIG` environmnet variable to point to `admin-kubeconfig.yml` or `general-kubconfig.yml` or `others-kubconfig.ym`l to use the respective SeviceAccount

## Example commands:

```bash
# use the admin kubci=onfig
export KUBECONFIG=/path/to/admin-kubconfig.yml
kubectl get pods

# use the general kubci=onfig
export KUBECONFIG=/path/to/general-kubconfig.yml
kubectl get pods

# use the admin kubci=onfig
export KUBECONFIG=/path/to/others-kubconfig.yml
kubectl get pods

```