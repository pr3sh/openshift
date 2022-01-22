

## **`Introduction`**:

**`Security Context Constraints`** are an OpenShift mechanism, used to restrict access to resources. Security Context Constraits restrict running pods with OCP to the host environment and control:
- Containers running as privileged users.
- Host directories being used as volumes.
- **`SELinux`** context of a container.
- Changing **`UIDs`**.

> In order to see the **`Security Context Constraints`** defined OpenShift, you can run:

**`[user@host ~]$ oc get scc`**

There are 8 default **`Security Context Constraints (SCC)`**: 
