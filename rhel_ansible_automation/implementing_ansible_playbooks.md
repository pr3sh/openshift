# **`Abstract`**

Understanding how  to create an inventory of managed hosts, write a simple Ansible Playbook, and run the playbook to automate tasks on those hosts.

-  **Table of contents**:
  - [Defining the Inventory](#defining-the-inventory)
  - [Specifying Managed Hosts with a Static Inventory](#specifying-managed-hostss-with-a-static-inventory)
    - [Defining Nested Groups](#defining-nested-groups)
  - [Verifying the Inventory](#verifying-the-inventory)
    - [Overriding the Location of the Inventory](#overriding-the-location-of-the-inventory)


## **`Defining the Inventory`**:

- An inventory defines a collection of hosts that Ansible needs to manage. 
These hosts can also be assigned to groups, which can be managed collectively. 
- *Groups* can contain child groups, and hosts can be members of multiple groups. 
- Host inventories can be defined in two different ways:
  1. A *static* host inventory can be defined by a text file. 
  2. A *dynamic* host inventory can be generated by a script.


## **`Specifying Managed Hosts with a Static Inventory`**:

- A static inventory file is a text file that specifies the managed hosts that Ansible targets. 
- This fie can be written in a number of different formats, including **`INI-style`** or **`YAML`**. 

```text
[webservers]
web1.example.com
web2.example.com
192.0.2.42

[db-servers]
db1.example.com
db2.example.com

[east-datacenter]
web1.example.com
db1.example.com

[west-datacenter]
web2.example.com
db2.example.com

[production]
web1.example.com
web2.example.com
db1.example.com
db2.example.com

[development]
192.0.2.42
```

As illustrated above, managed hosts have been organized into groups. It is important to know that *two* groups always exist.
 - The **`all`** group, which contains every host explicitly listed in the inventory.
 - The **`ungroupd`** host group, which refers to managed hosts listed in the inventory that aren't part of a group.


### **`Defining Nested Groups`**:

- Ansible host inventories can include *groups* of host *groups*. 
- To accomplish this you can create a host group name with the **`:children`** suffix. 

> The below example creates a new group called **`north-america`**, which includes all hosts from the **`usa`** and **`canada`** groups.

```text
[usa]
washington1.example.com
washington2.example.com

[canada]
ontario01.example.com
ontario02.example.com

[north-america:children]
canada
usa
```

> You can specify a range of managed hosts using the **`[START:END]`** (*ie:* 192.168.[4:7].[0:255]). 


## **`Verifying the Inventory`**:


```zsh
[user@controlnode ~]$ ansible washington1.example.com --list-hosts 
hosts (1):
  washington1.example.com
```

```zsh
[user@controlnode ~]$ ansible canada --list-hosts hosts (2):
    ontario01.example.com
    ontario02.example.com
```


## **`Overriding the Location of the Inventory`**:

- The **`/etc/ansible/hosts`** file is considered the system's default static inventory file. 
- However, normal practice is not to use that file but to define a different location for inventory files in your Ansible configuration file. 
- This is covered in the next section.
- The ansible and **`ansible-playbook`** commands that you use to run Ansible *ad hoc* commands and playbooks later in the course can also specify the location of an inventory file on the command line with the **`--inventory`** **`PATHNAME`** or **`-i`** **`PATHNAME`** option, where **`PATHNAME`** is the path to the desired inventory file.











