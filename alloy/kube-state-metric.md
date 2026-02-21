### install kube-state-metrics
```
git clone https://github.com/kubernetes/kube-state-metrics.git
cd kube-state-metrics/examples/standard
sudo microk8s kubectl apply -f .
```

### create service nodeport
```
apiVersion: v1
kind: Service
metadata:
  name: kube-state-metrics-external
  namespace: kube-system
spec:
  type: NodePort
  selector:
    app.kubernetes.io/name: kube-state-metrics
  ports:
    - name: http
      port: 8080
      targetPort: 8080
      nodePort: 30080
```

### check metrics
```
curl 10.128.0.2:30080/metrics
```
