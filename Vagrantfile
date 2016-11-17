# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'json'

vagrant_dir = File.expand_path(File.dirname(__FILE__))

Vagrant.configure(2) do |config|
	config.vm.box = "ubuntu/xenial64"
	config.vm.hostname = "phalcon-vm"
	config.vm.network :private_network, ip: "192.168.50.99"

	config.ssh.forward_agent = true

	config.vm.provider :virtualbox do |v|
		v.memory = 1024
		v.cpus = 2
		v.name = File.basename(Dir.pwd)

		v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
		v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
		v.customize ["modifyvm", :id, "--ioapic", "on"]
		v.customize ["modifyvm", :id, "--nictype1", "Am79C973"]
	end

	config.vm.synced_folder "provision/", "/srv/provision/"
	config.vm.synced_folder "log/", "/srv/log/", :owner => "www-data"
	config.vm.synced_folder "www/", "/srv/www/", :owner => "www-data", :mount_options => [ "dmode=775", "fmode=774" ]

	if defined?(VagrantPlugins::HostsUpdater)
		settings_file = File.join(vagrant_dir, 'www', 'default', 'data', 'settings.json')
		if File.exists?(settings_file)
			settings = JSON.parse(File.read(settings_file))

			hosts = settings["sites"].map do |site|
				site['domains']
			end

			config.hostsupdater.aliases = hosts
			config.hostsupdater.remove_on_suspend = true
		end
	end

	config.vm.provision "fix-no-tty", type: "shell" do |s|
		s.privileged = false
		s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
	end

	config.vm.provision "provision", type: "shell", path: File.join( "provision", "provision.sh" )

	config.vm.provision "startup", type: "shell", path: File.join( "provision", "startup.sh" ), run: "always"
end
