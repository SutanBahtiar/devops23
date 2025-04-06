```
  kubectl create deployment echo-web --image sutanirojim/echo-app:v1 --replicas 3
```

```
  kubectl expose deployment echo-web --type LoadBalancer --port 8000 --target-port 8000
```

```
  for i in $(seq 1 10); do curl 10.20.0.8:8000; done;
```
