#!/usr/bin/env bash

PDIR="$(dirname "$(pwd)")"

USAGE() {
	echo -e "Usage: ${0##*/} [ubuntu1604|debian8|debian9]"
	exit
}

if [ -z "$1" ]; then USAGE; fi
if [ $1 == "ubuntu1604" ] || [ $1 == "debian8" ] || [ $1 == "debian9" ]; then DISTRO="$1"; else USAGE; fi

docker pull geerlingguy/docker-${DISTRO}-ansible:latest || exit

CID=$(docker run --detach --volume="$PDIR":/etc/ansible/roles/role_under_test:ro geerlingguy/docker-ubuntu1604-ansible:latest /lib/systemd/systemd || exit)

docker inspect "$CID" || exit

docker exec --tty "$CID" env TERM=xterm env ANSIBLE_CONFIG=/etc/ansible/roles/role_under_test/tests/ansible.cfg ansible --version || exit

docker exec --tty "$CID" env TERM=xterm env ANSIBLE_CONFIG=/etc/ansible/roles/role_under_test/tests/ansible.cfg ansible all -i "localhost," -c local -m setup || exit

docker exec --tty "$CID" env TERM=xterm env ANSIBLE_CONFIG=/etc/ansible/roles/role_under_test/tests/ansible.cfg ansible-playbook /etc/ansible/roles/role_under_test/tests/playbook.yml --syntax-check || exit

docker exec --tty "$CID" env TERM=xterm env ANSIBLE_CONFIG=/etc/ansible/roles/role_under_test/tests/ansible.cfg ansible-playbook /etc/ansible/roles/role_under_test/tests/playbook.yml || exit

# Run the role/playbook again, checking to make sure it's idempotent.
#docker exec "$CID" env TERM=xterm env ANSIBLE_CONFIG=/etc/ansible/roles/role_under_test/tests/ansible.cfg ansible-playbook \
#/etc/ansible/roles/role_under_test/tests/playbook.yml --extra-vars "make_migration=false" | tee -a idempotence \
#tail idempotence | grep -q 'changed=0.*failed=0' && (echo 'Idempotence test: pass' && exit 0) || (echo 'Idempotence test: fail' && exit 1)

# Test role.
#docker exec --tty "$CID" env TERM=xterm env ANSIBLE_CONFIG=/etc/ansible/roles/role_under_test/tests/ansible.cfg ansible-playbook /etc/ansible/roles/role_under_test/tests/test.yml

docker stop "$CID" || exit

docker rm "$CID" || exit
