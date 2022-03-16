# **Table of contents**:
  - [Understanding Processes](#understanding-processess)
    - [Process States](#process-states)
    - [Listing Processes](#listing-processes)
  - [Understanding Jobs](#understanding-jobs)



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
3. Foreground: When you enter a command in a terminal window, the command occupies that terminal window until it completes. This is a foreground job.
2. Background: When you enter an ampersand (&) symbol at the end of a command line, the command runs without occupying the terminal window. The shell prompt is displayed immediately after you press Return. This is an example of a background job.
3. Stopped: If you press Control + Z for a foreground job, or enter the stop command for a background job, the job stops. This job is called a stopped job.

Job control is a feature of the shell which allows a single shell instance to run and manage multiple commands.
A job is associated with each pipeline entered at a shell prompt. All processes in that pipeline are part of the job and are members of the same process group. If only one command is entered at a shell prompt, that can be considered to be a minimal “pipeline” of one command, creating a job with only one member.
Only one job can read input and keyboard generated signals from a particular terminal window at a time. Processes that are part of that job are foreground processes of that controlling terminal.
A background process of that controlling terminal is a member of any other job associated
with that terminal. Background processes of a terminal cannot read input or receive keyboard generated interrupts from the terminal, but may be able to write to the terminal. A job in the background may be stopped (suspended) or it may be running. If a running background job tries to read from the terminal, it will be automatically suspended.
Each terminal is its own session, and can have a foreground process and any number of independent background processes. A job is part of exactly one session: the one belonging to its controlling terminal.
The ps command shows the device name of the controlling terminal of a process in the TTY column. Some processes, such as system daemons, are started by the system and not from a shell prompt. These processes do not have a controlling terminal, are not members of a job, and cannot be brought to the foreground. The ps command displays a question mark (?) in the TTY column for these processes.





























