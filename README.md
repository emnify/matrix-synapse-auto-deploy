# Auto-deployment for matrix-org/synapse

[![Maintenance](https://img.shields.io/maintenance/yes/2019.svg)](https://github.com/Madic-/matrix-synapse-auto-deploy) [![Build Status](https://travis-ci.org/Madic-/matrix-synapse-auto-deploy.svg?branch=master)](https://travis-ci.org/Madic-/matrix-synapse-auto-deploy)

This ansible role will automatically deploy a ready-to-go [matrix](http://matrix.org/) server on any server. It differs from the [matrix-docker-ansible-deploy](https://github.com/spantaleev/matrix-docker-ansible-deploy) roles by not using docker but instead a python virtual environment, at least for synapse.

## Services

This role configures the following services on your server:

- [Synapse](https://github.com/matrix-org/synapse): Reference "homeserver" implementation of Matrix from the core development team at matrix.org

- [Coturn](https://github.com/coturn/coturn): STUN/TURN server for WebRTC audio/video calls

- [mxisd](https://github.com/kamax-io/mxisd): Federated Matrix Identity server, to further increase privacy ([doc](docs/mxisd.md))

- [nginx](http://nginx.org/): Web server for riot.web and reverse proxy for synapse and mxisd

- [postgresql](https://www.postgresql.org/): Database for synapse and mxisd

- [Riot](https://riot.im/): WebUI preconfigured for your homeserver

- [Let's Encrypt](https://letsencrypt.org/): TLS certificate for Riot and Synapse

Small [Architecture Overview](docs/architecture.md)

## Pre-requirements

- Git
- Ansible >= 2.6
- DNS Entries
  - A Records
    - A Record for matrix-machine.yourdomain.tld.
    - A Record for riot-webclient.yourdomain.tld.
  - SRV Record
    - `_matrix._tcp.yourdomain.tld. 3600 IN SRV 10 5 443 matrix-machine.yourdomain.tld.`
    - `_matrix-identity._tcp.yourdomain.tld. 3600 IN SRV 10 5 443 matrix-machine.yourdomain.tld.`

You should have an SRV entry like that in order to tell other HomeServers on which port they need to speak.
Additionally .well-known files will be created under {{ matrix_well_known_location }}. It's up to you to move these files to the server serving your apex domain.

## Supported OS

- Ubuntu 18.04
- Debian 9

It should also run smoothly on any systemd flavoured OS. You're free to test and give me feedback (or PR to add support for your favorite system).

## Installation

If you are not familiar with ansible, the easiest way is to lauch from the server you want to install matrix on:

    ansible-playbook playbook.yml -c local

## Enjoy

You can now connect to your HomeServer via the riot webclient or by specifying your HomeServer on any other client.
