vagrant-dev-box
===============

This is a baseline Vagrant project for web development. It's growing from a common base VM, the goal being to centralize customization so different sites can be spun up quickly.

### Instructions

If everything works, this is pretty much it:

1. Clone this repository
2. `Vagrant up`

Some Windows machines will need to manually run the provisioner with `vagrant provision` also. 

The VM can be fully configured with settings in the [vagrant/ansible_config.yml][ansible_config] file. Start there if you need to customize something. 

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

* The playbooks currently use features from Ansible 1.4, which is still being actively developed. The easiest way I've found to deal with this is to install Ansible from Github using Pip:  

        pip install git+git://github.com/ansible/ansible.git@devel 

### Caveats

This is a work in progress. Most testing and development is done on Macs, it's checked on Windows every once in a while.

[git]: http://git-scm.com
[ansible]: http://www.ansibleworks.com/
[vagrant]: http://www.vagrantup.com/
[virtualbox]: https://www.virtualbox.org/
[ansible_config]: https://github.com/joemaller/vagrant-dev-box/blob/master/vagrant/ansible_config.yml

[avahi]: http://en.wikipedia.org/wiki/Avahi_%28software%29
[xhprof]: https://github.com/facebook/xhprof
[xdebug]: http://xdebug.org/
