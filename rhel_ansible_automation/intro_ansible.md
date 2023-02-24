# **`Abstract`**

Understanding the motivation behind automating Linux administration tasks with Ansible, fundamental Ansible concepts, and Ansible's basic architecture.

-  **Table of contents**:
  - [Infrastructure as Code](#infrastructure-as-code)
  - [What is Ansible](#what-is-ansible)
    - [Ansible is Simple](#ansible-is-simple)
    - [Ansible is Powerful](#ansible-is-powerful)
    - [Ansible is Agentless](#ansible-is-agentless)
  - [Ansible Concepts and Architecture](#ansible-concepts-and-architecture)
  - [Installing Ansible](#installing-ansible)


## **`Infrastructure as Code`**:

- Good automation system allows you to implement Infrastructure as Code practices. 
- *Infrastructure as Code* can be described as using machine-readable automation language to define, and describe the state you want your ***`IT`*** infrastructure to be in. 
- This code is then applied to your infrastructure to ensure that it is actually in that state.
- Ideally, you want an automation language that can be easily read and understood by humans, because then you can easily understand what the state is and make changes to it. 
- If the automation language is represented as simple text files, it can easily be managed in a version control system.
- This ensures that every change is tracked, and can be reverted to if need be.
- Consequently, it builds a foundation to help you follow best practices in **`DevOps`**. 
  - Developers can define their desired configuration in the automation language. Operators can review those changes more easily to provide feedback, and use that automation to reproducibly ensure that systems are in the state expected by the developers.

## **`What is Ansible ?`**:

- Ansible is an *open source* automation platform. 
- It is a simple automation language that can perfectly describe an ***`IT`*** application infrastructure in **`Ansible Playbooks`**. 
- It is also an automation engine that runs **`Ansible Playbooks`**.
- Ansible can manage powerful automation tasks and can adapt to many different workflows and environments. 

> *New users of Ansible can very quickly use it to become productive.*

### **`Ansible is Simple`**:

- **`Ansible Playbooks`** provide *human-readable* automation. 
- No special coding skills are required to write Playbooks. 
- Playbooks execute tasks in order.

### **`Ansible is Powerful`**:

You can use Ansible for a variety of tasks like:
- Deploying applications for configuration management.
- Workflow & Network automation. 
- Ansible can be used to orchestrate the entire application life cycle.

### **`Ansible is Agentless`**:

- Ansible is built around an agentless architecture. 
- Generally speaking, Ansible connects to the hosts it manages using **`OpenSSH`** or **`WinRM`** and runs tasks, often by pushing out small programs called Ansible modules to those hosts. 
- These programs are used to put the system in a specific desired state. Any modules that are pushed are removed when Ansible is finished with its tasks. 
- You can start using Ansible almost immediately because no special agents need to be approved for use and then deployed to the managed hosts. 

> Because there are no agents and no additional custom security infrastructure, Ansible is more efficient and more secure than other alternatives.

## **`Ansible Concepts and Architecture`**:

- There are two types of machines in the Ansible architecture ***control nodes*** and ***managed hosts***. 
- Ansible is installed and run from a control node, and this machine also has copies of your Ansible project files. A control node could be an administrator's laptop, a system shared by a number of administrators, or a server running Red Hat Ansible Tower.
- Managed hosts are listed in an inventory, which also organizes those systems into groups for easier collective management. 
- The inventory can be defined in a static text file, or dynamically determined by scripts that get information from external sources.
- Instead of writing complex scripts, Ansible users create high-level plays to ensure a host or group of hosts are in a particular state. 
- A play performs a series of tasks on the hosts, in the order specified by the play. 
- These plays are expressed in **`YAML`** format in a text file. 
- A file that contains one or more plays is called a playbook.
- Each task runs a module, a small piece of code (written in **`Python`**, **`PowerShell`**, or some other language), with specific arguments. 
- Each module is essentially a tool in your toolkit. 
- Ansible ships with hundreds of useful modules that can perform a wide variety of automation tasks. They can act on system files, install software, or make **`API`** calls.
- Tasks, plays, and playbooks are designed to be *idempotent*, which means that you can safely run a playbook on the same hosts multiple times. 
  - When your systems are in the correct state, the playbook makes no changes when you run it. 
  - There are a handful of modules that you can use to run arbitrary commands. However, you must use those modules with care to ensure that they run in an idempotent way.
- Ansible also uses **`plug-ins`**. 
  - Plug-ins are code that you can add to Ansible to extend it and adapt it to new uses and platforms.
- The Ansible architecture is agentless.  
- Typically, when an administrator runs an **`Ansible Playbook`** or an ad hoc command, the control node connects to the managed host using **`SSH`** (by default) or **`WinRM`**. 
  -  This means that clients do not need to have an Ansible-specific agent installed on managed hosts, and do not need to permit special network traffic to some nonstandard port.



![alt text](https://github.com/pr3sh/openshift/blob/main/rhel_ansible_automation/images/ansible_architecture.png)


## **`Installing Ansible`**:

- The Ansible software only needs to be installed on the control node (or nodes) from which Ansible will be run. 
- Hosts that are managed by Ansible do not need to have Ansible installed.
- Installing the core Ansible toolset involves relatively few steps and has minimal requirements, but installing some additional components that Red Hat Ansible Automation Platform provides (*i.e* the automation controller, formerly called Red Hat Ansible Tower), requires a *Red Hat Enterprise Linux 8.2* or later system, with a minimum of two **`CPUs`**, **`4 GiB`** of **`RAM`**, and **`20 GiB`** of available disk space.
Python 3 (*version 3.5* or later) or Python 2 (*version 2.7* or later) needs to be installed on the control node.


> *If you are running Red Hat Enterprise Linux 8, Ansible can automatically use the platform-python package that supports system utilities that use Python. You do not need to install the python36 or python27 package from AppStream.*

```zsh
[root@controlnode ~]# yum list installed platform-python 
>> Installed Packages
>> platform-python.x86_64 3.6.8-37.el @anaconda
```

- You need a valid Red Hat Ansible Automation Platform subscription to install the core toolset on your control node.

```zsh
#register system to Red Hat Subscription Manager.
[root@host ~]# subscription-manager register
```

```zsh
#enable the Red Hat Ansible repository.
[root@host ~]# subscription-manager repos \ 
 > --enable ansible-2-for-rhel-8-x86_64-rpms
```

```zsh
#install Red Hat Ansible Engine.
[root@host ~]# yum install ansible
```








