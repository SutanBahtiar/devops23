```
  kubectl create deployment echo-web --image sutanirojim/echo-app:v1 --replicas 3
```

```
  kubectl expose deployment echo-web --type LoadBalancer --port 8000 --target-port 8000
```
