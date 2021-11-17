# **`Abstract`**

Understand the core concept behind Authentication & Authorization.

-  **Table of contents**:
  - [Introduction](#introduction)
  - [Identity Providers](#identity-providers)



OpenShift has a few primary resources that make up the core components of **authentication** and **authorization**.
- **`User`**:
  - Users represent an actor within the OpenShift Container Platform that interact with the **`API Server`**. 
  - Users can be part of **`groups`**, and can be assigned permissions either individually or via a **`group`**.
- **`Identity`**:
  - The **Identity** resource maintains a record of successful authentication attempts from a specific user & identity provider.
  - Data pertaining to the source of authentication is stored on the identity.
  - Only one user can be associated with an identity. 
- **`Service Account`**:
 - **`Service Accounts`** enable you to control API access withou the need to borrow a user's credentials.
- **`Group`**:
  - Set of users.
  - Users can be assinged to multiple groups.
- **`Role`**:
  - 
