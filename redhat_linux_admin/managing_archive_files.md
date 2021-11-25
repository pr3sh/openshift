



		man tar


		tar -cf etc-backup-$(date +%F).tar /etc
		tar -czf etc-backup-$(date +%F).tar.gz /etc
		tar -cjf etc-backup-$(date +%F).tar.bz /etc
		tar -cJf etc-backup-$(date +%F).tar.xz /etc 

		# List archive 
		tar -tf /etc.tar


		tar -xf etc.tar

		**`file [COMMAND]`**




		scp -r student@servera:/tmp .


