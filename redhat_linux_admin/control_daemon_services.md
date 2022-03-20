# **Table of contents**:
  - [Introduction](#introduction)
  - [Understanding Service Units](#understanding-service-units)
  - [Working With Systemctl](#working-with-systemctl)
 

## **`Introduction`**:

The **`systemd`** daemon is responsible for **`Linux`** startup and management of services. *Daemons* are processes that typically run in the background and are generally started automatically at boot time, continuing until shutdown or manually stopped. It is a convention for the names of daemon programs to end in the letter **`d`**.
  - **`systemd`** activates system resources, server daemons, and other processes both at boot time and on a running system.
  - **`systemd`** is the first process that starts up in a *Red Hat Enterprise Linux*, and it is therefore given a Process ID (**`PID`**) of 1. 
  - **`systemd`** provides parallelization capabilities, such as the startup of multiple services simultaneously, which increases system boot speed.
  - On-demand starting of daemons.
  - Automatic service dependency management.
  - Process tracking via control groups.

## **`Understanding Service Units`**:

**`systemd`** uses units to manage different types of objects such as:
- **`Service Units`**: Represent system services (*i.e*: webservers) and have a **`.service`** extension  
- **`Socket Units`** Represent inter-process communication which **`systemd`** should monitor, and have a **`.socket`** extension. 
- **`Path Units`**: Have a **`.path`** extension and are used to delay the activation of a service until a specific file system change occurs. 
- The **`systemctl`** command is used to manage units. 

## **`Working With Systemctl`**:

>  Lists all currently loaded service units. You can pass the **`--all`** flag to also list inactive services.
```zsh
[root@host ~]# systemctl list-units --type=service
```

```zsh
[root@host ~]# systemctl list-units --type=service --all
```
> The **`systemctl list-units`** command displays units that the **`systemd`** service attempts to parse and load into memory.
  

















