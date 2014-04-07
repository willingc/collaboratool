---
layout: default
title: The Collaboratool Project
---
### Welcome to the Collaboratool Project

Collaboratool is an umbrella project for the creation of reproducible, reliable
scientific computing environments. What problems does this solve for you?

 - No more obscure installation issues - download and run a single virtual
   machine or just visit a server via a web browser.
 - I'm teaching a class - when you tell a student that a program behaves a
   certain way, it does!
 - I'm collaborating on some scientific research - now all of your collaborators
   can run your code without complex installation instructions.

### BCE (Berkeley Computational Environment) Vision

The goal of the collaboratool/BCE project is to provide tools for setting up
reproducible computing environments for classwork and research in the sciences
at Berkeley, broadly defined to include social science, life science, physical
science, and engineering. Using these tools, users will be able to start up a
virtual machine (VM) with a standardized Linux operating environment containing
a set of standard software for scientific computing. The user could start the VM
on their laptop, on a university server, or in the cloud. Furthermore, users
will be able to modify the instructions for producing the virtual machine in a
reproducible way for communication with and distribution to others.

We envision the following core use cases:

  * creating a common computing environment for a course or workshop,
  * creating a common computational environment to be shared by a group of researchers or students, and
  * disseminating the computational environment so outsiders can reproduce the results of a group.
 
To accomplish this, we envision that BCE will encompass the following:

 * a reproducible workflow that creates the standard VM/image
   with standard scientific computing software such as Python, R, git, etc.,
 * a standard binary image, produced by the workflow, that can be distributed as is and
   used on-the-fly with VirtualBox or VMWare Player with minimal dependencies, and
 * (possibly) an augmented workflow that represents multiple possible distributions tailored
   for different types of uses (e.g., different disciplines, different
   computational needs, class vs. research use, etc.). This might
   represent either a sequence or a tree of possible VMs.


### Who are we?

Collaboratool is a project that started in the
[D-Lab](http://dlab.berkeley.edu), with collaboration from
[EECS](http://www.eecs.berkeley.edu) and the [Statistical Computing
Facility](http://statistics.berkeley.edu/computing).
