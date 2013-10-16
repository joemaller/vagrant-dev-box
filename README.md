vagrant-dev-box
===============

This is a baseline Vagrant project for web development. It's growing from a common base VM, the goal being to centralize customization so different sites can be spun up quickly.

### Instructions

If everything works, this is pretty much it:

1. Clone this repository
2. `Vagrant up`

Some Windows machines will need to manually run the provisioner with `vagrant provision` also. 

### What's included

It's a pretty boring stack:

* Apache 2.2.x
* PHP 5.4.x
* MariaDB

Debugging tools are included (and can be disabled):

* [Xdebug][]
* [XHProf][]

The VM includes [Avahi][], so the server will advertise itself over Bonjour/Zeroconf. (not working on Windows)


###Prerequisites

* [Vagrant][] (tested on version 1.3.5)
* [VirtualBox][] (Windows has problems with version 4.3.0, stick with 4.2.18)
* [Git][]

You'll probably want to install [Ansible][] too. Seriously, it's awesome.


### Caveats

This is a work in progress. Most testing and development is done on Macs, it's checked on Windows every once in a while.

[git]: http://git-scm.com
[ansible]: http://www.ansibleworks.com/
[vagrant]: http://www.vagrantup.com/
[virtualbox]: https://www.virtualbox.org/

[avahi]: http://en.wikipedia.org/wiki/Avahi_%28software%29
[xhprof]: https://github.com/facebook/xhprof
[xdebug]: http://xdebug.org/