

## **`Introduction`**:

**`Security Context Constraints`** are an OpenShift mechanism, used to restrict access to resources. Security Context Constraits restrict running pods with OCP to the host environment and control:
- Containers running as privileged users.
- Host directories being used as volumes.
- **`SELinux`** context of a container.
- Changing **`UIDs`**.

> In order to see the **`Security Context Constraints`** defined OpenShift, you can run:

**`[user@host ~]$ oc get scc`**

There are 8 default **`Security Context Constraints (SCC)`**: 
1. **`anyuid`**
2. **`hostaccess`**
3. **`hostmount-anyuid`**
4. **`hostnetwork`**
5. **`node-exporter`**
6. **`nonroot`**
7. **`privileged`**
8. **`restricted`**

> Most pods on OpenShift use the **`restricted`** **`Security Context Constraint`** & you can run **`oc describe`** to view the **`SCC`** a pod uses.

```zsh
[user@host ~]$ oc describe pod console-5212312-352 \ 
	> -n openshift-console | grep scc
                      openshift.io/scc: restricted
```
- Images downloaded from public registries like **`Docker Hub`** might fail
 when deploy to OpenShift under the **`restricted SCC`**. 
- A great example would be a container image that requires running as a specific user **`ID`**.
	-  This is because the **`restricted SCC`** runs the container using a random **`user ID`**. 
- Container images that listens on **`port 80`** or **`port 443`** can fail for a similar reason as well. 
- The random **`UID`** used by the **`restricted SCC`** cannot start a service that listens on a privileged network port (port numbers less than 1024). 
- The **`scc-subject-review`** subcommand can help you understand all Security Context Constraints that will enable a container to run. 

```zsh
 [user@host ~]$ oc get pod podname -o yaml |  \ 
 > oc adm policy scc-subject-review -f -
```



