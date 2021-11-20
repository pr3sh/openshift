# **`Abstract`**

-  **Table of contents**:
  - [Introduction](#introduction)
  - [Example Commands](#example-commands)
  - [Identifying Remote Users](#identifying-remote-users)
  - [Understanding SSH Host Keys](#understanding-ssh-host-keys)

###### **`Introduction`:**

**`SSH protocol`** enables systems to communicate in an encrypted and secure manner,over an
insecure network.
- You can use the **`ssh`** command to create a secure connection to a remote system,**` authenticate`**
as a specific user, and get an interactive shell session on the remote system as that user.
-  You may also use the **`ssh`** command to run an individual command on the remote system without running
an interactive shell.

###### **`Example Commands`:**
> Log into remote server as the current local user (**`user01`**). You'll be prompted to enter that user's password.

```zsh
[user01@host ~]$ ssh remotehost
> user01@remotehost's password: redhat
```
> Log into remote server as **`user02`**.

```zsh
[user01@host ~]$ ssh user02@remotehost
> user02@remotehost's password: shadowman
```
> Run the **`hostname`** command on the remotehost as the
**`user02`** without accessing the remote interactive shell.

```zsh
[user01@host ~]$ ssh user02@remotehost hostname
user02@remotehost's password: shadowman
```
###### **`Identifying Remote Users`:**
Use the **`w `** command to display a list of users currently logged into the computer. This will show users are logged in using **`SSH`** from which remote locations, and what they are doing.

```zsh
[user01@host ~]$ ssh user01@remotehost
user01@remotehost's password: redhat
[user01@remotehost ~]$ w
16:13:38 up 36 min, 1 user, load average: 0.00, 0.00, 0.00

USER TTY FROM LOGIN@ IDLE JCPU PCPU WHAT
user02 pts/0 172.25.250.10 16:13 7:30 0.01s 0.01s -bash
user01 pts/1 172.25.250.10 16:24 3.00s 0.01s 0.00s w
[user02@remotehost ~]$ 
```
###### **`Understanding SSH Host Keys`**:
1. SSH secures communication through public-key encryption. 
2. When an **`SSH client`** connects to an **`SSH server`**, the server sends a copy of its public key to the client before the client logs in. 
3. When a user uses the ssh command to connect to an **`SSH server`**, the command checks to see if it
has a copy of the public key for that server in its local **known hosts** files. 
4. The system administrator may have pre-configured it in **`/etc/ssh/ssh_known_hosts`**, or the user may have a **`~/.ssh/
known_hosts`** that contains the key.
5. If the keys do not match, the client assumes that the network traffic
to the server could be hijacked or that the server has been compromised, and seeks the user's
confirmation on whether or not to continue with the connection.
6. If the client does not have a copy of the public key in its known hosts files, the **`SSH`** command
will still prompt you to log in anyway. 

> **`NOTE`**: Set the **`StrictHostKeyChecking`** parameter to **`yes`** in the user-specific
**`~/.ssh/config`** file or the system-wide **`/etc/ssh/ssh_config`** to cause the
ssh command to always abort the **`SSH connection`** if the public keys do not match.

7. If a server's public key is changed because the key was lost due to hard drive failure, or replaced for
some legitimate reason, you will need to edit the known hosts files to make sure the entry for the
old public key is replaced with an entry with the new public key in order to log in without errors.
8. Public keys are stored in the **`/etc/ssh/ssh_known_hosts`** and each users' **`~/.ssh/
known_hosts`** file on the **`SSH client`**. 
9. Each key is on one line. 
    - First field is a list of **`hostnames`** and **`IP addresses`** that share that public key. 
    - Second field is the **`encryption algorithm`** for the key. 
    - The last field is the key itself.


