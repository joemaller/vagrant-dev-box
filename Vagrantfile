# -*- mode: ruby -*-
# vi: set ft=ruby :

# Set the reusable hostname:
# $hostname = "vagrant"

# If no hostname is set, try using the sanitized name of the containing directory
$hostname ||= File.basename(Dir.getwd).downcase.gsub(/[^a-z0-9]+/,'-').gsub(/^-+|-+$/,'')
# if that fails, fallback to 'vagrant'
$hostname = "vagrant" if $hostname.empty?

# http://stackoverflow.com/a/17729961/503463
# pref_interface is an array of adapters in preferred order
# vm_interfaces is a list of available interfaces
# we reduce pref_interface against vm_interfaces and go with the first remaining network
pref_interface = ['en0: Ethernet', 'en2: USB Ethernet', 'en0: Wi-Fi (AirPort)']
vm_interfaces = %x( VBoxManage list bridgedifs | grep ^Name ).gsub(/Name:\s+/, '').split("\n")
pref_interface = pref_interface.map {|n| n if vm_interfaces.include?(n)}.compact
$network_interface = pref_interface[0]

do_ansible = `ansible-playbook --version` rescue nil
ansible_up_to_date = false
if do_ansible
  ansible_baseline = Gem::Version.new('1.4')
  ansible_up_to_date= Gem::Version.new(do_ansible.split()[1]) >= ansible_baseline
end

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  config.vm.hostname = $hostname

  # Specifying :bridge with our preferred network lets Vagrant skip
  # "What interface should the network bridge to?" when spinning up the VM
  config.vm.network "public_network", :bridge => $network_interface

  config.vm.network "forwarded_port", guest: 80, host: 8080
  # define a secondary private network so NFS shares will work correctly
  # network interfaces are added in order, so this one will map to eth2
  config.vm.network "private_network", ip: "192.168.33.10"

  # NFS passwords fixed with this: https://gist.github.com/joemaller/6764700
  # NFS is silently ignored under Windows (true?)
  # config.vm.synced_folder ".", "/var/www", :nfs => true

  config.vm.provider "virtualbox" do |v|
    # v.gui = true  # for debugging
    v.customize ["modifyvm", :id, "--memory", 512]
    v.customize ["modifyvm", :id, "--name", $hostname]
    v.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  # Would prefer to have this in an ansible.cfg file, but I wasn't able to get that file
  # to load from inside the ./vagrant/ansible directory with ENV['ANSIBLE_CFG']
  # until that works, individual key:value pairs can be set like this:
  # ENV['ANSIBLE_ERROR_ON_UNDEFINED_VARS'] = "false"

  if do_ansible && ansible_up_to_date
    config.vm.provision "ansible" do |ansible|
      # ansible.verbose = "v" # 1.3.4 ansible verbosity-flag bug
      ansible.playbook = "vagrant/ansible/main.yml"
    end
  else
    config.vm.provision "shell" do |shell|
      shell.path = "vagrant/local-provision.sh"
    end
  end

end
