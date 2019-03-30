#!/usr/bin/env bash
#
# This script can be manually run by passing the appropriate DISTRO environment variable e.g.
# DISTRO=ubuntu1804 ./tests/test.sh
#
# When running manually, run the task from the root of the repository, like in the example above!
#

# Exit on any command failure.
set -e

CID=$(date +%s)
CLEANUP=${CLEANUP:-"true"}

if [ "$DISTRO" = 'ubuntu1804' ]; then
  init="/lib/systemd/systemd"
  opts="--privileged --volume=/var/lib/docker --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro"
elif [ "$DISTRO" = 'debian9' ]; then
  init="/lib/systemd/systemd"
  opts="--privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro"
fi

docker pull geerlingguy/docker-${DISTRO}-ansible:latest

docker run --detach --volume="$PWD":/etc/ansible/roles/role_under_test:ro --name $CID $opts geerlingguy/docker-${DISTRO}-ansible:latest $init

docker inspect "$CID"

docker exec --tty "$CID" env TERM=xterm env ANSIBLE_CONFIG=/etc/ansible/roles/role_under_test/tests/ansible.cfg ansible --version

docker exec --tty "$CID" env TERM=xterm env ANSIBLE_CONFIG=/etc/ansible/roles/role_under_test/tests/ansible.cfg ansible all -i "localhost," -c local -m setup

docker exec --tty "$CID" env TERM=xterm env ANSIBLE_CONFIG=/etc/ansible/roles/role_under_test/tests/ansible.cfg ansible-playbook /etc/ansible/roles/role_under_test/tests/playbook.yml --syntax-check 

docker exec --tty "$CID" env TERM=xterm env ANSIBLE_CONFIG=/etc/ansible/roles/role_under_test/tests/ansible.cfg ansible-playbook /etc/ansible/roles/role_under_test/tests/playbook.yml

# Idempotence test
#idempotence=$(mktemp)
#echo -e "\n\nRunning idempotence test..."
#docker exec --tty "$CID" env TERM=xterm env ANSIBLE_CONFIG=/etc/ansible/roles/role_under_test/tests/ansible.cfg ansible-playbook \
# /etc/ansible/roles/role_under_test/tests/playbook.yml --extra-vars "make_migration=false" | tee -a $idempotence
#tail -n 200 $idempotence \
# | grep -q 'changed=0.*failed=0' \
# && (echo 'Idempotence test passed' && exit 0) || (echo 'Idempotence test failed' && exit 1)

# Run tests
#echo -e "\n\nRunning smoke tests..."
#docker exec --tty "$CID" env TERM=xterm ANSIBLE_CONFIG=/etc/ansible/roles/role_under_test/tests/ansible.cfg ansible-playbook /etc/ansible/roles/role_under_test/tests/test.yml

if [ "$CLEANUP" = true ]; then
echo -e "\n\nStopping container..."
docker stop "$CID"
echo "Removing container..."
docker rm "$CID"
fi