
This is a baseline playbook intended to provide a single solution for deploying to a production server or Vagrant-based virtual machine. Very few settings need to be changed and all options can be set in the `/vars/config.yml` file.



This is still chasing the theory that there can be a single, dependable development and production environment which can be spun up quickly for experiments or shared work.

## Prerequisites
The following software packages should be installed, full instructions are below:

* Vagrant
* VirtualBox
* Ansible

# Deploy Instructions

My intention for this project is to have a baseline box up and running with virtually no fiddling. From an initial checkout, the project will create a functional Vagrant box without modifying the default settings. 
    
    $ git clone https://github.com/joemaller/vagrant-dev-box.git
    $ cd vagrant-dev-box
    $ vagrant up

Add a hosts file and the same playbook can configure a remote server (tested with [Digital Ocean][do] and [Linode][]). (make sure you've first set up ssh-key logins manually or with `ssh-copy-id`)

    $ ssh-copy-id root@123.45.67.89
    $ echo 123.45.67.89 > hosts
    $ ansible-playbook deploy/main.yml -i hosts

From here, it's very easy to modify the handful of configuration settings to customize the server. Below is a description of each setting.

Any additional tasks specific to a given deployment should be entered into the bottom Tasks section of the `main.yml` playbook.

### Configuration Settings

* **`site_name`**  
    A nickname for the site, defaults to the server's hostname

* **`admin_user`**  
    Name of the admin user, defaults to `{{ sitename }}web`

* **`site_root`**  
    Directory containing all the files used by a web site. This is usually where files like `composer.json` or `package.json` live.

* **`document_root`**  
    The public entry point for a web site. Usually a subfolter of `site_root`, something like `{{ site_root }}/app` or `{{ site_root }}/web`. Defaults to `{{ site_root }}/public`.

* **`dev`**  
    Set this to true to install dev tools like [XHProf][], [PHPUnit][] and [Xdebug][] as well as any dev-dependencies in `composer.json`. Defaults to true when provisioning Vagrant boxes.

* **`git_repo`**  
    Address of a Git repository to deploy to the server. Vagrant skips this step and uses the current directory instead. Repository urls should use `https` or they will be assumed to be private.

* **`git_private_key`**  
    SSH private key to use when checking out a private repository from Github.

* **`sql_dumpfile`**  
    Location of a sql dumpfile to load into the database. 

#### Additional Settings

* **`composer_dir`**  
    Specify the location of `composer.json`, can be used to accommodate Laravel's default install layout. Defaults to `{{ site_root }}`.

* **`database_engine`**  
    Choose between MariaDB or MySQL. Defaults to `mariadb`


## What gets installed

Though Ansible playbooks are highly-readable, here's a semi-brief rundown of everything that gets installed and configured:

1. Create admin user
2. Make sure the `site_root` directory exists
3. Install Git
4. Clone `git_repo` into `site_root` (if not Vagrant)
5. Secure the server (if not Vagrant)
    - Install fail2ban
    - Lock the root password
6. Install Apache2
    - Install mod-rewrite, mod-expires and mod-headers
    - Deactivate existing Virtual Hosts
    - Enable a new Virtual Host
7. Install node.js
8. Install MariaDB (or MySQL)
    - Generate a random root password
    - Setup root `.my.conf`
    - remote the MySQL test database
9. Install [vsftpd][] and configure FTP virtual users
10. Install PHP
    - Including php-cli, php-curl, php-mcrypt and php-mysql
    - Setup default timezone
    - Turn off all errors
    - Install Composer
11. Install PHP debug tools (if dev==true, default true for Vagrant)
    - Enable all errors
    - Install xDebug, PHPUnit, and XHProf and Composer dev-dependencies
12. Install and configure Avahi (aka Bonjour/Zeroconf, only Vagrant)
13. Configure Apache to work from Vagrant's shared directory
14. Generate a new database and populate with dumpfile (if exists)
15. Globally install Gulp and Bower
16. Install Composer dependencies (and optionally dev-dependencies) from `composer.json`
17. Install everything from `package.json`



### Checking out private repositories from Github

The playbooks are able to clone private repositories from Github. To do this, you'll need an authentication keypair already registered with Github. In the vars/config.yml file, set `git_repo` to the ssh address of the private repository and set `git_private_key` to the private key's path on the controller. 

Note that private repository urls should be formatted as `git@github.com:user/repo`, and *not* `ssh://git@github.com:user/repo`.

### Additional Notes

#### The Playbooks
The playbooks are designed around Ubuntu/Debian flavored servers, software is installed with **apt** and all testing was done on Ubuntu 14.

#### Databases
Rather than risk obliterating any current database, existing dumpfiles are loaded into a new database alongside whatever was in use. This way rolling back the database is as simple as switching the webapp's configuration to point at a different database. While wasteful of disk space and not strictly idempotent, this seemed like the safest course of action.

#### Security
Non-vagrant servers are secured using recommendations from [Linode][linode secure] and [Digital Ocean][do secure]. These include the following:

* Create an admin user with a random password
* Lock out root-user password logins with 'passwd -l root'
* Install [Fail2Ban][]. 

It would be nice to change the default ssh port as well, but doing that in an idempotent way with Ansible doesn't seem possible.

## Full setup instructions

If you're setting up a clean mac system, here is every step necessary to get up and running.

1. Install [Xcode][], then open it and accept the user license agreement.
2. Download and install [VirtualBox][]
3. Download and install [Vagrant][]
4. Install [Homebrew][]
5. `brew install git nodejs ansible`
6. `vagrant up`

Note: You'll have to enter your password so Vagrant can configure the shared folder interfaces correctly. To skip this, you can add [the following commands][sudoers] to `/etc/sudoers` (use [`visudo`][visudo]:

    Cmnd_Alias VAGRANT_EXPORTS_ADD = /usr/bin/tee -a /etc/exports
    Cmnd_Alias VAGRANT_NFSD = /sbin/nfsd restart
    Cmnd_Alias VAGRANT_EXPORTS_REMOVE = /usr/bin/sed -E -e /*/ d -ibak /etc/exports
    %admin ALL=(root) NOPASSWD: VAGRANT_EXPORTS_ADD, VAGRANT_NFSD, VAGRANT_EXPORTS_REMOVE

A more versatile installation would use [virtualenvwrapper][] and [nodeenv][], these then create isolated development environments for each project. 

[do]: http://digitalocean.com
[linode]: http://linode.com
[linode secure]: https://www.linode.com/docs/security/securing-your-server/
[do secure]: https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-12-04
[fail2ban]: http://www.fail2ban.org/

[xhprof]: https://github.com/phacility/xhprof
[xdebug]: http://xdebug.org/
[phpunit]: http://phpunit.de/
[virtualenvwrapper]: http://virtualenvwrapper.readthedocs.org/
[nodeenv]: http://ekalinin.github.io/nodeenv/
[homebrew]: http://brew.sh
[vsftpd]: https://security.appspot.com/vsftpd.html


[xcode]: https://itunes.apple.com/us/app/xcode/id497799835?mt=12
[vagrant]: http://www.vagrantup.com/downloads.html
[virtualbox]: https://www.virtualbox.org/wiki/Downloads
[sudoers]: http://docs.vagrantup.com/v2/synced-folders/nfs.html
