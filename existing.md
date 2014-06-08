---
layout: default
title: Existing Projects
---
### Virtualized IPython notebooks

 - [jiffylab](http://github.com/ptone/jiffylab) was the first project we saw
   that did this. It relies on [Docker](http://docker.io) as a primary enabling
   technology.
 - [ipydra](https://github.com/UnataInc/ipydra) is the current home of work
   begun in [ipython-hydra](https://github.com/cni/ipython-hydra). It doesn't
   appear to use the same level of virtualization
 - [ipython-dokku](https://github.com/richstoner/ipython-dokku), perhaps
   unsurprisingly, uses [dokku](https://github.com/progrium/dokku) to achieve similar things.
   [SimpliPy](http://simplipy.org/) uses this to deploy to 
   [Digital Ocean](https://www.digitalocean.com/).
 - [notebookcloud](https://notebookcloud.appspot.com/docs) does something
   similar, but is restricted to EC2.
 - [Continuum Wakari](http://wakari.io) and [picloud](http://picloud.com) offer
   proprietary solutions, though both provide for a certain amount of
   customization. Last time Dav checked, Waraki customization was more limited
   and less reliable than picloud (though it requires less admin knowledge).

### Virtualized RStudio

Similarly, [RStudio Server](RStudio Server) runs through a web interface as
well, but we have yet to identify a solution like jiffylab or the others above.

### devops tools
