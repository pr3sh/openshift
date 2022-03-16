# **Table of contents**:
  - [Understanding Processes](#understanding-processess)
  - [Process States](#process-states)
  - [Listing Processes](#listing-processes)



#### **`Understanding Processes`**:

Processes are running instances of an executable program and they are comprised of the following:
- Address space of allocated memory.
- Security attributes (*i.e: Authorization Credentials/ Ownership*)
- Execution threads 
- The environment of a process includes:
  1. **`Local`** and **`global`** variables
  2. A current scheduling context
  3. Allocated system resources (*i.e: networkports*)
- Processes are identified by a unique **`process ID`** (**`PID`**) for tracking
and security. 
- Any process can create a child process. 
- All processes are descendants of the first system process, **`systemd`** on a Red Hat Enterprise Linux 8 system).

#### **`Process States`**:


|         **`Name`**  |     **`FLAG`**                    |  **`Kernel Defined State Name`**   |
|------------------------|:---------------------------------:|:-----------------:| 
| **`Running`**          |**`R`**                            |  **`TASK_RUNNING`**                  |
| **`Sleeping`**         | (**`S`** \| **`D`** \|**`K`** \| **`I`**) | **`TASK_INTERRUPTIBLE`** \|**`TASK_UNINTERRUPTIBLE`** \| **`TASK_KILLABLE`**                  | **`TASK_REPORT_IDLE`** \| **``
| **`Stopped`**          |  **`T`**         | **`TASK_STOPPED`** \|  **`TASK_TRACED`**            |
| **`Zombie`**           | (**`Z`** \| **`X`**)   |     **`EXIT_ZOMBIE`** \| **`EXIT_DEAD`**              |


> The **`S`** column of the **`top`** command or the **`STAT`** column of the **`ps`** command lets us know the state of each process. 

```zsh
[user@host ~]$ top
PID USER PR NI VIRT RES SHR S %CPU %MEM TIME+ COMMAND
  1 root 20 0 244344 13684 9024 S 0.0 0.7 0:02.46 systemd
  2 root 20 0 0 0 0 S 0.0 0.0 0:00.00 kthreadd 
...output omitted...
```

```zsh
[user@host ~]$ ps aux
USER PID %CPU %MEM VSZ RSS TTY STAT START TIME COMMAND 
...output omitted...
root 2 0.0 0.0 0 0 ? S 11:57 0:00 [kthreadd] 
student 3448 0.0 0.2 266904 3836 pts/0 R+ 18:07 0:00 ps aux 
...output omitted...
```

#### **`Listing Processes`**:

- To list current processes, execute the **`ps`** command.
- The option **`aux`**, displays all processes including processes without a controlling terminal.
- The A long listing (options **`lax`**) provides more technical detail.
- The similar UNIX syntax uses the options **`-ef`** to display all processes.

```zsh
[user@host ~]$ ps aux
```

```zsh
[user@host ~]$ ps lax
```

```zsh
[user@host ~]$ ps -ef
```



