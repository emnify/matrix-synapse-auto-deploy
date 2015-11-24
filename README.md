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

## Clone auto-deploy repo

    git clone https://github.com/EMnify/matrix-synapse-auto-deploy

## Adopt vars file as needed

    ---

    username: synapse # under wich user the server should be installed and run
    git_repo: https://github.com/matrix-org/synapse/tarball/master # URL to Git Repo you want to install
    hostname: 10.99.99.230 # FQDN to be used

## Run vagrant

    vagrant up

## Check status of your new VM

    vagrant status

## Start using matrix

Go to http://10.99.99.230:8008 (or the FQDN you configured in the synapse_vars.yml), register a new user and start using matrix.

## If you want to check what's going on, you can SSH into your new VM and check the logs

    vagrants ssh synapse
    tail ~synapse/.synapse/homeserver.log
