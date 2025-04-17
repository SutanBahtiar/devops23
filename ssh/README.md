## jump
```
[-J [user@]host[:port]]
[-W host:port]
```

client &#8594; server1 &#8594; server2

```
ssh -J ${user}@${host}:${port} ${user}@${host2} -p ${port}

ssh -J user@server1:2222 user@server2 -p 2222

ssh -J user@10.10.20.5:2222 user@10.20.10.5 -p 2222
```

run command

```
ssh -J user@10.10.20.5:2222 user@10.20.10.5 -p 2222 ls -ltrh
ssh -J user@10.10.20.5:2222 user@10.20.10.5 -p 2222 /home/user/finalize.sh
```

## sshpass
```
-d number     Use number as file descriptor for getting password (number 1 not work dont know why)
-p password   Provide password as argument (security unwise)
-e            Password is passed as env-var "SSHPASS"
```

```
sshpass -p password -P assphrase ssh -p 2222 user@host
sshpass -p password -P assphrase ssh -p 2222 user@host ls -ltrh
sshpass -p password -P assphrase ssh -p 2222 user@host /home/user/finalize.sh
```

```
env SSHPASS="password" sshpass -P assphrase -e ssh -p 2222 user@host

sshpass -d 123 -P assphrase ssh -p 2222 user@host 123<<<"password"

env SSHPASS="password" \
sshpass -d 123 \
ssh -o ProxyCommand="sshpass -P assphrase -e ssh -W %h:%p user@server1 -p 2222" \
user@server2 -p 2222 123<<<"password2"

env SSHPASS="password" \
  sshpass -d 123 \
  scp -P 2222 -o ProxyCommand="sshpass -P assphrase -e ssh -W %h:%p user@server1 -p 2222" \
  file.yaml user@server2:/home/java/deployment/. 123<<<"password2"
```
