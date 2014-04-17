Creating BCE VMs with Vagrant
=============================

Run one of:

	$ BCE_PROVISION=SCF  vagrant up
	$ BCE_PROVISION=DLAB vagrant up

This will retrieve a minimal Ubuntu 14.04 vagrant box and provision it
utilizing the bootstrap-bce.sh script. The BCE\_PROVISION environment variable
serves as a hint to the bootstrap script so that different authors can create
different VMs using the same build framework.

When the build is complete, the builder may connect to the VM by running
"vagrant ssh" or by connecting with an RDP client to port 53389. The default
username and password for the VM are both "oski".

Distributing the VM
===================

... (exporting VirtualBox appliance, boxing to the Vagrant Cloud, etc.)
