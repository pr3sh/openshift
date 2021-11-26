# **`Abstract`**



-  **Table of contents**:
  - [Introduction](#introduction)
  - [Tar Commands](#tar-commands)
  	- [Operational Options](#operational-options)
  	- [General Options](#general-options)
  	- [Compression Options](#compression-options)
  - [Transferring Files Using Secure Copy](#transferring-files-using-secure-copy)
  - [Transferring Files Using Secure File Transfer](#transferring-files-using-secure-file-transfer)
  - [Sync Files Between Systems](#sync-files-between-systems)
  	- [Enabled Options With Archive Mode](#enabled-options-with-archive-mode)
  	- [Examples](#examples)


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
##### **`Transferring Files Using Secure Copy`**:
The Secure Copy command, **`scp`**, which is part of the **`OpenSSH`** suite, copies files from a remote system to the local system or from the local system to a remote system. The command uses the **`SSH server`** for authentication and encrypts data when it is being transferred.
> Copy the **`/etc/yum.conf`** and **`/etc/hosts`** to the **remoteuser's** home directory on the **remotehost** remote system.

```zsh
[user@host ~]$ scp /etc/yum.conf /etc/hosts remoteuser@remotehost:/home/remoteuser 
> remoteuser@remotehost's password: 
>   yum.conf 	100% 		813 0.8KB/s 	00:00
	hosts 		100% 		227 0.2KB/s 	00:00
```
> Perform similar operation in reverse direction.

```zsh
[user@host ~]$ scp remoteuser@remotehost:/etc/hostname /home/user 
> remoteuser@remotehost's password: password
> hostname 		100% 	  22 0.0KB/s 		00:00
```
> Copy a whole **`/var/log`** directory recursively with the **`-r`** option, into the localhost **`/tmp`** directory.
```zsh
[user@host ~]$ scp -r root@remoteuser:/var/log /tmp
```
##### **`Transferring Files Using Secure File Transfer`**:
To interactively upload or download files from a **`SSH`** server, use the *Secure File Transfer* Program via the **`sftp`** command.
> Steps:
1. **ssh*** into target system [user]@host using **`sftp`** command.
2. Upload to remote host or download to localhost.

> SSH to target host.
```zsh
[user@host ~]$ sftp remoteuser@remotehost remoteuser@remotehost's password: password Connected to remotehost.
sftp>
```
> Create **`hostbackup`** directory in target host system, and upload **`/etc/hosts`**.
```zsh
sftp> mkdir hostbackup
sftp> cd hostbackup
sftp> put /etc/hosts
Uploading /etc/hosts to /home/remoteuser/hostbackup/hosts
/etc/hosts 100% 227 0.2KB/s 00:00 sftp>
```
> Download **`/etc/yum.conf`** from the remote host .

```zsh
sftp> get /etc/yum.conf
Fetching /etc/yum.conf to yum.conf
/etc/yum.conf 100% 813 0.8KB/s 00:00 sftp> exit
[user@host ~]$
```

##### **`Sync Files Between Systems`**:
- The **`rsync`** command is another way to securely copy files from one system to another. 
- A benefit to **`rsync`** is the initial directory synchronization takes about the same time as copying it, subsequent synchronizations only require the differences to be copied over the network.
- The **`-n`** option performs a dry run simulation of what happens when the command gets executed.
Two common options when synchronizing with rsync are the -v and -a options.
- Use the **`-v`** or **`--verbose`** for more output. 
- Use the **`-a`** or **`--archive`** option to enable **"archive mode"**. 
	- This enables recursive copying and turns on many useful command-line options.
	- Archive mode is the same as specifying the options listed below.

###### Enabled Options With Archive Mode:
- **`--recursive`** *or* **`-r`** : Use `gzip` compression.
- **`--links`** *or* **`-l`** : synchronize symbolic links.
	- **NOTE!!** *Hard links are not synchronized, to do that add the* **`-H`** *option*.
- **`--perms`** *or* **`-p`**: preserve permissions.
- **`--times`** *or* **`-t`** : preserve time stamps.
- **`--group`** *or* **`-g`** : preserve the group ownership.
- **`--owner`** *or* **`-o`**:preserve the owner of the files.
- **`--devices`** *or* **`-D`**: synchronize device file.

###### **`Examples`**:

> Synchronize **`/var/log`** to the **`/tmp`** directory on the **remotehost** system:
```zsh
[user@host ~]$ su -
Password: password
[root@host ~]# rsync -av /var/log /tmp receiving incremental file list
log/
log/README
log/boot.log
...output omitted... log/tuned/tuned.log
sent 11,592,423 bytes received 779 bytes 23,186,404.00 bytes/sec total size is 11,586,755 speedup is 1.00
[user@host ~]$ ls /tmp
log ssh-RLjDdarkKiW1
[user@host ~]$















