## **Table of contents**:
  - [Introduction](#introduction)
  - [Understanding Users](#understanding-users)
  - [Understanding Groups](#understanding-groups)



#### **`Understanding Users`:**
There are three main types of user accounts: 
  1. **`Super User:`** 
    - Know as the **`Root`** user.
    - Has complete privileges and access to the system
    - Administers of the system.
  2. **`System User:`**
    - Processes and services like daemons.
    - Do not need nor run with privileged access
    - There isn't any interactive login by the owner of user account.
  3. **`Regular User`**

> Display information about the currently logged-in user.

```zsh
[user01@host ~]$ id
uid=100(user01) gid=1000(user01) groups=1000(user01)
 context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
 ```

> Display information about another user.

```zsh
[user01@host ~]$ id <user_id>
 ```

 > Display processes of all users, along with their associated user ids.

```zsh
[user01@host ~]$ ps -au
 ```
> *The **`/etc/passwd`** file, is a colon delimited file that contains information about our users.*

#### **`Understanding Groups`:**
- Groups are a way of organizing users, and can be used to grant access to resources to a set of users, rather than assigning authorization to each user seperately.
- Groups are uniquely identified by thier **`group ID`** or **`GID`**.
- Systems use the **`/etc/group`** file to store local groups' information.













