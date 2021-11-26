# **`Abstract`**



-  **Table of contents**:
  - [Introduction](#introduction)
  - [Tar Commands](#tar-commands)
  	- [Operational Options](#operational-options)
  	- [General Options](#general-options)
  	- [Compression Options](#compression-options)


#### **`Introduction`**:

- Archiving and compressing files are extremely beneficial creating backups or transferring data across a network.
-  Using tar, lots of files can be gathered into a single file, called an Archive. 
- A tar archive is a structured sequence of file data mixed in with metadata about each file and an index so that individual files can be extracted. 
- Archives can be compressed using **`gzip`**, **`bzip2`**, or **`xz`** compression.

##### **`Tar Commands`**
Below are some of the most popular options using in **`tar`** commands.

###### Operational Options:
- **`--create`** *or* **`-c`** : Create a new archive.
- **`--extract`** *or* **`-x`** : Extract an existing archive.
- **`--list`** *or* **`-t`**: List contents of an archive.

###### General Options:

###### Compression Options:
- **`--gzip`** *or* **`-z`** : Use `gzip` compression.
- **`--bzip2`** *or* **`-j`** : Use `bzip2` compression. This generally has a better compression ration than `gzip`.
- **`--xz`** *or* **`-J`**: Use `xz` compression. Generally performs better than `bzip2`.

> Get help on **`tar`** commands using man pages.
```zsh
user@host ~]$ man tar 
```


		tar -cf etc-backup-$(date +%F).tar /etc
		tar -czf etc-backup-$(date +%F).tar.gz /etc
		tar -cjf etc-backup-$(date +%F).tar.bz /etc
		tar -cJf etc-backup-$(date +%F).tar.xz /etc 

		# List archive 
		tar -tf /etc.tar


		tar -xf etc.tar

		**`file [COMMAND]`**




		scp -r student@servera:/tmp .


