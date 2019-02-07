#!/usr/bin/env bash

PDIR="$(dirname "$(pwd)")"

docker pull geerlingguy/docker-ubuntu1604-ansible:latest

CID=$(docker run --detach --privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro \
 --volume="$PDIR":/etc/ansible/roles/role_under_test:ro geerlingguy/docker-ubuntu1604-ansible:latest)

docker exec --tty "$CID" env TERM=xterm env ANSIBLE_CONFIG=/etc/ansible/roles/role_under_test/tests/ansible.cfg ansible --version

docker exec --tty "$CID" env TERM=xterm env ANSIBLE_CONFIG=/etc/ansible/roles/role_under_test/tests/ansible.cfg ansible all -i "localhost," -c local -m setup

docker exec --tty "$CID" env TERM=xterm env ANSIBLE_CONFIG=/etc/ansible/roles/role_under_test/tests/ansible.cfg ansible-playbook /etc/ansible/roles/role_under_test/tests/playbook.yml --syntax-check

docker exec --tty "$CID" env TERM=xterm env ANSIBLE_CONFIG=/etc/ansible/roles/role_under_test/tests/ansible.cfg ansible-playbook /etc/ansible/roles/role_under_test/tests/playbook.yml

docker stop "$CID"

docker rm "$CID"