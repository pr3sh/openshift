# **`Abstract`**

Use **`OpenSSH`** to configure secure command-line service on remote systems.

-  **Table of contents**:
  - [Infrastructure As Code](#infrastructure-as-code)
  - [Example Commands](#example-commands)


## **`Infrastructure As Code`**:


A good automation system allows you to implement Infrastructure as Code practices. Infrastructure as Code means that you can use a machine-readable automation language to define and describe the state you want your IT infrastructure to be in. Ideally, this automation language should also be very easy for humans to read, because then you can easily understand what the state is and make changes to it. This code is then applied to your infrastructure to ensure that it is actually in that state.
If the automation language is represented as simple text files, it can easily be managed in a version control system. The advantage of this is that every change can be checked into the version control system, ensuring that you have a history of the changes you make over time. If you want to revert to an earlier known-good configuration, you can check out that version and apply it to your infrastructure.
This builds a foundation to help you follow best practices in DevOps. Developers can define their desired configuration in the automation language. Operators can review those changes more easily to provide feedback, and use that automation to reproducibly ensure that systems are in the state expected by the developers.

## **`What is Ansible ?`**:

Ansible is an open source automation platform. It is a simple automation language that can perfectly describe an IT application infrastructure in Ansible Playbooks. It is also an automation engine that runs Ansible Playbooks.
Ansible can manage powerful automation tasks and can adapt to many different workflows and environments. At the same time, new users of Ansible can very quickly use it to become productive.