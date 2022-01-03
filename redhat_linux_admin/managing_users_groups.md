## **Table of contents**:
  - [Introduction](#introduction)
  - [Understanding Users](#understanding-users)
  - [Understanding Groups](#understanding-groups)
  - [Switching Users](#switching-users)
  - [Using Sudo](#using-sudo)

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
- Groups are a way of organizing users, and can be used to grant access to files, to a set of users, rather than assigning authorization to each user seperately.
- Groups are uniquely identified by thier **`group ID`** or **`GID`**.
- Systems use the **`/etc/group`** file to store local groups' information.
- Every user has exactly one primary group. 
- When you create a new **`regular user`**, a new group with the same name is also created & becomes the primary group for the new user.
- Users are granted access to files based on whether any of their groups have access. 

#### **`Switching Users`:**

- The **`su`** command can be used a different user account.
- If you run **`su`** from a regular user account, you will be prompted for the **password** of the account to which you *want to switch to*. 
- When **`root`** runs **`su`**, you do not need to enter the user's password.

> Switch to **`user0`**.

```zsh
[user01@host ~]$ su - user01
 >> Password:
```
> Switch to **`root`** by default.

```zsh
[user01@host ~]$ su - 
>> Password:
[root@host ~]#
```

#### **`Using Sudo`:**

- Unlike **`su`**, **`sudo`** normally requires users to enter their own password for authentication, **not the password of the user account they are trying to access**. 
- Users who use **`sudo`** to run commands as **`root`** do not need to know the **`root`** password but instead, use their own passwords to authenticate.
- **`sudo`** can be configured to allow *specific users* to run any command as some other user, or **only some commands as that user**.
F











