kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl diff -f - -n kube-system

kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.9/config/manifests/metallb-native.yaml

# kubectl api-resources | grep metallb

kubectl apply -f https://raw.githubusercontent.com/SutanBahtiar/devops23/refs/heads/master/k8s/metallb-IPAddressPool.yaml

# kubectl -n metallb-system get IPAddressPool
# NAME         AUTO ASSIGN   AVOID BUGGY IPS   ADDRESSES
# first-pool   true          false             ["10.50.50.50-10.50.50.100"]

kubectl apply -f https://raw.githubusercontent.com/SutanBahtiar/devops23/refs/heads/master/k8s/metallb-L2Advertisement.yaml

# kubectl -n metallb-system get L2Advertisement
# NAME         IPADDRESSPOOLS   IPADDRESSPOOL SELECTORS   INTERFACES
# sandbox-l2   ["first-pool"]
