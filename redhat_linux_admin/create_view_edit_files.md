-  **Table of contents**:
  - [Introduction](#introduction)
  - [Channel Descriptors](#channel-descriptors)
  - [Output Redirection Operators](#output-redirection)
  	- [Examples](examples)
  - [Editing Textfiles](#editing-textfiles)

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

###### **`Examples`:**














