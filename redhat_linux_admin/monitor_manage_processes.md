# **Table of contents**:
  - [Understanding Processes](#understanding-processess)



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