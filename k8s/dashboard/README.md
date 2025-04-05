Create Token
```
  kubectl -n kubernetes-dashboard create token admin-user
```

After Secret is created, we can execute the following command to get the token which is saved in the Secret:
```
  kubectl get secret admin-user -n kubernetes-dashboard -o jsonpath="{.data.token}" | base64 -d
```

---

[Creating Sample User docs](https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md)
