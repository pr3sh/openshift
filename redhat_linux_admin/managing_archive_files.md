# **`Abstract`**



-  **Table of contents**:
  - [Introduction](#introduction)
  - [Tar Commands](#tar-commands)
  	- [Operational Options](#operational-options)
  	- [General Options](#general-options)
  	- [Compression Options](#compression-options)
  - [Transfering Files Securely](#transferring-files-securely)


##### **`Introduction`**:

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
- **`--verbose`** *or* **`-v`** 
- **`--file`** *or* **`-f`** 
- **`--preserve-permissions`** *or* **`-p`**: Preserve the permissions of files and directories when extracting an archive, without subtracting the **umask**.

###### Compression Options:
- **`--gzip`** *or* **`-z`** : Use `gzip` compression.
- **`--bzip2`** *or* **`-j`** : Use `bzip2` compression. This generally has a better compression ration than `gzip`.
- **`--xz`** *or* **`-J`**: Use `xz` compression. Generally performs better than `bzip2`.

> Get help on **`tar`** commands using man pages.

```zsh
user@host ~]$ man tar 
```
> Create archive **`archive.tar`** from files.

```zsh
[user@host ~]$ tar -cf archive.tar file1 file2 file3 
[user@host ~]$ ls archive.tar
> archive.tar
```
> *Alternatively*

```zsh
[user@host ~]$ tar --file=archive.tar --create file1 file2 file3
```
> Create tar archive named **`/root/etc.tar`** from **`/etc`**.

```zsh
[root@host ~]# tar -cf /root/etc.tar /etc 
```
> List contents of the **`/root/etc.tar`** archive.

```zsh
[root@host ~]# tar -tf /root/etc.tar 
etc/fstab
etc/crypttab
etc/mtab
```

> Extract files from the **`/root/etc.tar`** archive.

```zsh
[root@host etcbackup]# tar -xf /root/etc.tar
```
> Extract files from the **`/root/myscripts.tar`** archive while preserving extracted file permissions.

```zsh
[root@host scripts]# tar -xpf /root/myscripts.tar
```
> Create **`gzip`** compressed archive named **`/root/etcbackup.tar.gz`**, from **`/etc`**.

```zsh
 [root@host ~]# tar -czf /root/etcbackup.tar.gz /etc 
 > tar: Removing leading `/' from member names
```
##### **`Transferring Files Securely`**:





```zsh
[user@host ~]$ scp /etc/yum.conf /etc/hosts remoteuser@remotehost:/home/remoteuser 
> remoteuser@remotehost's password: 
>   yum.conf 	100% 		813 0.8KB/s 	00:00
	hosts 		100% 		227 0.2KB/s 	00:00
```












