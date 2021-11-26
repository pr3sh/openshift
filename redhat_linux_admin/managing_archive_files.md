

#### **`Introduction`**:


- Archiving and compressing files are extremely beneficial creating backups or transferring data across a network.
-  Using tar, lots of files can be gathered into a single file, called an Archive. 
- A tar archive is a structured sequence of file data mixed in with metadata about each file and an index so that individual files can be extracted. 
- Archives can be compressed using **`gzip`**, **`bzip2`**, or **`xz`** compression.




		tar -cf etc-backup-$(date +%F).tar /etc
		tar -czf etc-backup-$(date +%F).tar.gz /etc
		tar -cjf etc-backup-$(date +%F).tar.bz /etc
		tar -cJf etc-backup-$(date +%F).tar.xz /etc 

		# List archive 
		tar -tf /etc.tar


		tar -xf etc.tar

		**`file [COMMAND]`**




		scp -r student@servera:/tmp .


