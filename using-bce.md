---
layout: default
title: Using BCE
---
### Using the existing BCE VM

If you'd like to use the VM as a student, researcher, or instructor, our goal is to make this easy for you.

If you're using VirtualBox, [follow these instructions](using-virtualbox.html).

If you'd like to use the VM on Amazon's EC2 cloud platform, [follow these instructions](using-ec2.html)
  * Go to the "AMIs" tab on the [EC2 management console](http://console.aws.amazon.com). (You'll need to have an account set up.)
  * Choose the US-West-2 (Oregon) region, which is where we have posted the BCE AMI
  * Search for the BCE AMI amongst public images.
  * Launch an instance
  * Follow the instructions given in the "Connect" button to SSH to the instance
  * If you want to connect as the "oski" user, you can deposit your public SSH key in the .ssh folder of the "oski" user.


### Creating (and modifying) the BCE VM

All the files for creating the VM are in the collaboratool repository on GitHub.

To clone the repository from the command line:
         git clone https://github.com/dlab-berkeley/collaboratool

Then go to the provisioning directory and see the information in HOWTO.md.
