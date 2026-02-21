### create monitoring rbac
```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: prometheus-external
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: prometheus-external
rules:
- apiGroups: [""]
  resources:
    - nodes
    - nodes/proxy
    - services
    - endpoints
    - pods
  verbs: ["get","list","watch"]
- apiGroups: ["apps"]
  resources:
    - deployments
    - replicasets
    - statefulsets
  verbs: ["get","list","watch"]
- nonResourceURLs: ["/metrics"]
  verbs: ["get"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: prometheus-external
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: prometheus-external
subjects:
- kind: ServiceAccount
  name: prometheus-external
  namespace: kube-system
```

### create token
```
sudo microk8s kubectl -n kube-system create token prometheus-external
```

### create ca.crt
```
sudo microk8s kubectl config view --raw -o jsonpath='{.clusters[0].cluster.certificate-authority-data}' | base64 -d > ca.crt
```


