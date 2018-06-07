#!/bin/bash

# Basic Directory definitions.
CURRENT_DIR=$(cd $(dirname $(readlink -f $0 || echo $0)); pwd -P)

#Do cpsuser the job below

CPSUSER_PASSWORD='cpsuser'


expect -c "
	set timeout 5	
	spawn su - cpsuser
	expect \"Password:\"
	send \"${CPSUSER_PASSWORD}\n\"	
	expect \"$\"
	exit 0
"

ls -al
