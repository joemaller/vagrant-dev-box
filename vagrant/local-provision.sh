#!/bin/bash

# This script will run the Ansible playbooks locally, it's here to allow local provisioning
# of an Ansible-provisioned Vagrant VM on a Windows system.
#
#


ANSIBLE_PLAYBOOK='/vagrant/vagrant/ansible/main.yml'
prefix='SHELL:'
PAD='*********************************************************************'

echo
MSG='Ansible not found on host system, running locally on VM'
echo "${prefix} [${MSG}] ${PAD:${#MSG}}"

echo
MSG='Installing Git and Python dependencies'
echo "${prefix} [${MSG}] ${PAD:${#MSG}}"
echo

apt-get -y install git python-pip python-crypto
pip install paramiko pyyaml jinja2 markupsafe

echo
MSG='Installing Ansible'
echo "${prefix} [${MSG}] ${PAD:${#MSG}}"

ANSIBLE_TMP=$(mktemp -d /tmp/ansible-XXXX)
git clone https://github.com/ansible/ansible.git $ANSIBLE_TMP
source $ANSIBLE_TMP/hacking/env-setup > /dev/null

if [ -f $ANSIBLE_PLAYBOOK ]; then

    echo
    MSG='Running Ansible playbooks locally (this might take a while)'
    echo "${prefix} [${MSG}] ${PAD:${#MSG}}"

    hostname > $ANSIBLE_TMP/hosts
    ansible-playbook -i $ANSIBLE_TMP/hosts $ANSIBLE_PLAYBOOK --connection=local
    rm $ANSIBLE_TMP/hosts

    MSG='Local provisioning complete!'
else
    echo
    MSG="Could not find playbook ${ANSIBLE_PLAYBOOK}"
    echo "${prefix} [${MSG}] ${PAD:${#MSG}}"

    MSG='Local provisioning failed!'
fi
echo
echo "${prefix} [${MSG}] ${PAD:${#MSG}}"
