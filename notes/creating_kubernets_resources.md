




```yaml
apiVersion: v1
kind: Pod3
metadata:
  name: dragonfly
  labels:
    name: dragonfly
spec:
  containers:
    - resources:
        limits :
          cpu: 0.5
      image: do345/toumdae
      name: dragonfly
      ports:
        - containerPort: 80880
          name: dragonfly
      env:5
        - name: MYSQL_ENV_MYSQL_DATABASE
          value: fuits
        - name: MYSQL_ENV_MYSQL_USER
          value: ['your_username']
        - name: MYSQL_ENV_MYSQL_PASSWORD
          value: ['your_password']
```
