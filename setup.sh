#!/bin/bash

echo "Checking if Homebrew is already installed..."
if [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

which brew
if [[ $? != 0 ]] ; then
  echo "Homebrew not found.  Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Adding Homebrew to environment..."
eval "$(/opt/homebrew/bin/brew shellenv)"

if [[ $(uname) == "Linux" ]]; then
  test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
  test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
  echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
fi

echo "Checking if Ansible is already installed..."
which ansible
if [[ $? != 0 ]] ; then
  echo "Ansible not found.  Installing..."
  brew update && brew install ansible
fi

echo "Installing/updating Ansible community.general modules..."
ansible-galaxy collection verify community.general

if ![[ -f "./playbook.yml" ]] ; then
  echo "Downloading Ansible playbook..."
  playbook_path="/tmp/lm-setup-playbook.yml"
  curl -s https://raw.githubusercontent.com/Liquidmantis/setup-scripts/main/playbook.yml -o $(playbook_path)
else
  playbook_path="./playbook.yml"
fi
 
echo "Executing Ansible playbook"
ansible-playbook $playbook_path
