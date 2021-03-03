


#Abstract

Understanding how kubernetes resources are created using the `oc` command-line interface.


### **Introduction:**

- The most common way of interacting with your RHOCP cluster is using the `oc` command line.
  - *Basic Usage:*

``` bash
  $ oc <command>

  # Login to cluster
  $ oc login <cluster_url>`
  #login using access token
  $ oc login https://[IP ADDRESSS]:[PORT] --token=<access_token>
  #Example Login using curl
  $ curl -k https://[IP ADDRESSS]:[PORT]/oapi/v1/projects \
     -H "Authorization: Bearer {access_token}"
  #Login with username and password
  $ oc login -u <your_username> -p <your_password>


    ```

### ** Describing Pod Resources**

- OpenShift needs a pod reousrce defiition to run cntiners nd create pods from a container image.
- This can be generated using the `oc new-app` command.
- Resource definitions can be provided as `JSON` or `YAML` files.
- Resources can also be created within the OpenShift Web UI.

*Example of an appliction server pod definition in `YAML` format:*

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
