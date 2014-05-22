Collaboratool Image Generation
==============================

The safest base image appears to be the vanilla 64-bit ubuntu server image.

There are several approaches we've tested, including:

 1. A 2-step process of manual base OVA creation followed by scripted deployment
 2. Fully scripted process using vagrant
 3. Fully scripted using packer


For Summer 2014
===============

Dav and Ryan identified and implemented the following specifications for the
summer VM (via the packer method, vagrant method is similar, but is not verified
to produce exactly the following):

    - OS: Ubuntu Server 14.04 (64-bit)
        + Python packages installed via pip/easy_install since it is likely they
          will need to be upgraded mid-term while the Ubuntu python-* packages
          do not change.
        + R packages come from rrutter and c2d4u PPAs since they are kept
          up-to-date while the Ubuntu r-cran-* packages do not change.
        + Hide the grub menu and Linux kernel boot messages.
    - User: Single auto-login user ("oski") with no password sudo. Insecure
      default password of "oski".
    - VirtualBox:
        + Window is resizable for XFCE on Ubuntu (note, not for LXDE).
        + bidirectional clipboard enabled
        + bidirectional drag-n-drop enabled
    - Desktop: XFCE
        + One panel with launchers for Terminal, Browser, File Manager, Text
          Editor
        + Substitute solid color for background image
        + Remove desktop icon for Trash and File System. Leave Home icon.
        + Benoit and Ryan suggest an icon on the desktop pointing to /media,
          VirtualBox's parent of all Shared Folders.
        + Black-on-white text in terminal since it is easier to see when
          projected in class
        + Change the panel's Application menu icon to a generic computer icon
          from XFCE's logo.

### Undecided

    - Dav would like to have some git GUI. Thunar and gedit both have git
      integration but Thunar is pretty weak, gitg seems to be the standard gtk
      version (thus suitable for unity, LXDE, XFCE...). Need to evaluate Thunar
      for 14.04 still.
    - Hiding messages, etc. maybe doesn't fit in with the "glass brick" model
      where we don't hide the plumbing.

### Future Tasks

    - Investigate box file format to reduce size


Instructions for building a base OVA for 2-step process (not currently used)
============================================================================

I've created a v1.0 OVF file immediately after verifying the ubuntu server VM
booted in VirtualBox.

Figuring out the right settings for the debian installer, etc. is a PITA (but,
now solved). One way to avoid dealing with debian installer is to do a minimal
install by hand. In addition to doing the vanilla install (including an OpenSSH
server), we do the following. It's something we only need to do once to get to
the base image, and is pretty few steps:

    # Probably just need core xserver, guest extensions install their own driver
    apt-get install dkms xserver-xorg
    # Maybe do all updates?
    # Manually mount the Guest Extensions, "insert" using the VBox GUI
    sudo mount /dev/cdrom /mnt
    sudo /mnt/VBoxLinuxAdditions.run

Then just save this as our "Collaboratool Base32" OVA, again using the
VirtualBox GUI.


