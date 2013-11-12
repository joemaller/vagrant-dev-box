vagrant-dev-box
===============

This is a baseline Vagrant project for web development. It's growing from a common base VM, the goal being to centralize customization so different sites can be spun up quickly with a modular, dependable toolset. 

### Instructions

If everything works, this is pretty much it:

1. Clone this repository
2. `Vagrant up`

Some Windows machines will need to manually run the provisioner with `vagrant provision` also. (Windows is probably broken right now.)

The VM can be fully configured with settings in the [vagrant/ansible_config.yml][ansible_config] file. Start there if you need to customize something. 

###Experimental SSHFS shared directory
The latest commits switched to using SSHFS to mount the shared folder that Apache serves from. This hasn't been extensively tested yet, but I'm starting to use this across all my projects so any kinks should be worked out shortly. 

SSH must be enabled on the host machine for this to work. 

### What's included

The software stack isn't revolutionary, but it works well:

* Apache 2.2.x
* PHP 5.4.x
* MariaDB
* Node.js with Yeoman (Grunt, Bower and Yo)

PHP Debugging tools are included (and can be disabled):

* [Xdebug][]
* [XHProf][]

The VM includes [Avahi][], so the server will advertise itself over Bonjour/Zeroconf. (not working on Windows)


###Prerequisites

* [Vagrant][] (tested on version 1.3.5)
* [VirtualBox][] (Windows has problems with version 4.3.0, stick with 4.2.18)
* [Git][]

You'll probably want to install [Ansible][] too. Seriously, it's awesome.

### Ansible Development version
The Ansible provisioning playbooks currently use features from Ansible 1.4, which is still being actively developed. The easiest way I've found to deal with this in one shot is to Pip-install Ansible directly from Github:
    
    pip install git+git://github.com/ansible/ansible.git@devel 

Note that installing directly from Github will break requirements.txt files since the repository information is not stored in the file. 

The other option is to install the release-version of Ansible with Pip to take care of dependencies, then clone Ansible from [github/ansible](https://github.com/ansible/ansible) and then run `source ansible/hacking/env-setup`

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
