### 1. Hapus Alloy

```
  sudo systemctl stop alloy
  sudo apt-get purge alloy -y
  sudo rm -rf /etc/alloy /var/lib/alloy /etc/systemd/system/alloy.service.d
```

### 2. Hapus MicroK8s (Snap)
```
  sudo microk8s stop
  sudo snap remove microk8s --purge
```

### 3. Bersihkan sisa jaringan & folder sisa (Penting!)
```
  sudo rm -rf ~/snap/microk8s
  sudo rm -rf /var/snap/microk8s
  sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F && sudo iptables -X
```

### 4. Reboot (Disarankan agar interface jaringan virtual bersih)
```
  sudo reboot
```

---

### 1. Install MicroK8s
```
  sudo snap install microk8s --classic
```

### 2. Gabungkan user ke group microk8s agar tidak selalu pakai sudo
```
  sudo usermod -aG microk8s $USER
  mkdir -p ~/.kube
  sudo chown -f -R $USER ~/.kube
```

### 3. Tunggu sampai ready dan nyalakan addon dasar
```
  sudo microk8s status --wait-ready
  sudo microk8s enable dns storage
```

### 4. AKTIFKAN READ-ONLY PORT (Untuk Monitoring)
```
  echo "--read-only-port=10255" | sudo tee -a /var/snap/microk8s/current/args/kubelet
  sudo microk8s stop
  sudo microk8s start
```

---

### 1. Install Alloy
```
  wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
  echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/list.d/grafana.list
  sudo apt-get update && sudo apt-get install alloy -y
```

### 2. Set Alloy Jalan sebagai Root
```
  sudo mkdir -p /etc/systemd/system/alloy.service.d
  echo -e "[Service]\nUser=root\nGroup=root" | sudo tee /etc/systemd/system/alloy.service.d/override.conf
  sudo systemctl daemon-reload
```

---

```
  curl -s http://127.0.0.1:12345/metrics | grep loki_write_sent_lines_total
```
