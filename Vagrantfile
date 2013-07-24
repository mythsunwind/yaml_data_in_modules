# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  # create a symlink to make the module of the current directory available in puppet
  config.vm.synced_folder ".", "/etc/puppet/modules/hiera_data_in_modules"

  # the newsletter-adapter uses this port
  config.vm.network :forwarded_port, guest: 2318, host: 2318

  # forward ssh key
  config.ssh.forward_agent = true

  # puppet configuration with bootstrap
  config.vm.provision :shell, :path => "bootstrap.sh"
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "."
    puppet.manifest_file  = "vagrant.pp"
    puppet.options        = ['--verbose', '--modulepath=/etc/puppet/modules:modules'] 
    puppet.facter         = { "environment" => "qa" }
  end

end
