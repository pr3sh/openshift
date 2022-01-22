

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