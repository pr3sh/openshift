-  **Table of contents**:
  - [Introduction](#introduction)
  - [Output Redirection Operators](#output-redirection)
  - [Editing Textfiles](#editing-textfiles)

#### **`Introduction`:**

1. **`I/O`** redirection changes how processes gets utilize their inputs or outputs. 
	a. *For example*: Instead of getting input from the keyboard, or sending output and errors to the terminal, the process reads from or writes to files.
2. Redirection can be used to discard output or errors so they are not displayed on the
terminal or saved.
3. If you want to discard messages, you can redirect to the special file **`/dev/null`**. 

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

