-  **Table of contents**:
  - [Introduction](#introduction)
  - [Output Redirection](#output-redirection)
  - [Editing Textfiles](#editing-textfiles)



1. I/O redirection changes how the process gets its input or output. 
	a. Instead of getting input from the keyboard, or sending output and errors to the terminal, the process reads from or writes to files. Redirection lets you save messages to a file that are normally sent to the terminal window.
   124 RH124-RHEL8.2-en-1-20200928
 Chapter 5 | Creating, Viewing, and Editing Text Files
 	- Alternatively, you can use redirection to discard output or errors, so they are not displayed on the
terminal or saved.
Redirecting stdout suppresses process output from appearing on the terminal. As seen in
the following table, redirecting only stdout does not suppress stderr error messages from displaying on the terminal. If the file does not exist, it will be created. If the file does exist and the redirection is not one that appends to the file, the file's contents will be overwritten.
If you want to discard messages, the special file /dev/null quietly discards channel output redirected to it and is always an empty file.




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