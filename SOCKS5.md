```
ssh -D 1080 user@ip_host_B
```

```
sudo nano /etc/apt/apt.conf.d/12proxy
```

```
Acquire::http::Proxy "socks5h://127.0.0.1:1080";
Acquire::https::Proxy "socks5h://127.0.0.1:1080";
```
