# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id,
                  "--groups", "/matrix"]
  end
end

Vagrant.configure("2") do |config|
  config.vm.define "synapse" do |dev|
    dev.vm.box = "precise64"
    dev.vm.network :private_network, ip: "10.99.99.230"
    dev.vm.hostname = "matrix-synapse"
    config.ssh.forward_agent = true
    config.vm.provider :virtualbox do |vb|
      vb.name = "matrix-synapse"
      vb.customize ["modifyvm", :id,
                  "--groups", "/matrix",
                  "--memory", "1024"]
    end
  end
end

Vagrant.configure("2") do |config|
  config.vm.provision "ansible" do |ansible|
    ansible.host_key_checking = false
    ansible.sudo = true
    ansible.sudo_user = "vagrant"
    ansible.raw_arguments = "-u vagrant --private-key ~/.vagrant.d/insecure_private_key"
    ansible.playbook = "playbook.yml"
  end
end
