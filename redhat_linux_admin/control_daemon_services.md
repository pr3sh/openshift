# **Table of contents**:
  - [Introduction](#introduction)
 

The **`systemd`** daemon is responsible for **`Linux`** startup and management of services. *Daemons* are processes that typically run in the background and are generally started automatically at boot time, continuing until shutdown or manually stopped. It is a convention for the names of daemon programs to end in the letter **`d`**.
  - It activates system resources, server daemons, and other processes both at boot time and on a running system.



A service in the systemd sense often refers to one or more daemons, but starting or stopping a service may instead make a one-time change to the state of the system, which does not involve leaving a daemon process running afterward (called oneshot).
In Red Hat Enterprise Linux, the first process that starts (PID 1) is systemd. A few of the features provided by systemd include:
• Parallelization capabilities (starting multiple services simultaneously), which increase the boot speed of a system.
• On-demand starting of daemons without requiring a separate service.
• Automatic service dependency management, which can prevent long timeouts. For example, a network-dependent service will not attempt to start up until the network is available.
• A method of tracking related processes together by using Linux control groups.
