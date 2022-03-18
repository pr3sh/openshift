# **Table of contents**:
  - [Understanding Processes](#understanding-processess)
    - [Process States](#process-states)
    - [Listing Processes](#listing-processes)
  - [Understanding Jobs](#understanding-jobs)
    - [Running Jobs in the Background](#running-jobs-in-the-background)
  - [Killing Processes](#killing-processes)
    - [Logging Users Out Administratively](#logging-users-out-administratively)


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

> When a command line containing a pipe is sent to the background using an ampersand, the **`PID`** of the last command in the pipeline is used as output. All processes in the pipeline are still members of that job.

```zsh
[user@host ~]$ example_command | sort | mail -s "Sort output" & 
[1] 5998
```

> Display list of jobs that Bash is tracking for a session.
```zsh
[user@host ~]$ jobs
[1]+ Running     sleep 10000 & 
[user@host ~]$
```

> Bring background **`job`** to the foreground by executing the **`fg`** command with its **`job ID`** (**`%job number`**).

```zsh
 [user@host ~]$ fg %1 
 sleep 10000
```

> Stop foreground process, and send to the background execute **`(Ctrl+z)`**.

```zsh
sleep 10000
^Z
[1]+  Stopped                 sleep 10000
[user@host ~]$
```
The **`ps j`** command displays information relating to jobs. 
  - **`PID`**: Unique process ID of process. 
  - **`PPID`**: **`PID`** of the parent process of this process. 
  - **`PGID`**: **`PID`** of the process group leader.
  - **`SID`**: **`PID`** of the session leader, which (for a job) is normally the interactive shell that is running on its controlling terminal. 
    - Since the example sleep command is currently suspended, its process state is **`T`**.

```zsh
[user@host ~]$ ps j
  PPID PID PGID SID TTY TPGID STAT UID TIME COMMAND 
  2764 2768 2768 2768 pts/0 6377 Ss 1000 0:00 /bin/bash 
  2768 5947 5947 2768 pts/0 6377 T 1000 0:00 sleep 10000 
  2768 6377 6377 2768 pts/0 6377 R+ 1000 0:00 ps j
```

> Start suspended process running in the background.

```zsh
[user@host ~]$ bg %1 
[1]+ sleep 10000 &
```

### **`Killing Processes`**:

Signals can be viewed as an asynchronous notification sent to a process to notify it of an event.

| **`Signal Number`**   |     **`Short Name`**  | **`Definition`**    |  **`Purpose`** |
|-----------------------|:---------------------:|:-------------------:|:--------------:| 
| **`1`**               |    **`HUB`**          | Hangup              |Used to report termination of the controlling process of a terminal. Also used to request process reinitialization (configuration reload) without termination.                |
| **`2`**               |    **`INT`**          | Keyboard interrupt  | Causes program termination. Can be done also using **`Ctrl+c`**               | 
| **`3`**               |    **`QUIT`**         | Keyboard quit       | Similar to **`SIGINT`**; adds a process dump at termination. Sent by pressing QUIT key sequence (**`Ctrl+\`**).               |
| **`9`**               |    **`KILL`**         | Kill, unblockable   | Abrupt program termination.              |
| **`15`**(*Default*)              |    **`TERM`**         | Terminate           | Causes program termination gracefully.   | 
| **`18`**              |    **`CONT`**         | Continue            | Sent to a process to resume, if stopped. |
| **`19`**              |    **`STOP`**         | Stop, unblockable   | Suspends the process.                    |
| **`20`**              |    **`TSTP`**         | Keyboard stop       | Sent by pressing(**`Ctrl+z`**).          |

> Although signal numbers may vary on different **`Linux`** platforms, signal names and meanings are standardized. It is advised to use signal names instead of numbers. The numbers above are for **`x86_64`** systems.

- The **`kill`** command can be used to send signals to a process by **`PID`** number.
- Execute **`kill -l`** to list the names and numbers of all available signals.
- You can use the **`killall`** command to signal multiple processes, based on their *command name*.

> List **`kill`** signals.
```zsh
[user@host ~]$ kill -l
```
> Find running **`jobs`**.
```zsh
[user@host ~]$ ps aux | grep job
5194 0.0 0.1 222448 2980 pts/1 S 16:39 0:00 /bin/bash /home/user/bin/ control job1
5199 0.0 0.1 222448 3132 pts/1 S 16:39 0:00 /bin/bash /home/user/bin/ control job2
5205 0.0 0.1 222448 3124 pts/1 S 16:39 0:00 /bin/bash /home/user/bin/ control job3
5430 0.0 0.0 221860 1096 pts/1 S+ 16:41 0:00 grep --color=auto job 
```
> Send **`TERM`** signal to **`PID`** 5194
```zsh 
[user@host ~]$ kill 5194
```
```zsh
[user@host ~]$ kill 5194
[user@host ~]$ ps aux | grep job
user 5199 0.0 0.1 222448 3132 pts/1 S 16:39 0:00 /bin/bash /home/ user/bin/control job2
user 5205 0.0 0.1 222448 3124 pts/1 S 16:39 0:00 /bin/bash /home/ user/bin/control job3
user 5783 0.0 0.0 221860 964 pts/1 S+ 16:43 0:00 grep --color=auto
job
[1] Terminated control job1
```
> Send **`KILL`** signal to **`PID`** 5199
```zsh
[user@host ~]$ kill -9 5199
```
```zsh
[user@host ~]$ kill -SIGTERM 5205
user 5986 0.0 0.0 221860 1048 pts/1 S+ 16:45 0:00 grep --color=auto
 job
[3]+  Terminated              control job3
```

```zsh
[user@host ~]$ ps aux | grep job
5194 0.0 0.1 222448 2980 pts/1 S 16:39 0:00 /bin/bash /home/user/bin/ control job1
5199 0.0 0.1 222448 3132 pts/1 S 16:39 0:00 /bin/bash /home/user/bin/ control job2
5205 0.0 0.1 222448 3124 pts/1 S 16:39 0:00 /bin/bash /home/user/bin/ control job3
5430 0.0 0.0 221860 1096 pts/1 S+ 16:41 0:00 grep --color=auto job [user@host ~]$ killall control
[1] Terminated           control job1
[2]- Terminated          control job2
[3]+ Terminated          control job3
[user@host ~]$
```
Use **`pkill`** to send a signal to one or more processes that match certain criterias, like **`command name`**, a process owned by a specific user, or all system-wide processes. The **`pkill`** command comes with additional advanced selection criteria:
- **`Command`**:  Processes with a pattern-matched command name.
- **`UID`**: Processes owned by a Linux user account.
- **`GID`**: Processes owned by a Linux group account.
- **`Parent`**: Childprocesses of a specific parent-process.
- **`Terminal`**: Processes running on a specific controlling terminal.

```zsh
[user@host ~]$ ps aux | grep pkill
user 5992 0.0 0.1 222448 3040 pts/1 S 16:59 0:00 /bin/bash /home/ user/bin/control pkill1
user 5996 0.0 0.1 222448 3048 pts/1 S 16:59 0:00 /bin/bash /home/ user/bin/control pkill2
user 6004 0.0 0.1 222448 3048 pts/1 S 16:59 0:00 /bin/bash /home/ user/bin/control pkill3
[user@host ~]$ pkill control
[1] Terminated control pkill1
[2]- Terminated control pkill2
[user@host ~]$ ps aux | grep pkill
user 6219 0.0 0.0 221860 1052 pts/1 S+ 17:00 0:00 grep --color=auto
  pkill
[3]+ Terminated control pkill3
[user@host ~]$ ps aux | grep test
user 6281 0.0 0.1 222448 3012 pts/1 S 17:04 0:00 /bin/bash /home/ 
user/bin/control test1
user   6285  0.0  0.1 222448  3128 pts/1    S    17:04   0:00 /bin/bash /home/
user/bin/control test2
user   6292  0.0  0.1 222448  3064 pts/1    S    17:04   0:00 /bin/bash /home/
user/bin/control test3
user   6318  0.0  0.0 221860  1080 pts/1    S+   17:04   0:00 grep --color=auto
 test
[user@host ~]$ pkill -U user
[user@host ~]$ ps aux | grep test
user 6870 0.0 0.0 221860 1048 pts/0 S+ 17:07 0:00 grep --color=auto
 test
[user@host ~]$
```

##### **`Logging Users Out Administratively`**:

There may be a many reasons to logout users:
  1. Security violation
  2. Resource overuse
  3. Unresponsive system

- To logout a user, you need to use the **`w`** command to list users logged-in/current running processes
- Note the **`TTY`** and **`FROM`** columns to determine the sessions to be closed.

> *All user login sessions are associated with a terminal device (TTY). If the device name is of the form pts/N, it is a pseudo-terminal associated with a graphical terminal window or remote login session. If it is of the form ttyN, the user is on a system console, alternate console, or other directly connected terminal device.*


- Examine logged-in users
```zsh
[user@host ~]$ w
```

- Identify the **`PID`** numbers to be killed using **`pgrep`**.
  - **`preg`** is similar to **`pkill`**, except that **` pgrep`** lists processes rather than killing them.

```zsh
[root@host ~]# pgrep -l -u bob 6964 bash
6998 sleep
6999 sleep
7000 sleep
[root@host ~]# pkill -SIGKILL -u bob 
[root@host ~]# pgrep -l -u bob 
[root@host ~]#
```
- When processes of interest are in the same login session, it may not be necessary to kill all of a user's processes. 
- Determine the controlling terminal for the session using the **`w`** command, then kill only processes referencing the same terminal ID. 

```zsh
[root@host ~]# pgrep -l -u bob 7391 bash
7426 sleep
7427 sleep
7428 sleep
[root@host ~]# w -h -u bob
bob tty3 18:37 5:04 0.03s 0.03s -bash 
[root@host ~]# pkill -t tty3
[root@host ~]# pgrep -l -u bob
7391 bash
[root@host ~]# pkill -SIGKILL -t tty3
[root@host ~]# pgrep -l -u bob
[root@host ~]#
```


The same selective process termination can be applied using parent and child process relationships. Use the pstree command to view a process tree for the system or a single user. Use the parent process's PID to kill all children they have created. This time, the parent Bash login shell survives because the signal is directed only at its child processes.







