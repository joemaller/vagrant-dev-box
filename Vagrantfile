# -*- mode: ruby -*-
# vi: set ft=ruby :

# Set the reusable hostname:
# $hostname = "vagrant"

# If no hostname is set, use the sanitized name of the Vagrantfile's containing directory
$hostname ||= File.basename(File.dirname(File.expand_path(__FILE__))).downcase.gsub(/[^a-z0-9]+/,'-').gsub(/^-+|-+$/,'')
# if that fails, fallback to 'vagrant'
$hostname = "vagrant" if $hostname.empty?

# http://stackoverflow.com/a/17729961/503463
# pref_interface is an array of adapters in preferred order
# vm_interfaces is a list of available interfaces
# we reduce pref_interface against vm_interfaces and go with the first remaining network
# if no networks match, fallback to the first listed result
pref_interface = ['en0: Ethernet', 'en2: USB Ethernet', 'en0: Wi-Fi (AirPort)', 'en1: Wi-Fi (AirPort)']
vm_interfaces = %x( VBoxManage list bridgedifs | grep ^Name ).gsub(/Name:\s+/, '').split("\n")
pref_interface = pref_interface.map {|n| n if vm_interfaces.include?(n)}.compact
$network_interface = pref_interface[0] || false

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty32"

  config.vm.hostname = $hostname

  config.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true

  # Specifying :bridge with our preferred network lets Vagrant skip
  # "What interface should the network bridge to?" when spinning up the VM
  config.vm.network "public_network", :bridge => $network_interface

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.10"

  # NFS passwords fixed with this: https://gist.github.com/joemaller/6764700
  # NFS is silently ignored under Windows
  # config.vm.synced_folder ".", "/vagrant_synced/" + $hostname, nfs: true
  config.vm.synced_folder ".", "/vagrant_synced/" + $hostname, type: "nfs" #, nfs_export: false

  config.vm.provider "virtualbox" do |v|
    # v.gui = true  # for debugging
    v.customize ["modifyvm", :id, "--memory", 4096] # GraphViz fails with less than 4 GB
    v.customize ["modifyvm", :id, "--name", $hostname]
    v.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  config.vm.provision "ansible" do |ansible|
    # ansible.verbose = "vvvv"
    ansible.playbook = "deploy/main.yml"
    # Set all Vagrant dependent vars here to override the playbook defaults
    ansible.extra_vars = {
        vagrant: true,
        dev: true,
        root_user: "vagrant",
        admin_user: "vagrant",
        site_name: $hostname,
        site_root: "/vagrant_synced/" + $hostname,
    }
  end

end
