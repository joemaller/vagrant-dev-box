
This playbook is intended to provide a single solution for deploying to a production server or Vagrant-based virtual machine. Very few settings need to be changed and all options can be  are in the `/vars/config.yml` file.

 the same playbook can bve applied to one or more VPS instances or used as a Vagrant provisioner. 


This is still chasing the theory that there can be a single, dependable development and production environment which can be spun up quickly for experiments or shared work.


# Deploy instrtuctions

This document contains instructions for deploying to a clean Ubuntu-flavored server. The playbook is also used as the basis for provisioning Vagrant.

Make sure

1. Edit the defaults in  the default user using the `setup.yml` playbook
    
        ansible-playbook setup.yml -i hosts

2. Add the VPS hosts IP address to hosts

3. There are three playbooks which need to be run:

        ansible-playbook setup.yml -i hosts -l vps
        ansible-playbook deploy.yml -i hosts -l vps
        ansible-playbook secure.yml -i hosts -l vps


### Databses
Rather than risk obliterating any current database, if a dumpfile exists it will be loaded into a new database alongside whatever was in use. This way rolling back the database is as simple as changing the reference in `.env.php`.


### Security

Non-vagrant servers are secured using recommendations from [Linode][linode secure] and [Digital Ocean][do secure]. These include setting up an alternate user, locking the root password and installing [Fail2Ban][]. Additionally, the first step of the playbook adds the main user to sudoers with `NOPASSWD: ALL` and then the last step removes that line. 

The admin user's password is reset on each play, passwords are entered into a vars prompt.


### Todo

I'd like to change the default SSH port, but I haven't come up with an idempotent way of doing so. 


### The Playbooks
Meant for Ubuntu/Debian flavored servers, software is installed with **apt** and most testing was done on Ubuntu.

There are two top-level plabooks:

: Vagrant
: VPS

The 
VPS
    - Setup
    - Clone from Github
    - Deploy
    - Secure (based on Digital Ocean's recommendations)

Vagrant
    - Setup
    - Deploy
    - Vagrant-tweaks





### Databases

Database handling is not strictly idempotent. If there's a dumpfile, each run will use that dumpfile to create a new database. I'm more terrified about potentially losing data than I am worried about pure idempotency. If there's a dumpfile the playbooks will leave the server with a functioning database in place. If there's not a dumpfile, they don't do anything to the database. 


### Roles

Roles are mostly generic, except for those in deploy and clone which are specific to a our site layout.

[linode secure]: https://www.linode.com/docs/security/securing-your-server/
[do secure]: https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-12-04
[fail2ban]: http://www.fail2ban.org/