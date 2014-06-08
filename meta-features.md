---
layout: default
title: Meta-Features
---
### Desired high-level features of BCE

Here are some notes from our first meeting:
[left](/images/2014-01-24-full-vm-meeting/IMG_20140124_120330.jpg) and
[right](/images/2014-01-24-full-vm-meeting/IMG_20140124_120340.jpg) sides of the
board. And [more](/images/RIT-reading-group.jpg) from a RIT reading group
discussion.

This working document is intended as a way for the BCE working group to agree on the desired features of BCE.

Tentative list of features:

 * VMs:
   - A fixed, versioned VM provided each semester as a binary image for classes
     and workshops
   - Ideally, the same VM usable for research, with functionality for parallel
     computing and provisioned such that it can be used as the VM for virtual
     cluster nodes
   - The VM runnable on user laptops (Mac/Windows/Linux) and on cloud machines
   - The VM usable on user machines with minimal dependencies (e.g., either
     VirtualBox or VMware) and minimal setup, and with clear instructions for
     users on setup and on getting data/files into and out of the VM
   - Agreement on minimal hardware requirements on the host machine - do we
     support 32 bit, any minimum RAM required?

 * Provisioning:
   - The provisioning details used to create a given VM available to users and
     with clear instructions on how to use and modify the provisioning; ideally
     the provisioning would be relatively simple for users to understand
   - The ability for a user to add software to a VM and then 'export' that
     information back into the provisioning workflow that can be used to
     recreate the modified VM

 * Logistics and training
   - A GitHub repository or the like plus a project website with all BCE
     materials available
   - Communication with users on bugs, desired features, and the like via the
     repository and a mailing list
