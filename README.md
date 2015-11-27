# Auto-deployment for matrix-org/synapse
Auto-deployment process for the matrix-org/synapse (https://github.com/matrix-org/synapse) homeserver and turnserver using vagrant and ansible, this will automatically deploy a ready-to-go matrix server on Virtualbox and AWS (could be easily used also with Openstack/VMware/Docker if you add the right provider settings 8-).

The playbook will try to install latest master from https://github.com/matrix-org/synapse/tarball/master

## Pre-requirements 
* Git
* Vagrant https://www.vagrantup.com/
* Ansible
* Virtualbox or AWS credentials

## Load vagrant box

    vagrant box add trusty64 https://atlas.hashicorp.com/ubuntu/boxes/trusty64/versions/20150427.0.0/providers/virtualbox.box

## Clone auto-deploy repo

    git clone https://github.com/EMnify/matrix-synapse-auto-deploy

## Adopt vars file as needed

    ---

    username: synapse # under wich user the server should be installed and run
    git_repo: https://github.com/matrix-org/synapse/tarball/master # URL to Git Repo you want to install
    hostname: 10.99.99.230 # FQDN to be used
    enable_registration: true # this will open registration by default, take care if you run a public server!
    enable_registration_captcha: false
    recaptcha_private_key: YOURPRIVATEKEYHERE
    recaptcha_public_key: YOURPUBLICKEYHERE
    turn_shared_secret: YOURSHAREDSECRETHERE

## Setting it up on VirtualBox

### Run vagrant up, it will create a new VM and provision it

    vagrant up

### Start using matrix

Go to http://10.99.99.230:8008 (or the FQDN you configured in the synapse_vars.yml), register a new user and start using matrix.

### If you want to check what's going on, you can SSH into your new VM and check the logs

    vagrants ssh synapse
    tail ~synapse/.synapse/homeserver.log

## Setting it up on AWS

### Set your environment variables matching YOUR AWS setup

    export AWS_REGION=eu-central-1
    export AWS_AMI=ami-accff2b1
    export AWS_ACCESS_KEY_ID=YOURAWSACCESSKEYID
    export AWS_SECRET_ACCESS_KEY=YOURSECRETACESSKEY
    export AWS_SUBNET_ID=YOURSUBNET
    export AWS_KEYPAIR_NAME=YOURKEYPAIRNAME
    export SSH_PRIVATE_KEY_PATH=PATHTOSECRETKEYMATHCINGKEYPAIR

### Run vagrant up with provider AWS, it will create a new instance and provision it

    vagrant up --provider=aws

### Setup AWS security groups

Make sure you have a security group that allows SSH access, otherwise ansible will not be able to provision your machine!

To make it access for users then you need to open following ports

* TCP 8008 : Matrix via HTTP
* TCP 8448 : Matrix via HTTPS
* UDP/TCP 3478/3479 TURN Server

### Start using matrix

Go to http://fqdn:8008 (the FQDN you configure in your DNS e.g. Route53 on AWS, don't forget to put in synapse_vars.yml), register a new user and start using matrix.
