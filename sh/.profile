#!/bin/sh


#      _
#  ___| |__
# / __| '_ \
# \__ \ | | |
# |___/_| |_|
# ~/.profile

# ~/.profile: executed by the command interpreter for LOGIN shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.


# >>> Shellcheck

# Ignore "Can't follow non-constant source."
# We just don't carea bout that
# shellcheck disable=1090
# https://github.com/koalaman/shellcheck/wiki/SC1090

# Ignore "Expressions don't expand in single quotes, use double quotes for that."
# We want that for aliases
# shellcheck disable=2016
# https://github.com/koalaman/shellcheck/wiki/SC2016

# Ignore "This expands when defined, not when used. Consider escaping."
# We want that for aliases
# shellcheck disable=2139
# https://github.com/koalaman/shellcheck/wiki/SC2139

# Ignore "For loops over find output are fragile. Use find -exec or a while read loop."
# We nned to pass a function defined here and 'find -exec' does not support that
# shellcheck disable=2044
# https://github.com/koalaman/shellcheck/wiki/SC2044


# >>> Helper functions

# Check if a command exists (without redirecting each time)
command_exists() {
    if command -v "${1}" >/dev/null 2>&1
    then
        return 0
    else
        return 1
    fi
}

# Check if 1st string contains the 2nd
contains_string() {
    string="${1}"
    substring="${2}"

    if [ "${string#*${substring}}" != "${string}" ]
    then
        # $substring is in $string
        return 0
    else
        # $substring is not in $string
        return 1
    fi
}

# Source a file if it exists
source_file() {
    [ -f "${1}" ] && . "${1}"
}

# Add a directory to PATH
# This function first checks if specified directory
# already is in path, if it is not and it exists
# it is added to the path
add_to_path() {
    if ! contains_string "${PATH}" "${1}"
    then
        if [ -d "${1}" ]
        then
            export PATH=${PATH}:${1}
        fi
    fi
}

# A.K.A - safe alias
# create a alias only if a command and/or alias
# with the desired name does not exist
a_k_a() {
    if ! command_exists "${1}"
    then
        alias "${1}"="${2}"
    fi
}

# Change-directory alias
# ${1} - alias name
# ${2} - directory
# Example:
#   cd_alias etc /etc
#   Means:
#     alias etc="cd /etc && echo * Changed the Directory to etc"
cd_alias() {
    # Check if target directory exits
    if [ -d "${2}" ]
    then
        a_k_a "${1}" "cd ${2} && echo ' * Changed the Directory to' ${2}"
    fi
}

# Are you root?
am_i_root() {
    if [ "$(whoami)" = root ]
    then
        return 0
    else
        return 1
    fi
}

# Check Git branch
pre_git_check=""
post_git_check=""
git_check() {
    branch="$(git branch 2>/dev/null | sed -n -e 's/^\* \(.*\)/\1/p')"
    [ -n "${branch}" ] && echo "${pre_git_check}${branch}${post_git_check}"
}

# Make a directory and cd into it
mkcd() {
    mkdir "${1}" && cd "${1}" || return 1
}

# Open a link in Emacs web browser
# $1 - URL
# $2 - a additional flag, i.e. -nw
eww() {
    eval emacs "${2}" \
         --eval "'(eww" "\"" "${1}" "\"" ")'"
}


# >>> Environment

# Source the system profile
source_file /etc/profile

# Auto-set the editor
if command_exists emacs
then
    if pgrep -u "${USER}" -f 'emacs --daemon' >/dev/null 2>&1
    then
        EDITOR=emacsclient
    else
        EDITOR=emacs
    fi
elif command_exists vim
then
    EDITOR=vim
else
    EDITOR=nano
fi
export EDITOR

# Cargo directory
CARGO_HOME="${HOME}/.local/share/cargo"
export CARGO_HOME

# Erlang (OTP) history file (in ~/.cache/erlang-history)
ERL_AFLAGS="-kernel shell_history enabled"
export ERL_AFLAGS

# Guile history file
GUILE_HISTORY=${HOME}/.cache/guile/history
export GUILE_HISTORY

# Octave history file
OCTAVE_HISTFILE=${HOME}/.cache/octave_repl_history
export OCTAVE_HISTFILE

# Ipython & Jupyter directory
IPYTHONDIR="${HOME}/.config/jupyter"
export IPYTHONDIR
JUPYTER_CONFIG_DIR="${HOME}/.config/jupyter"
export JUPYTER_CONFIG_DIR

# Racket directory
PLTUSERHOME="${HOME}/.local/share/racket"
export PLTUSERHOME

# Disable less history file
LESSHISTFILE=-
export LESSHISTFILE

# Node
NODE_REPL_HISTORY="${HOME}/.cache/node_repl_history"
export NODE_REPL_HISTORY
NPM_CONFIG_USERCONFIG="${HOME}/.config/npm/npmrc"
export NPM_CONFIG_USERCONFIG

# ZSH directories
# Set where the rest of ZSH files are located
ZDOTDIR="${HOME}/.config/zsh"
export ZDOTDIR
# Set where ZSH cache is stored
ZCACHEDIR="${HOME}/.cache/zsh"
export ZCACHEDIR

# If we're root we don't need sudo in most cases (covered here)
if [ "$(whoami)" = "root" ]
then
    NEED_UID0=""
else
    NEED_UID0="sudo"
fi
export NEED_UID0


# >>> PATH setup

# We also add old path for compatibility (ie. Cargo & NPM)
# the other one is the one exported by this profile file

# Common programs' homes
add_to_path /bin
add_to_path /opt/bin
add_to_path /sbin
add_to_path /usr/bin
add_to_path /usr/local/bin
add_to_path /usr/local/sbin
add_to_path /usr/sbin

# User's programs
add_to_path "${HOME}/.bin"
add_to_path "${HOME}/.local/share/bin"

# Cabal (Haskell)
add_to_path "${HOME}/.cabal/bin"

# Cargo (Rust)
add_to_path "${HOME}/.cargo/bin"
add_to_path "${HOME}/.local/share/cargo/bin"

# GO
add_to_path "${HOME}/go/bin"

# NPM (Node)
add_to_path "${HOME}/.npm/bin"
add_to_path "${HOME}/.local/share/npm/bin"

# Python
add_to_path "${HOME}/.local/bin"

# Racket
if [ -d "${PLTUSERHOME}"/.racket ]
then
    # We loop to include all different Racket implementation directories
    # ~/.local/share/racket/.racket/7.0/bin or ~/.local/share/racket/.racket/7.7/bin
    for racket_bin_dir in $(find "${PLTUSERHOME}"/.racket -name bin -type d)
    do
        add_to_path "${racket_bin_dir}"
    done
    unset racket_bin_dir
fi


# >>> Aliases

# Operating System specific
case $(uname)
in
    *Linux*)
        a_k_a ll 'ls -lahF --color=always'
        a_k_a ta 'tree -a -I ".git"'
        a_k_a t 'tree -a -L 2 -I ".git"'
        alias grep='grep --colour=always'
        alias ls='ls --color=auto'
        alias tree='tree -C -F'
        ;;
    *)
        a_k_a ll 'ls -lahF'
        a_k_a t 'tree -a -L 2'
        alias tree='tree -F'
        ;;
esac

# System
a_k_a rp 'sudo '
a_k_a update-grub '${NEED_UID0} grub-mkconfig -o /boot/grub/grub.cfg'

# Network
a_k_a no-net-sh 'unshare -r -n ${SH}'
a_k_a seen '${NEED_UID0} watch arp-scan --localnet'
a_k_a seeo '${NEED_UID0} netstat -acnptu'
alias mtr='mtr --show-ips --curses'

# Editors
if command_exists emacs
then
    a_k_a e 'emacs -nw'
else
    a_k_a e '${EDITOR}'
fi
if command_exists nano
then
    a_k_a n 'nano'
else
    a_k_a n '${EDITOR}'
fi
if command_exists vim
then
    a_k_a v 'vim'
else
    a_k_a v '${EDITOR}'
fi
a_k_a ,, 'cd ../..'
a_k_a ec 'emacsclient -a ""'
a_k_a ec-kill 'emacsclient -n --eval "(kill-emacs)"'
a_k_a ecf 'emacsclient -a "" -n -c'
a_k_a ecg 'emacsclient -a "" -n -c --eval "(gui-reload)"'
a_k_a ed-restart 'ec-kill ; emacs --daemon && emacsclient --eval "(config-reload)"'
a_k_a ed-start 'emacs --daemon'
a_k_a ed-stop 'ec-kill'
a_k_a eq 'emacs -Q -nw --eval "(setq auto-save-default nil create-lockfiles nil make-backup-files nil scroll-conservatively 100 x-select-enable-clipboard-manager nil)"'
a_k_a hl 'highlight -O truecolor'
a_k_a nranger 'EDITOR=nano ranger'
a_k_a nuke 'rm -rfd'
a_k_a open 'xdg-open'
a_k_a rcp 'rsync --stats --progress'

# Shell
a_k_a ash 'busybox ash'
a_k_a clear-zhistory 'cat /dev/null > ${ZCACHEDIR}/history'
a_k_a ed-bashrc '${EDITOR} ${HOME}/.bashrc'
a_k_a ed-shrc '${EDITOR} ${HOME}/.profile'
a_k_a ed-zshrc '${EDITOR} ${ZDOTDIR}/.zshrc'
a_k_a so-bashrc 'source ${HOME}/.bashrc'
a_k_a so-shrc 'source ${HOME}/.profile'
a_k_a so-zshrc 'source ${ZDOTDIR}/.zshrc'
a_k_a update-mydot 'mydot && sh update && cd -'

# Git
a_k_a Ga 'git add .'
a_k_a Gc 'git commit'
a_k_a Gd 'git diff'
a_k_a Gg 'git pull'
a_k_a Gl 'git log --oneline --graph'
a_k_a Go 'git clone --recursive --verbose'
a_k_a Gp 'git push'
a_k_a Gr 'git reset --hard'
a_k_a Gs 'git status'

# Programming
a_k_a diff-git 'git diff --no-index'
a_k_a ipy 'ipython'
a_k_a py 'python'
a_k_a rkt 'racket'

# Portage
a_k_a E 'tail -f ${EPREFIX}/var/log/emerge.log'
a_k_a F 'tail -f ${EPREFIX}/var/log/emerge-fetch.log'
a_k_a P 'cd ${EPREFIX}/etc/portage && tree -a -L 2'
a_k_a chu '${NEED_UID0} emerge -avNUD @world'
a_k_a ewup '${NEED_UID0} emerge -avuDNU --with-bdeps=y @world'
a_k_a pep '${NEED_UID0} emerge -av'
a_k_a slr '${NEED_UID0} smart-live-rebuild'
a_k_a vmerge '${NEED_UID0} emerge --verbose --jobs=1 --quiet-build=n'

# Other PKG managers
a_k_a fpk 'flatpak --user'
a_k_a fpkup 'flatpak --user update && flatpak --user uninstall --unused'

# youtube-dl
a_k_a ytd 'youtube-dl -i -o "%(title)s.%(ext)s"'
a_k_a ytd-bestaudio 'youtube-dl -i -f bestaudio -x -o "%(playlist_index)s - %(title)s.%(ext)s"'
a_k_a ytd-flac 'youtube-dl -i -f bestaudio -x --audio-format flac -o "%(playlist_index)s - %(title)s.%(ext)s"'
a_k_a ytd-mp3 'youtube-dl -i -f bestaudio -x --audio-format mp3 -o "%(playlist_index)s - %(title)s.%(ext)s"'
a_k_a ytd-mp4 'youtube-dl -i -f mp4 -o "%(title)s.%(ext)s"'
a_k_a ytd-opus 'youtube-dl -i -f bestaudio -x --audio-format opus -o "%(playlist_index)s - %(title)s.%(ext)s"'
a_k_a ytd-sub-en 'youtube-dl -i --write-srt --sub-lang en -o "%(title)s.%(ext)s"'
a_k_a ytd-sub-pl 'youtube-dl -i --write-srt --sub-lang pl -o "%(title)s.%(ext)s"'
a_k_a ytd-webm 'youtube-dl -i --format webm -o "%(title)s.%(ext)s"'


# >>> Change-directory aliases

# Compatibility (should be skipped - target dir probably doesn't exist)
cd_alias mydot "${HOME}"/mydot

# System
cd_alias conf /etc/conf.d
cd_alias gentoo-tree /var/db/repos/gentoo
cd_alias linux-src /usr/src/linux
cd_alias localht /var/www/localhost/htdocs
cd_alias logs /var/log
cd_alias services /etc/init.d
cd_alias tmp /tmp
cd_alias www /var/www

# User - standard
cd_alias data "${HOME}"/Data
cd_alias desktop "${HOME}"/Desktop
cd_alias diary "${HOME}"/Documents/Diary
cd_alias documents "${HOME}"/Documents
cd_alias downloads "${HOME}"/Downloads
cd_alias games "${HOME}"/Games
cd_alias music "${HOME}"/Music
cd_alias pictures "${HOME}"/Pictures
cd_alias programming "${HOME}"/Documents/Programming
cd_alias videos "${HOME}"/Videos

# User - git
cd_alias eternal "${HOME}"/Git/eternal
cd_alias gentoo-dev "${HOME}"/Git/gentoo
cd_alias guru "${HOME}"/Git/gentoo/guru
cd_alias mine "${HOME}"/Git/mine
cd_alias mydot "${HOME}"/Git/mine/mydot
cd_alias other "${HOME}"/Git/other
cd_alias pre "${HOME}"/Git/pre
cd_alias src_ "${HOME}"/Git/src_prepare
cd_alias src_overlay "${HOME}"/Git/src_prepare/src_prepare-overlay

# User - hidden
cd_alias applications "${HOME}"/.local/share/applications
cd_alias apps "${HOME}"/.local/share/applications
cd_alias autostart "${HOME}"/.config/autostart
cd_alias bins "${HOME}"/.bin
cd_alias config "${HOME}"/.config
cd_alias zcachedir "${ZCACHEDIR}"
cd_alias zdotdir "${ZDOTDIR}"


# >>> Prompt theme

PS1="(SH)> "
export PS1

PS2="└── "
export PS2


# >>> Autostart the GPG Agent

# Export some vars
GPG_TTY=$(tty)
export GPG_TTY
PINENTRY_USER_DATA="USE_CURSES=1"
export PINENTRY_USER_DATA

# Check if GPG agent exists
if ! am_i_root && command_exists gpg-agent
then
    # Start GPG agent if it is not running
    pgrep -u "${USER}" gpg-agent >/dev/null 2>&1 || gpg-agent --daemon 2>/dev/null
fi


# >>> Autostart the SSH Agent

# Check if SSH agent and XDG runtime directory exist
if ! am_i_root && command_exists ssh-agent && [ -d "${XDG_RUNTIME_DIR}" ]
then
    # Start SSH agent if it is not running
    pgrep -u "${USER}" ssh-agent >/dev/null 2>&1 || ssh-agent > "${XDG_RUNTIME_DIR}/ssh-agent.env"
    [ -e "${SSH_AUTH_SOCK}" ] || eval "$(cat "${XDG_RUNTIME_DIR}/ssh-agent.env")" >/dev/null 2>&1
fi


# >>> Autostart X11 if it is available

# If you enable autologin on getty this can replace a Display Manager
# c1:12345:respawn:/sbin/agetty --autologin <user> --noclear 38400 tty1 linux

if ! am_i_root && [ "$(tty)" = /dev/tty1 ] && command_exists startx && [ ! "${DISPLAY}" ]
then
    startx ~/.xinitrc || echo "Failed to start the default X session"
fi
