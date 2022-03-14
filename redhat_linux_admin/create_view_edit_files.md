
## **Table of contents**:
  - [Introduction](#introduction)
  - [Channel Descriptors](#channel-descriptors)
  - [Output Redirection Operators](#output-redirection)
  	- [Examples](examples)
  - [Editing Textfiles](#editing-textfiles)
  - [Pipelines](#pipelines)
  	- [Tee Command](#tee-command)
  - [Changing the Shell Envionrment](#pipelines)
  	- [Assigning and Retrieving Shell Variables](#assigning-and-retrieving-shell-variables)
  - [Editing Files With Vim](#editing-files-with-vim)
  	- [Starting Vim](#starting-vim)
  	- [Vim Operation Modes](#vim-operation-modes)

  

#### **`Introduction`:**

- Programs and Processes read input and write output to somewhere. 
- Commands ran from the shell prompt typically read input from the keyboard and send output to the terminal window.
- Processes use numbered **`channels`** called *file descriptors* to get input and send output. 
- All processes start with at least three file descriptors. 
	1. **`Standard input (channel 0)`**:  reads input from the keyboard. 
	2. **`Standard output (channel 1)`**:  sends normal output to the terminal. 
	3. **`Standard error (channel 2)`**:  

> *If a program opens separate connections to other files, it may use higher-numbered file descriptors.*

1. **`I/O`** redirection changes how processes gets utilize their inputs or outputs. 
	a. *For example*: Instead of getting input from the keyboard, or sending output and errors to the terminal, the process reads from or writes to files.
2. Redirection can be used to discard output or errors so they are not displayed on the
terminal or saved.
3. If you want to discard messages, you can redirect to the special file **`/dev/null`**. 

#### **`Channel Descriptors`:**
|**`Number`**|  **`Channel Name`**      | 
|------------|:------------------------:|  
| **`0`**    | **`stdin`**              | 
| **`1`**    | **`stdout`**             |   
| **`2`**    | **`stderr`**             |
| **`3+`**   | **`filename`**           |

#### **`Output Redirection Operators`:**
|         **`Operator`** |     **`Description`**                                                | 
|------------------------|:--------------------------------------------------------------------:|  
| **`>  file`**          | Redirect **`stdout`** to *overwrite* a file.                         | 
| **`>> file`**          | Redirect **`stdout`** to *append* a file.                            |   
| **`2> file`**          | Redirect **`stderr`** to *overwrite* a file.                         |
| **`2> /dev/null`**     | Discard **1** error messages by redirecting to **`/dev/null`**.      | 
| **`> file 2>&1`**      | Redirect **`stdout`** and **`stderr`** to *overwrite* the same file. | 
| **`&> file`**          | Redirect **`stdout`** and **`stderr`** to *overwrite* the same file. | 
| **`>> file 2>&1`**     | Redirect **`stdout`** and **`stderr`** to *append* to the same file. |   
| **`&>> file`**         | Redirect **`stdout`** and **`stderr`** to *append* to the same file. |

###### **`Examples`**:
> Redirect the last 10 lines from log file, to another file.

```zsh
[user@host ~]$ tail -n 100 /var/log/dmesg > /tmp/last-100-boot-messages
```
> Redirect the last 10 lines from log file, to another file.

```zsh
[user@host ~]$ cat file1 file2 file3 file4 > /tmp/all-four-in-one
```
> Redirect errors to a file **`/tmp/errors`**, and normal output to the terminal.

```zsh
[user@host ~]$ find /etc -name passwd 2> /tmp/errors
```
> Discard errors and write **`stdout`** to a file.

```zsh
[user@host ~]$ find /etc -name passwd > /tmp/output 2> /dev/null
```
> Append output and generated errors to an existing file.

```zsh
[user@host ~]$ find /etc -name passwd >> /tmp/save-both 2>&1
```
##### **`Pipelines`**:

**Pipelines** allow the output of a process to be manipulated by other **processes** before it is output to the terminal.

```zsh
[user@host ~]$ ls -l /usr/bin | less
```
> Count the number of lines from the **`ls`** command's output.

```zsh
[user@host ~]$ ls | wc -l
```

######  **`Tee Command`**:
In the example below the output of the **`ls`** command, is passed to a file &  the **`less`** command, but nothing will be displayed on the terminal.

```zsh
[user@host ~]$ ls > /tmp/saved-output | less
```

In the example below the output of the **`ls`** command, is passed to a file and to the **`less`** to be
displayed on the terminal one screen at a time.

```zsh
[user@host ~]$ ls -l | tee /tmp/saved-output | less
```

#### **`Changing the Shell Envionrment`**:

Shell variables can be used to modify the shell environment. Exporting these variables allow for them to be used as part of programs that run in the shell.Shell variables are unique to a particular shell session, therefore having two different terminals open means that their environments are different, with its own set of variables.

###### **`Assigning and Retrieving Shell Variables`**:

```zsh
[user@host ~]$  VARIABLENAME=value
```
- You can use the **`set`** command to list all shell variables that are currently set, which also lists shell functions as well.

```zsh
[user@host ~]$ set | less
BASH=/usr/bin/bash 
BASHOPTS=checkwinsize:cmdhist:complete_fullquote:expand_aliases:extglob:extquote:force_fignore:histappend:interactive_comments:progcomp:promptvars:sourcepath 
BASHRCSOURCED=Y
...output omitted...
```
> You can use variable expansion to refer to the value of a set variable by preceding the varible's name with a dollar sign (**`$`**). 
```zsh
[user@host ~]$ file1=/tmp/tmp.log
[user@host ~]$ ls -l $file1
-rw-------. 1 student student 1452 Jan 22 14:39 /tmp/tmp.z9pXW0HqcC 
```
> *Remove file using variable expansion*
```zsh
[user@host ~]$ rm $file1
[user@host ~]$ ls -l $file1
total 0
```

#### **`Editing Files With Vim`**:

- **`Vim`** a more sophisticated version of the **`vi`** editor, distributed with **`Linux`** and **`UNIX`** systems. 
- It is really useful to know how to use at least one text-editor that allows you to edit files through the shell prompt, as it will ensure that you do not need a GUI to edit files on servers (*i.e: remote logins via* **`SSH`**).
- The reason why **`Vim`** might be a great choice to learn as far as editors are concerned is that it is almost always installed on a server, if any text editor is present. 
- This is because **`vi`** was specified by the **`POSIX`** standard that Linux and many other UNIX-like operating systems comply with in large part.
- Vim is also used as the **`vi`** implementation on other common operating systems or distributions (*ie: MacOS*). 


###### **`Starting Vim`**:
- You can open a file for editing by executing **`vi filename`**
- In the case that your server has the *vim-enhanced* package installed, you use can execute the **`vim filename`** instead.

###### **`Vim Operation Modes`**:
- **`Vim*`** starts up in *command mode*, which is used for navigation, cut and paste, and other text manipulation. 
	1. Pressing **`i`** brings you into *insert mode*, where you can type text into the file.
	2. Pressing **`Esc`** from *insert mode* returns you back to *command mode*.
	3. Pressing **`v`** brings you into *visual mode*, and there, multiple characters may be selected for text manipulation. 
		- Use **`Shift+V`** for multiline and **`Ctrl+V`** for block selection. 

> The same keystroke used to enter visual mode (**`v`**, **`Shift+V`** or **`Ctrl+V`**), is used to exit.

- The **`:`** keystroke begins *extended command mode* for tasks such as writing the file (to save it), and quitting the Vim editor.




