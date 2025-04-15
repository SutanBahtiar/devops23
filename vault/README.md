## install 
```
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vault
```

## init
```
export VAULT_ADDR=http://127.0.0.1/8501
export VAULT_TOKEN="token"
```

## seal/unseal
```
vault operator init > vault.keys
vault operator unseal
```

## secret kv
```
vault secrets enable path --path=java kv
```

## create policy
```
vault policy write java-dev -<<EOF
path "java/*" {
   capabilities = [ "create", "read", "update", "list" ]
}
EOF
```

## create token
```
vault token create -orphan -policy="java-dev" -period=43800h

-orphan
      Create the token with no parent. This prevents the token from being
      revoked when the token which created it expires. Setting this value
      requires root or sudo permissions. The default is false.

-policy=<string>
      Name of a policy to associate with this token. This can be specified
      multiple times to attach multiple policies.

-period=<duration>
      If specified, every renewal will use the given period. Periodic tokens
      do not expire (unless -explicit-max-ttl is also provided). Setting this
      value requires sudo permissions. This is specified as a numeric string
      with suffix like "30s" or "5m".

WARNING! The following warnings were returned from Vault:

  * period of "43800h" exceeded the effective max_ttl of "26280h"; period
  value is capped accordingly

Key                  Value
---                  -----
token                hvs.CAESICTjC9swUJ_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
token_accessor       vSPaO8ZwLmGloIHLlHdl6k7C
token_duration       26280h
token_renewable      true
token_policies       ["default" "java-dev"]
identity_policies    []
policies             ["default" "java-dev"]
```
