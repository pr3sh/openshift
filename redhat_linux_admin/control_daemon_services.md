# **Table of contents**:
  - [Introduction](#introduction)
  - [Understanding Service Units](#understanding-service-units)
 

## **`Introduction`**:

The **`systemd`** daemon is responsible for **`Linux`** startup and management of services. *Daemons* are processes that typically run in the background and are generally started automatically at boot time, continuing until shutdown or manually stopped. It is a convention for the names of daemon programs to end in the letter **`d`**.
  - **`systemd`** activates system resources, server daemons, and other processes both at boot time and on a running system.
  - **`systemd`** is the first process that starts up in a *Red Hat Enterprise Linux*, and it is therefore given a Process ID (**`PID`**) of 1. 
  - **`systemd`** provides parallelization capabilities, such as the startup of multiple services simultaneously, which increases system boot speed.
  - On-demand starting of daemons.
  - Automatic service dependency management.
  - Process tracking via control groups.

## **`Understanding Service Units`**:
