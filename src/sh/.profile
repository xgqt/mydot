#!/bin/sh


# This file is part of mydot.

# mydot is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# mydot is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with mydot.  If not, see <https://www.gnu.org/licenses/>.

# Copyright (c) 2020-2021, Maciej Barć <xgqt@riseup.net>
# Licensed under the GNU GPL v3 License

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

# Ignore "For loops over find output are fragile. Use find -exec or a while read loop."
# We nned to pass a function defined here and 'find -exec' does not support that
# shellcheck disable=2044
# https://github.com/koalaman/shellcheck/wiki/SC2044

# Ignore "This expands when defined, not when used. Consider escaping."
# We want that for aliases
# shellcheck disable=2139
# https://github.com/koalaman/shellcheck/wiki/SC2139

# Ignore "Possible misspelling: ZCACHEDIR may not be assigned, but CCACHE_DIR is."
# shellcheck disable=2153
# https://github.com/koalaman/shellcheck/wiki/SC2153


# >>> Helper functions

# Send stdout and stderr of 'command' to /dev/null
# Basically this will return the exit status
nullwrap() {
    "${@}" >/dev/null 2>&1
}

# Check if a command exists (without redirecting each time)
command_exists() {
    if nullwrap type "${1}"
    then
        return 0
    else
        return 1
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

# Re-bind
# If a given command exists ($1):
# alias 2nd command ($2) to a given string ($2).
# For bigger cases just use if statement,
# see python below.
rbind() {
    if command_exists "${1}" && [ -n "${3}" ]
    then
        case "${4}"
        in
            "" | -u | -unsafe | --unsafe )
                alias "${2}"="${3}"
                ;;
            -s | -safe | --safe )
                a_k_a "${2}" "${3}"
                ;;
        esac
    fi
}

# Check if 1st string contains the 2nd
contains_string() {
    _string="${1}"
    _substring="${2}"
    if [ "${_string#*${_substring}}" != "${_string}" ]
    then
        # $_substring is in $_string
        return 0
    else
        # $_substring is not in $_string
        return 1
    fi
    unset _string
    unset _substring
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
            export PATH="${PATH}:${1}"
        fi
    fi
}

# Are you root?
am_i_root() {
    if [ "$(whoami)" = "root" ]
    then
        return 0
    else
        return 1
    fi
}

# Make a directory and cd into it
mkcd() {
    mkdir -p "${*}"
    cd "${*}" || return 1
}

# Source a file if it exists
source_file() {
    [ -f "${1}" ] && . "${1}"
}


# >>> System

# Failsafe PATH (because '[' and ']' are programs)
PATH="${PATH:-/bin:/sbin:/usr/bin:/usr/local/bin}"

# Source the system profile
source_file "/etc/profile"


# >>> Terminal features

# Disable terminal scroll lock
command_exists stty && stty -ixon


# >>> Environment

# User's name
# Keep this first
USER="${USER:-$(whoami)}"
export USER

# User's identification number
# Keep this second
if [ -z "${UID}" ] && command_exists id
then
    UID="$(id -u "${USER}")"
fi
export UID

# Auto-set the editor
if command_exists emacs
then
    if nullwrap pgrep -fi -u "${USER}" 'emacs --daemon'
    then
        EDITOR="emacsclient"
    else
        EDITOR="emacs"
    fi
else
    for editor in xemacs zile mg neovim vim vi nano ed
    do
        if command_exists "${editor}"
        then
            EDITOR="${editor}"
            break
        fi
    done
    unset editor
fi
export EDITOR

# Auto-set the pager
if [ -z "${PAGER}" ]
then
    for pager in less cat
    do
        if command_exists "${pager}"
        then
            PAGER="${pager}"
            break
        fi
    done
    unset pager
fi
export PAGER

# Aspell settings
_aspell_dir="${HOME}/.config/aspell"
if nullwrap mkdir -p "${_aspell_dir}"
then
    # has to be one line like this
    ASPELL_CONF="per-conf ${_aspell_dir}/aspell.conf; personal ${_aspell_dir}/en.pws; repl ${_aspell_dir}/en.prepl"
    export ASPELL_CONF
fi
unset _aspell_dir

# CCache directory
# Exclude root user - breaks ccache in portage
if am_i_root
then
    unset CCACHE_DIR
else
    # primary config is then ~/.cache/ccache/ccache.conf
    CCACHE_DIR="${HOME}/.cache/ccache"
    export CCACHE_DIR
fi

# Chez directory (used by aliases)
_chez_history="${HOME}/.config/chez/history"
if nullwrap mkdir -p "${_chez_history}"
then
    CHEZ_HISTORY="${_chez_history}"
    export CHEZ_HISTORY
fi
unset _chez_history

# Conan settings
CONAN_COLOR_DARK=1
export CONAN_COLOR_DARK
CONAN_USER_HOME="${HOME}/.local/share/conan"
export CONAN_USER_HOME

# .NET settings
# don't spy on me! Can you at least do that?
DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_CLI_TELEMETRY_OPTOUT

# Emacs (for now used only by the shell)
USER_EMACS_DIRECTORY="${HOME}/.config/emacs"
export USER_EMACS_DIRECTORY

# Erlang (OTP) history file (in ~/.cache/erlang-history)
ERL_AFLAGS="-kernel shell_history enabled"
export ERL_AFLAGS

# Go directory
GOPATH="${HOME}/.local/share/go"
export GOPATH

# GTK settings
if [ -f "${EPREFIX}/usr/libexec/xdg-desktop-portal" ]
then
    GTK_USE_PORTAL=1
    export GTK_USE_PORTAL
fi

# Guile history file
GUILE_HISTORY="${HOME}/.cache/guile/history"
export GUILE_HISTORY

# ICE (X11)
ICEAUTHORITY="${HOME}/.cache/ICEauthority"
export ICEAUTHORITY

# Ipython & Jupyter directory
IPYTHONDIR="${HOME}/.config/jupyter"
export IPYTHONDIR
JUPYTER_CONFIG_DIR="${HOME}/.config/jupyter"
export JUPYTER_CONFIG_DIR

# Java (miscellaneous tools settings)
# Gradle TODO: maybe switch to ~/.local/share
GRADLE_USER_HOME="${HOME}/.cache/gradle"
export GRADLE_USER_HOME

# ls colors
if command_exists dircolors && [ -z "${LS_COLORS}" ]
then
    eval "$(dircolors -b)"
fi

# Disable less history file
LESSHISTFILE=-
export LESSHISTFILE

# LibDVDcss cache directory
DVDCSS_CACHE="${HOME}/.cache/dvdcss"
export DVDCSS_CACHE

# Maxima directory
_maxima_userdir="${HOME}/.config/maxima"
if nullwrap mkdir -p "${_maxima_userdir}/.maxima"
then
    MAXIMA_USERDIR="${_maxima_userdir}"
    export MAXIMA_USERDIR
fi
unset _maxima_userdir

# Mednafen configuration directory
MEDNAFEN_HOME="${HOME}/.config/mednafen"
export MEDNAFEN_HOME

# NCurses directories
TERMINFO="${HOME}/.local/share/terminfo"
export TERMINFO
TERMINFO_DIRS="${HOME}/.local/share/terminfo:/usr/share/terminfo:${TERMINFO_DIRS}"
export TERMINFO_DIRS

# Node files
NODE_REPL_HISTORY="${HOME}/.cache/node_repl_history"
export NODE_REPL_HISTORY
NPM_CONFIG_USERCONFIG="${HOME}/.config/npm/npmrc"
export NPM_CONFIG_USERCONFIG

# Octave history file
OCTAVE_HISTFILE="${HOME}/.cache/octave_repl_history"
export OCTAVE_HISTFILE

# Pylint directory
PYLINTHOME="${HOME}/.cache/pylint"
export PYLINTHOME

# Racket directory
PLTUSERHOME="${HOME}/.local/share/racket"
export PLTUSERHOME

# Ruby (Gem) directories
GEM_HOME="${HOME}/.local/share/gem"
export GEM_HOME
GEM_SPEC_CACHE="${HOME}/.cache/gem"
export GEM_SPEC_CACHE

# Rust (Cargo) directory
CARGO_HOME="${HOME}/.local/share/cargo"
export CARGO_HOME

# Shell history
mkdir -p "${HOME}/.cache/sh"
HISTFILE="${HOME}/.cache/sh/history"
export HISTFILE
HISTSIZE=50000
export HISTSIZE

# TeX directories
TEXMFCONFIG="${HOME}/.config/texlive/texmf-config"
export TEXMFCONFIG
TEXMFHOME="${HOME}/.local/share/texlive/texmf"
export TEXMFHOME
TEXMFVAR="${HOME}/.cache/texlive/texmf-var"
export TEXMFVAR

# XDG Base Directory (failsafe)
XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"
nullwrap mkdir -p "${XDG_CACHE_HOME}" && export XDG_CACHE_HOME
XDG_CONFIG_DIRS="${XDG_CONFIG_DIRS:-/etc/xdg}"
nullwrap mkdir -p "${XDG_CONFIG_DIRS}" && export XDG_CONFIG_DIRS
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
nullwrap mkdir -p "${XDG_CONFIG_HOME}" && export XDG_CONFIG_HOME
XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
export XDG_DATA_DIRS
XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
nullwrap mkdir -p "${XDG_DATA_HOME}" && export XDG_DATA_HOME
if [ -z "${XDG_RUNTIME_DIR}" ] || [ ! -d "${XDG_RUNTIME_DIR}" ]
then
    for _XDG_CAND_BASE in "/run" "/tmp" "/tmp/xdg" "/tmp/${USER}" "${XDG_CACHE_HOME}"
    do
        if nullwrap mkdir -p "${_XDG_CAND_BASE}/user/${UID}"
        then
            XDG_RUNTIME_DIR="${_XDG_CAND_BASE}/user/${UID}"
            break
        fi
    done
    unset _XDG_CAND_BASE
fi
export XDG_RUNTIME_DIR
nullwrap chmod 0700 "${XDG_RUNTIME_DIR}"

# Xorg X11 Server
# Why here? We use XDG_RUNTIME_DIR for Xauthority
XAUTHORITY="${XAUTHORITY:-${XDG_RUNTIME_DIR}/Xauthority}"
export XAUTHORITY
XINITRC="${HOME}/.config/X11/xinitrc"
export XINITRC
XSERVERRC="${HOME}/.config/X11/xserverrc"
export XSERVERRC


# >>> PATH setup

# We also add old path for compatibility (ie. Cargo & NPM)
# the other one is the one exported by this profile file

# Common programs' homes
add_to_path "/bin"
add_to_path "/opt/bin"
add_to_path "/sbin"
add_to_path "/usr/bin"
add_to_path "/usr/libexec"
add_to_path "/usr/local/bin"
add_to_path "/usr/local/sbin"
add_to_path "/usr/sbin"

# Selected OPTional programs
add_to_path "/opt/src_prepare-scripts"
add_to_path "/usr/pkg/gnu/bin"

# Cabal (Haskell)
add_to_path "${HOME}/.cabal/bin"

# Cargo (Rust)
add_to_path "${HOME}/.cargo/bin"
add_to_path "${CARGO_HOME}/bin"

# GO
add_to_path "${GOPATH}/bin"

# NPM (Node)
add_to_path "${HOME}/.npm/bin"
add_to_path "${HOME}/.local/share/npm/bin"

# Python
add_to_path "${HOME}/.local/bin"

# Racket
if [ -d "${PLTUSERHOME}/.racket" ]
then
    # We loop to include all different Racket implementation directories
    # ~/.local/share/racket/.racket/7.0/bin or ~/.local/share/racket/.racket/7.7/bin
    for racket_bin_dir in $(find "${PLTUSERHOME}/.racket" -maxdepth 2 -name bin -type d)
    do
        add_to_path "${racket_bin_dir}"
    done
    unset racket_bin_dir
fi

# Ruby
add_to_path "${GEM_HOME}/bin"

# User's programs
# Keep this last
add_to_path "${HOME}/.bin"
add_to_path "${HOME}/.local/share/bin"


# >>> Aliases

# NEED_UID0 is used in the following aliases
# Keep this after adding itens to PATH
# If we're root we don't need sudo in most cases (covered here)
if am_i_root || [ -n "${EPREFIX}" ]
then
    NEED_UID0=""
else
    for _NEED_UID0 in doas sudo odus
    do
        if command_exists "${_NEED_UID0}"
        then
            NEED_UID0="${_NEED_UID0}"
            a_k_a sudo "${_NEED_UID0}"
            break
        fi
    done
    unset _NEED_UID0
fi
export NEED_UID0

# Operating System specific
# !!! Keep this first !!!
case "$(uname)"
in
    *Linux* )
        a_k_a t 'tree -I ".git" -L 2 -a'
        a_k_a ta 'tree -I ".git" -a'
        alias l='ls -A'
        alias ll='ls --color=always -Fahl'
        rbind ls ls 'ls --color=auto --group-directories-first'
        rbind tree tree 'tree -CF'
        ;;
    * )
        a_k_a t 'tree -L 2 -a'
        a_k_a ta 'tree -a'
        alias l='ls -A'
        alias ll='ls -Fahl'
        rbind tree 'tree -F'
        ;;
esac

# Editor
rbind emacs e 'emacs -nw' -s
rbind emacs em 'emacs' -s
a_k_a e '${EDITOR}'
rbind nano n 'nano' -s
a_k_a n '${EDITOR}'
rbind vim v 'vim' -s
a_k_a v '${EDITOR}'
rbind nvim vim 'nvim'
rbind vim vi 'vim'
rbind codium-bin codium 'codium-bin' -s
rbind codium code 'codium' -s

# Files
a_k_a ,, 'cd ../..'
a_k_a nuke 'rm -fr'
a_k_a tf 'tail -fv --retry'
rbind highlight hl 'highlight -O truecolor' -s
rbind ncdu ncdu 'ncdu --color=dark'
rbind rsync rcp 'rsync --stats --progress' -s
rbind xdg-open open 'xdg-open' -s

# Git
a_k_a G 'git'
a_k_a Ga 'git add .'
a_k_a Gc 'git commit --signoff'
a_k_a Gcc 'git log --cc --show-signature'
a_k_a Gd 'git diff'
a_k_a Gg 'git pull'
a_k_a Gl 'git log --oneline --graph'
a_k_a Go 'git clone --recursive --verbose'
a_k_a Gp 'git push'
a_k_a Gq 'git add . && git commit --signoff && git pull --rebase && git push'
a_k_a Gr 'git reset --hard'
a_k_a Gs 'git status'
a_k_a Gu 'git reset HEAD --'

# Multimedia
a_k_a ffsound 'ffplay -nodisp -hide_banner'

# Network
a_k_a no-net-sh 'unshare -r -n ${SH}'
a_k_a seen '${NEED_UID0} watch arp-scan --localnet'
a_k_a seeo '${NEED_UID0} netstat -acnptu'
rbind mtr mtr 'mtr --show-ips --curses'
rbind w3m w3m 'HOME="${HOME}/.cache" w3m'

# Other PKG managers
a_k_a fpk 'flatpak --user'
a_k_a fpkup 'flatpak --user update && flatpak --user uninstall --unused'
a_k_a raco-install 'raco pkg install --jobs $(nproc) --auto --user'

# Portage
a_k_a B 'tail -fv "$(portageq envvar PORTAGE_TMPDIR)"/portage/*/*/temp/build.log'
a_k_a E 'tail -fv ${EPREFIX}/var/log/emerge.log'
a_k_a F 'tail -fv ${EPREFIX}/var/log/emerge-fetch.log'
a_k_a P 'cd ${EPREFIX}/etc/portage && tree -a -L 2'
a_k_a chu '${NEED_UID0} emerge -avNUD @world'
a_k_a des '${NEED_UID0} emerge --deselect'
a_k_a ewup '${NEED_UID0} emerge -avuDNU --with-bdeps=y --backtrack=100 --verbose-conflicts @world'
a_k_a pep '${NEED_UID0} emerge --autounmask --ask --verbose'
a_k_a preb '${NEED_UID0} emerge --usepkg-exclude "*" -1 @preserved-rebuild'
a_k_a slr '${NEED_UID0} smart-live-rebuild -- --usepkg-exclude "*"'
a_k_a vmerge '${NEED_UID0} emerge --verbose --jobs=1 --quiet-build=n'

# Programming
# The following will attempt to alias 'python' as 'python3'
# if 'python' doesnt exist, also it creates 'py2'/'py3' aliases
if command_exists python3
then
    a_k_a py3 'python3'
    a_k_a python 'python3'
fi
if command_exists python2
then
    a_k_a py2 'python2'
    a_k_a python 'python2'
fi
a_k_a builddir 'mkdir -p ./build && cd ./build'
a_k_a chez 'chezscheme --eehistory "${CHEZ_HISTORY}"'
a_k_a diff-git 'git diff --no-index'
a_k_a ff 'firefox'
a_k_a hs 'ghci'
a_k_a ipy 'ipython'
a_k_a py 'python'
a_k_a rb 'irb'
a_k_a rkt 'racket'
a_k_a scm 'scheme'
a_k_a tcl 'tclsh'
rbind chez chez 'chez --eehistory "${CHEZ_HISTORY}"'
rbind chezscheme chezscheme 'chezscheme --eehistory "${CHEZ_HISTORY}"'
rbind petite petite 'petite --eehistory "${CHEZ_HISTORY}"'

# Shell
a_k_a cl-zhistory 'cat /dev/null > ${ZCACHEDIR}/history'
a_k_a ed-bashrc '${EDITOR} ${HOME}/.bashrc'
a_k_a ed-shrc '${EDITOR} ${HOME}/.profile'
a_k_a ed-zshrc '${EDITOR} ${ZDOTDIR}/.zshrc'
a_k_a shell '${SHELL}'
a_k_a so-bashrc 'source ${HOME}/.bashrc'
a_k_a so-shrc 'source ${HOME}/.profile'
a_k_a so-zshrc 'source ${ZDOTDIR}/.zshrc'

# System
a_k_a cpuinfo 'cat /proc/cpuinfo'
a_k_a kerr '${NEED_UID0} dmesg --level=alert,crit,emerg,err,warn --time-format=reltime --color'
a_k_a man-pl 'LANG="pl_PL.UTF-8" man'
a_k_a root 'su -l root'
a_k_a rp '${NEED_UID0} '
a_k_a running '(env | sort ; alias ; functions) 2>/dev/null | ${PAGER}'
a_k_a update-grub '${NEED_UID0} grub-mkconfig -o /boot/grub/grub.cfg'

# Youtube-DL
a_k_a ytd 'youtube-dl -i -o "%(title)s.%(ext)s"'
a_k_a ytd-bestaudio 'youtube-dl -i -f bestaudio -x -o "%(playlist_index)s - %(title)s.%(ext)s"'
a_k_a ytd-flac 'youtube-dl -i -f bestaudio -x --audio-format flac -o "%(playlist_index)s - %(title)s.%(ext)s"'
a_k_a ytd-mp3 'youtube-dl -i -f bestaudio -x --audio-format mp3 -o "%(playlist_index)s - %(title)s.%(ext)s"'
a_k_a ytd-mp4 'youtube-dl -i -f mp4 -o "%(title)s.%(ext)s"'
a_k_a ytd-opus 'youtube-dl -i -f bestaudio -x --audio-format opus -o "%(playlist_index)s - %(title)s.%(ext)s"'
a_k_a ytd-sub-en 'youtube-dl -i --write-srt --sub-lang en -o "%(title)s.%(ext)s"'
a_k_a ytd-sub-pl 'youtube-dl -i --write-srt --sub-lang pl -o "%(title)s.%(ext)s"'
a_k_a ytd-webm 'youtube-dl -i --format webm -o "%(title)s.%(ext)s"'

# Busybox
# If BB is installed, then try to get unavailable programs from it
# !!! Keep this last !!!
if command_exists busybox
then
    for _bb_impl in $(busybox --list)
    do
        a_k_a "${_bb_impl}" "busybox ${_bb_impl}"
    done
    unset _bb_impl
fi


# >>> Prompt theme

PS1="(SH)> "
export PS1

PS2="... "
export PS2


# >>> Autostart the GPG Agent

# Export some vars
GPG_TTY="$(tty)"
export GPG_TTY
PINENTRY_USER_DATA="USE_CURSES=1"
export PINENTRY_USER_DATA

# Check if GPG agent exists
if ! am_i_root && command_exists gpg-agent
then
    # Start GPG agent if it is not running
    nullwrap pgrep -i -u "${USER}" gpg-agent || gpg-agent --daemon 2>/dev/null
fi


# >>> Autostart the SSH Agent

# Check if SSH agent and XDG runtime directory exist
if ! am_i_root && command_exists ssh-agent && [ -d "${XDG_RUNTIME_DIR}" ]
then
    # Start SSH agent if it is not running
    nullwrap pgrep -i -u "${USER}" ssh-agent || ssh-agent > "${XDG_RUNTIME_DIR}/ssh-agent.env"
    [ -e "${SSH_AUTH_SOCK}" ] || nullwrap eval "$(cat "${XDG_RUNTIME_DIR}/ssh-agent.env")"
fi


# >>> Additional source

# I guess that GPG and SSH agents
# don't need to be in separate files

# Source additional files
# that are not critical to running the shell
if [ -d "${HOME}/.config/sh" ]
then
    for _shext in "${HOME}/.config/sh"/?*
    do
        source_file "${_shext}"
    done
    unset _shext
fi