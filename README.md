# Auto-deployment for matrix-org/synapse

[![Maintenance](https://img.shields.io/maintenance/yes/2019.svg)](https://github.com/Madic-/matrix-synapse-auto-deploy) [![Build Status](https://travis-ci.org/Madic-/matrix-synapse-auto-deploy.svg?branch=master)](https://travis-ci.org/Madic-/matrix-synapse-auto-deploy)

Auto-deployment process for the [matrix-org/synapse](https://github.com/matrix-org/synapse) homeserver and turnserver using  ansible, this will automatically deploy a ready-to-go matrix server on any server.

The playbook will try to install latest [synapse release](https://github.com/matrix-org/synapse/releases)
and latest [riot.im release](https://github.com/vector-im/riot-web/releases).

This playbook is a fork from [EMnify/matrix-synapse-auto-deploy](https://github.com/EMnify/matrix-synapse-auto-deploy).

## Changes from the original repository

- Added Hyper-V settings to the Vagrantfile
- Added mxisd for ldap auth
- Install turnserver and mxisd only when the appropriate variable is true
- Added handlers so the applications aren't restarted every time the playbook runs but only when it's necessary
- corrected typos
- Added missing python libraries for url previews
- Differentiate between Matrix Domain and Hostname so you can use matrix ids in form of "@name:domain.tld" instead of "@name:hostname.domain.tld"
- Added variables to use an external turn server
- Installs Riot Web Client to a separate domain
- Configurable E-Mail Settings
- Synapse Matrix server complete behind nginx proxy (Port 80, 443, 8448)

All new variables are defined under defaults\main.yml

## ToDo

- Lets encrypt support

## Pre-requirements

- Git
- Ansible >= 2.6
- DNS Entries
  - A Record
    - A Record for matrix-machine.yourdomain.tld.
    - A Record for riot-webclient.yourdomain.tld.
  - SRV Record
    - `_matrix._tcp.yourdomain.tld. 3600 IN SRV 10 5 443 matrix-machine.yourdomain.tld.`

You should have a SRV entry like that in order to tell other HomeServers on which port they need to speak.

## Clone auto-deploy repo

    git clone https://github.com/Madic-/matrix-synapse-auto-deploy.git

## Example playbook, adapt to your needs

    ---
    - hosts: myhost

      roles:
        - matrix-synapse-auto-deploy

      vars:
        username: synapse # under wich user the server should be installed and run
        hostname: matrix.domain.com # FQDN to be used
        enable_registration: true # this will open registration by default, take care if you run a public server!
        enable_registration_captcha: false
        recaptcha_private_key: YOURPRIVATEKEYHERE
        recaptcha_public_key: YOURPUBLICKEYHERE
        turn_shared_secret: YOURSHAREDSECRETHERE
        make_migration : true # will shut down the the server to migrate from sqlite to postgresql.
        database_secret: YOURDATABASESECRETHERE
        absolute_path_certificate: /etc/ssl/your_org/fullchain.pem
        absolute_path_key: /etc/ssl/your_org/private_key.pem
        install_turnserver: yes
        riot_hostname: chat.domain.com
        riot_path_certificate: /etc/ssl/your_org/fullchain.pem
        riot_path_key: /etc/ssl/your_org/private_key.pem
        riot_path: /var/www/riot

## Run the ansible playbook

If you are not familiar with ansible, the easiest way is to lauch from the server you want to install matrix on: `ansible-playbook playbook.yml -c local`

## Getting safe

Get an SSL certificate, you can use let's encrypt, put the symlinks where they should be and be sure the nginx and synapse users have the right to read certs.

## Enjoy

You can now connect to your HomeServer via the riot webclient or by specifying your HomeServer on any other client.

## Not Working

### Check your firewall options

With this configuration you should allow:

- outbound: 80, 443 and 8448
- inbound: 80, 443 and 8448

### Check your DNS entry

With the commands :
`dig _matrix._tcp.yourdomain.tld SRV` and `dig matrix-machine.yourdomain.tld A`

### Check if synapse and nginx can access certs

They should both read the file. Become the synapse user and test if you can read the files with `sudo -u synapse/www-data cat /path/to/the/certs/cert.crt`.

If everything is fine for all certs and keys and all users, check the certs location in the conf (`/etc/nginx/sites-available and /home/{{username}}/.synapse/homeserver.yaml`).

### Still not working

Come and ask for help on matrix:matrix.org using [Riot client](http://riot.im).

## Supported OS

This playbook is made to run on Debian 8, Debian 9 and Ubuntu 16.04. It should also run smoothly on any systemd flavoured OS.
You're free to test and give me feedback (or PR to add support of your favorite system).
