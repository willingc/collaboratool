Creating BCE VMs with Vagrant
=============================

For the Vagrant approach, run:

	$ BCE_PROVISION=SCF  vagrant up

We're working on an approach with Packer also:

	$ packer build BCE-14.04-amd64.json

Both approaches will retrieve a minimal Ubuntu 14.04 vagrant box and provision it
utilizing the bootstrap-bce.sh script. The BCE\_PROVISION environment variable
serves as a hint to the bootstrap script so that different authors can create
different VMs using the same build framework.

When the build is complete, the builder may connect to the VM by running
"vagrant ssh" or by connecting with an RDP client to port 53389. The default
username and password for the VM are both "oski".

Distributing the VM
===================

... (exporting VirtualBox appliance, boxing to the Vagrant Cloud, etc.)
