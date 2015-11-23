# Auto-deployment for matrix-org/synapse
Auto-deployment process for the matrix-org/synapse homeserver using vagrant and ansible, this will automatically deploy a ready-to-go matrix server on Virtualbox (or on AWS/Openstack/VMware/Docker if you add the right provider settings 8-).

The playbooks will try to use latest master from https://github.com/matrix-org/synapse/tarball/master

## Pre-requirements for host system
* Git
* Vagrant https://www.vagrantup.com/
* Ansible
* Virtualbox (or other virtual env at hand)

## Load vagrant box

    vagrant box add trusty64 https://atlas.hashicorp.com/ubuntu/boxes/trusty64/versions/20150427.0.0/providers/virtualbox.box
  
## Run vagrant

    vagrant up
  
