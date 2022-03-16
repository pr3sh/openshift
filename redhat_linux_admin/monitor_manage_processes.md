# **Table of contents**:
  - [Understanding Processes](#understanding-processess)
    - [Process States](#process-states)
    - [Listing Processes](#listing-processes)
  - [Understanding Jobs](#understanding-jobs)
    - [Running Jobs in the Background](#running-jobs-in-the-background)



### **`Understanding Processes`**:

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

##### **`Process States`**:


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

##### **`Listing Processes`**:

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


### **`Understanding Jobs`**:


1. Jobs are processes that the shell manages and each job can be idenitified by its **`job ID`**.
2. Each job has an associated PID. There are three types of job statuses:
3. **Foreground:** When you enter a command in a terminal window, the command occupies that terminal window until it completes. This is a foreground job.
3. **Background:** To execute a job and send it to the background, enter command followed by an ampersand (**`&`**) symbol at the end of a command line, the command runs without occupying the terminal window. The shell prompt is displayed immediately after you press 
4. **Stopped:** Press **`Control + Z`** to stop a foreground job and **`Control  + C`** to terminate it. 
5. Each terminal is its own session, and can have a foreground process and any number of independent background processes. 
7. The **`ps`** command shows the device name of the controlling terminal of a process in the **`TTY`** column. 
    - Processes like system daemons which are started by the system and not from a shell prompt do not have a controlling terminal, are not members of a job, and cannot be brought to the foreground. 
    - The **`ps`** command displays a question mark (**`?`**) in the **`TTY`** column for these processes.


##### **`Running Jobs in the Background`**:

> Start **`job`** in the background. The Bash shell displays a job number (unique to the session) and the **`PID`** of the new child process. 

```zsh
[user@host ~]$ sleep 10000 & 
[1] 5947
[user@host ~]$
```

- When a command line containing a pipe is sent to the background using an ampersand, the **`PID`** of the last command in the pipeline is used as output. All processes in the pipeline are still members of that job.

```zsh
[user@host ~]$ example_command | sort | mail -s "Sort output" & 
[1] 5998
```

- Display list of jobs that Bash is tracking for a session.
```zsh
[user@host ~]$ jobs
[1]+ Running     sleep 10000 & 
[user@host ~]$
```
























