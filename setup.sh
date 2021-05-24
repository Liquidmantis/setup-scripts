#!/bin/bash

echo "Checking if Homebrew is already installed..."
which -s brew
if [[ $? != 0 ]] ; then
  echo "Homebrew not found.  Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Checking if Ansible is already installed..."
which -s ansible
if [[ $? != 0 ]] ; then
  echo "Ansible not found.  Installing..."
  brew update && brew install ansible
fi

echo "Installing/updating Ansible community.general modules..."
ansible-galaxy collection verify community.general

echo "Executing Ansible playbook"
ansible-playbook mac-setup.yml
