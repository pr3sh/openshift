## **Table of contents**:
  - [Introduction](#introduction)
  - [Understanding Users](#understanding-users)
  - [Understanding Groups](#understanding-groups)
  - [Switching Users](#switching-users)
  - [Using Sudo](#using-sudo)
    - [Getting Interactive Shell Using Sudo](#getting-interactive-shell-using-sudo)
    - [Configuring Sudo](#configuring-sudo)
  - [Managing Users](#managing-users)
  - [Usermod CLI Options](#usermod-cli-options)

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
- All commands executed using **`sudo`** are logged by default to **`/var/log/secure`**.
- In **RHEL7** and **RHEL8**, all members of the group, **`wheel`** utilize the **`sudo`** to run commands as any user, including **`root`**. The user is prompted for their own password.

###### **`Getting Interactive Shell Using Sudo`:**
- If there is a nonadministrative user account on the system that can use **`sudo su -`** from that account to get an interactive **`root`** user shell. 
- This works because **`sudo`** will run **`su -`** as **`root`**, and **`root`** does not need to enter a password to use **`su`**.
- You can also gain **`root`** acces using using the **`sudo -i`** 

###### **`Configuring Sudo`:**
- The main configuration file for sudo is **`/etc/sudoers`**. 
- To mitigate issues regarding various admins editing the file simultaneously, it should only be edited with the special **`visudo`** command.

> To enable *full* **`sudo`** access for the user **`user01`**, you could create **`/etc/sudoers.d/user01`** with the following content:

```text
user01  ALL=(ALL)  ALL
```

> To enable *full ***`sudo`** access for the group **`group01`**, you could create **`/etc/sudoers.d/group01`**

```text
%group01  ALL=(ALL)  ALL
```

> Set up **`sudo`** to allow a user to run commands as another user without entering their password.

```text
ansible  ALL=(ALL)  NOPASSWD:ALL
```

###### **`Managing Users`:**
- To create a new user, you can use the **`useradd <username>`** command.
- Use the **`usermod`** command to modify an existing user's account details.
- Many defaults, such as the range of valid **`UID`** numbers are read from the **`/etc/login.defs`** file. 
- Values in **`/etc/login.defs`** are only used when creating new users, therefore changing this file does not affect pre-existing users.
- The **`userdel <username>`**  command removes the details of username from **`/etc/passwd`**, but leaves the user's home directory.
- To remove the home directory, you can execute **`userdel -r <username`**.


#### **`Usermod CLI Options`:**

|  **`usermod options`** |     **`Usage`**                                                             | 
|------------------------|:---------------------------------------------------------------------------:|  
| **`-c | --comment`**   | Add user's real name to comment field.                                      | 
| **`-g | --gid `**      | Specify user's primary group.                                               |   
| **`-G | --groups`**    | Specify a comma-separated list of supplementary groups for the user account.|
| **`-a | --append`**    | Used with the **`-G`** option to add the supplementary groups to the user's current set of group memberships instead of replacing the set of supplementary groups with a new set.          | 
| **`-d | -home`**       | Specify a particular home directory for the user account. | 
| **`-m | --move`**      | Move the user's home directory to a new location. Must be used with the **`-d`** option.| 
| **`-s | --shell`**     | Specify login shell for the user account.                                   |   
| **`-L | --lock`**      | Lock user account.                                                          |
| **`-U | --unlock`**    | Unlock user account.                                                        |















