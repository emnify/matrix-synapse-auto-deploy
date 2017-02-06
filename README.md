# Auto-deployment for matrix-org/synapse

[![Build Status](https://travis-ci.org/hugoShaka/matrix-synapse-auto-deploy.svg?branch=master)](https://travis-ci.org/hugoShaka/matrix-synapse-auto-deploy)

Auto-deployment process for the matrix-org/synapse (https://github.com/matrix-org/synapse) homeserver and turnserver using  ansible, this will automatically deploy a ready-to-go matrix server on any server.

The playbook will try to install latest master from https://github.com/matrix-org/synapse/tarball/master

## Pre-requirements
* Git
* Ansible

## Clone auto-deploy repo

    git clone https://github.com/hugoShaka/matrix-synapse-auto-deploy into your role folder.

## Create your inventory

In your host file : `/etc/ansible/hosts`  add a group for synapse servers :

    [synapse]
    your.server.domain.tld

## Create a playbook to apply the role

    ---

    - hosts: synapse
      become: yes

      vars:
        enable_registration: false
        # overwrite default variables

      roles:
        - role_under_test

## Adopt vars file as needed or just go with these defaults

In your playbook file edit and add vars. Here is all the vars you can set and their default values.

    ---
    username: synapse
    git_repo: https://github.com/matrix-org/synapse/tarball/master
    hostname: 10.99.99.230
    enable_registration: true
    enable_registration_captcha: false
    recaptcha_private_key: YOURPRIVATEKEYHERE
    recaptcha_public_key: YOURPUBLICKEYHERE
    turn_shared_secret: YOURSHAREDSECRETHERE
    make_migration: true     #Migrate the database from sqlite to postgres, only apply the first time !
    database_secret: YOURDATABASESECRETHERE
    absolute_path_certificate: /home/{{ username }}/.synapse/{{ hostname }}.tls.crt
    absolute_path_key: /home/{{ username }}/.synapse/{{ hostname }}.tls.key
    generate_DH_params: true   # Generate DH parameters
    DH_params_location: /etc/ssl/diffihellman.pem

## Launch your playbook



## Add your DNS entry

You should have a SRV entry like that (in order to tell other HomeServers on which port they will speak).

`_matrix._tcp.yourdomain.tld.	3600 IN	SRV 10 5 443 machine.yourdomain.tld.`


## Enjoy

You can now connect to your HomeServer, with the built-in web client ( http://machine.yourdomain.tld ) or by specifying your HomeServer on any other client.

# Not Working ?

## Check your firewall options

With this configuration you should allow :
- outbound : 8008 and 8448
- inbound : 80 and 443

## Check your DNS entry

With the commands :
`dig _matrix._tcp.yourdomain.tld SRV` and `dig machine.yourdomain.tld A`

## Check if synapse and nginx can access certs

They should both read the file. Become the app user and test if you can read the files with `sudo -u synapse/www-data cat /path/to/the/certs/cert.crt`.

If everything is fine for all certs and keys and all users, check the certs location in the conf (`/etc/nginx/sites-available and /home/{{username}}/.synapse/homeserver.yaml`). If you don't know what files you should link, get a look at this tutorial (https://matrix.org/docs/guides/lets-encrypt.html).

### Check if Diffie-Hellman parameters exist

In order to secure your connections you will want to have DH parameters (they are used when you negociate a TLS connection). If you don't have any just set `generate_DH_params: true` and choose a location. If you already generated them, set this value to false and specify their location.

## Still not working ? Come and ask for help on matrix:matrix.org using [Riot client](http://riot.im).

# Supported OS

This playbook is made to run on Debian 8 Jessie. It should also run smoothly on any systemd flavoured OS but I didn't test.
You're free to test and give me feedback (or PR to add support of your favorite system).

# Credits :
Original playbook by Martin Giess.
Adapted to a role by hugoShaka.

Thanks to AlefBurzmali for his tests and reviews.
