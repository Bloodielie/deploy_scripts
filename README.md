# Scripts for deploy and etc
Init yandex cli
```bash
yc init
```
Create key.json for auth in registry
```bash
yc iam key create --service-account-name server-puller -o key.json
```