Creating BCE VMs with Vagrant
=============================

For the Vagrant approach, run:

	$ BCE_PROVISION=SCF  vagrant up

When the build is complete, the builder may connect to the VM by running
"vagrant ssh" or by connecting with an RDP client to port 53389. The default
username and password for the VM are both "oski".

We're working on an approach with Packer also:

	$ packer build BCE-14.04-amd64.json

Both approaches will retrieve a minimal Ubuntu 14.04 vagrant box and provision it
utilizing the bootstrap-bce.sh script. The BCE\_PROVISION environment variable
serves as a hint to the bootstrap script so that different authors can create
different VMs using the same build framework.

Note that it should be possible to attach the bundled ISO for guest additions
using something like the following in the JSON "vboxmanage" section:

```json
[
  "storageattach",   "{{.Name}}",
  "--storagectl",    "IDE Controller",
  "--port",          "1",
  "--device",        "0",
  "--type",          "dvddrive",
  "--medium",        "additions"
]
```

For which you should also switch "guest_additions_mode" to "disable."

But for some reason, I get the complaint:

    VBoxManage: error: Invalid UUID or filename "additions"

Strangely, this DOES work if I execute it during provisioning:

    vboxmanage storageattach "BCE-xubuntu-14.04-amd64" --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium additions

Go figure

Distributing the VM
===================

... (exporting VirtualBox appliance, boxing to the Vagrant Cloud, etc.)
