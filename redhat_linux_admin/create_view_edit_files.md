-  **Table of contents**:
  - [Introduction](#introduction)
  - [Output Redirection](#output-redirection)
  - [Editing Textfiles](#editing-textfiles)



1. **`I/O`** redirection changes how processes gets utilize their inputs or outputs. 
	a. *For example*: Instead of getting input from the keyboard, or sending output and errors to the terminal, the process reads from or writes to files.
2. Redirection can be used to discard output or errors so they are not displayed on the
terminal or saved.
3. If you want to discard messages, you can redirect to the special file **`/dev/null`**. 

#### **`Helm Commands`:**

|         **`Command`**  |     **`Description`**             | 
|------------------------|:---------------------------------:|  
| **`dependency`**       | Manage a chart's dependencies.    | 
| **`install`**          | Install a chart.                  |   
| **`list`**             | List releases installed           |
| **`pull`**             | Download chart from repository.   |
| **`rollback`**         | Rollback to previous revision.    | 
| **`search`**           | Search for keyword in charts.     | 
| **`show`**             | Display information of a chart.   |   
| **`status`**           | Display status of named release   |
| **`uninstall`**        | Uninstall a release               |
| **`upgrade`**          |Upgrade a release                  | 


Modes: Insert, Extended Command(`:`), Command Mode, Visual (control+v  or shift-v) visual block , visual line
yy - copy
p - paste
5p -paste 5 times
dd - delete line


cw- change word


cursor - H, J, K, L

vimtutor

```zsh
openssl genrsa -out training.key -passout pass:test 2048
```

```zsh
openssl req -new  \
	-subj "/C=US/ST=North Carolina/L=Raleigh/O=Red Hat/CN=wordpresss-apps.apps-crc.testing" \
    -key training.key -out training.csr
```

```zsh
openssl x509 -req -in training.csr  \
	 -signkey training.key  -out training.crt -days 1825 -sha256
```

```zsh
curl --cacert training.crt  https://wordpresss-network-policy.apps-crc.testing -vI
```
================

Method 2

openssl genrsa -out ca.key 4096

openssl req -x509 -key ca.key -out ca.crt -days 365

openssl x509 -noout -text -in ca.crt

open

kafka-console-consumer.sh --topic alerts --bootstrap-server localhost:9092 --from-beginning

kafka-console-consumer.sh --topic fire-calls --from-beginning --bootstrap-server localhost:9092

openssl req -x509 -newkey rsa:4096 -keyout not-ca.key -out not-ca.crt 