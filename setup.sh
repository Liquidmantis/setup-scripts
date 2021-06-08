---
- name: Initialize Environment
  hosts: localhost

  tasks:
    - name: Create Dropbox directory
      file:
        path: ~/Dropbox
        state: directory

    - name: Create notes directory
      file:
        path: ~/Dropbox/documents/notes
        state: directory
          
    - name: Create notes symlink
      file:
        src: ~/Dropbox/documents/notes
        dest: ~/notes
        state: link

    - name: Create git-home source directory
      file:
        path: ~/Dropbox/git-home
        state: directory

    - name: Create git-home symlink
      file:
        src: ~/Dropbox/git-home
        dest: ~/git-home
        state: link

    - name: Clone dotfiles repo
      git:
        repo: https://github.com/Liquidmantis/dotfiles
        dest: ~/Dropbox/git-home/dotfiles

  # TODO: generate SSH key
  # TODO: upload SSH key to github

- name: Setup symlinks
  hosts: localhost
  gather_facts: true

  vars:
    dotfiles: ~/git-home/dotfiles
    isMacOs: ansible_facts['distribution'] == 'MacOSX'

  tasks:
    - name: symlink alacritty directory
      file:
        src: "{{dotfiles}}/alacritty"
        dest: ~/.config/alacritty
        state: link

    - name: symlink gitconfig
      file:
        src: "{{dotfiles}}/git/gitconfig"
        dest: ~/.gitconfig
        state: link

    - name: symlink hammerspoon directory
      file:
        src: "{{dotfiles}}/hammerspoon"
        dest: ~/.hammerspoon
        state: link

    - name: symlink karabiner directory
      when: isMacOs
      file:
        src: "{{dotfiles}}/karabiner"
        dest: ~/.config/karabiner
        state: link

    - name: symlink neovim directory
      file:
        src: "{{dotfiles}}/nvim"
        dest: ~/.config/nvim
        state: link

    - name: symlink starship directory
      file:
        src: "{{dotfiles}}/starship"
        dest: ~/.config/starship
        state: link

    - name: symlink tmux directory
      file:
        src: "{{dotfiles}}/tmux"
        dest: ~/.config/tmux
        state: link

    - name: symlink tmux.conf
      file:
        src: ~/.config/tmux/tmux.conf
        dest: ~/.tmux.conf
        state: link

    - name: symlink yabai directory
      when: isMacOs
      file:
        src: "{{dotfiles}}/yabai"
        dest: ~/.config/yabai
        state: link

    - name: symlink yabairc
      when: isMacOs
      file:
        src: ~/.config/yabai/yabairc
        dest: ~/.yabairc
        state: link

    - name: symlink zsh directory
      file:
        src: "{{dotfiles}}/zsh"
        dest: ~/.config/zsh
        state: link

    - name: symlink zshrc
      file:
        src: ~/.config/zsh/zshrc
        dest: ~/.zshrc
        state: link

- name: Install Homebrew Packages 
  hosts: localhost
  gather_facts: true

  vars:
    isMacOs: "{{true if ansible_facts['distribution'] == 'MacOSX' else false}}"

  tasks: 
    - name: Update Homebrew
      homebrew:
        update_homebrew: true

    - name: Install common Homebrew casks
      homebrew_cask:
        package:
          - alacritty
          - font-fira-code-nerd-font
          - homebrew/cask-versions/powershell-preview
        state: latest

    - name: Install Homebrew packages from HEAD
      when: isMacOs
      homebrew:
        package:
          - neovim
        state: head

    - name: Install common Homebrew packages
      homebrew:
        package:
          - ansible
          - azure-cli
          - bash-completion
          - exa
          - git
          - jq
          - node
          - readline
          - starship 
          - tmux
          - z
          - zsh
          - zsh-autosuggestions
          - zsh-completions
          - zsh-history-substring-search
          - zsh-syntax-highlighting
        state: latest

    - name: Install Mac Homebrew casks 
      when: isMacOs
      homebrew_cask:
        package:
          - alacritty
          - alfred
          - hammerspoon
          - karabiner-elements
        state: latest

    - name: Install Mac Homebrew packages from HEAD
      when: isMacOs
      homebrew:
        package:
          - koekeishiya/formulae/yabai
        state: head
