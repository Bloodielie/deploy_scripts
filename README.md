# Scripts for deploy and etc
Init yandex cli
```bash
yc init
```
Create key.json for auth in registry
```bash
yc iam key create --service-account-name server-puller -o key.json
```

Login docker at the server
```bash
cat key.json | docker login \
  --username json_key \
  --password-stdin \
  cr.yandex
```
