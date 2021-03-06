#!/bin/sh


# This file is part of mydot.

# mydot is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, version 3.

# mydot is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with mydot.  If not, see <https://www.gnu.org/licenses/>.

# Copyright (c) 2020-2021, Maciej Barć <xgqt@riseup.net>
# Licensed under the GNU GPL v3 License

# This file is meant to be sourced by ~/.profile from mydot

# Windows CMD-like aliases, more or less...
# Because why not? ;P

# Commands from:
# https://fossbytes.com/complete-windows-cmd-commands-list-index

# shellcheck disable=2016


a_k_a attrib 'chmod'
a_k_a cacls 'chown'
a_k_a call 'sh'
a_k_a chkdsk 'fsck'
a_k_a cls 'clear'
a_k_a comp 'diff --side-by-side --color=always'
a_k_a copy 'cp'
a_k_a del 'rm -f'
a_k_a diskpart 'parted -a optimal'
a_k_a doskey 'alias'
a_k_a driverquery 'lsmod | sort'
a_k_a erase 'rm -Irv'
a_k_a explorer 'xdg-open "$(pwd)"'
a_k_a findstr 'grep --colour=always --exclude-dir=".git" -HIRin'
a_k_a getmac 'ip maddress'
a_k_a ifmember 'groups ${USER}'
a_k_a ipconfig 'ifconfig'
a_k_a logoff 'loginctl kill-user'
a_k_a md 'mkdir -p'
a_k_a mklink 'ln -fsv'
a_k_a move 'mv'
a_k_a msg 'notify-send'
a_k_a openfiles 'lsof'
a_k_a path 'echo ${PATH} | sed "s/:/\n/g"'
a_k_a pause 'sleep'
a_k_a prompt 'echo "PS1 = ${PS1}" && echo "PS2 = ${PS2}"'
a_k_a psloggedon 'loginctl list-sessions'
a_k_a rd 'rm -r'
a_k_a ren 'rename'
a_k_a runas '${NEED_UID0} -u'
a_k_a schtasks 'crontab -e'
a_k_a systeminfo 'uname -a'
a_k_a takeown 'chown ${USER}:${USER}'
a_k_a taskkill 'pkill -e'
a_k_a tasklist 'ps avx'
a_k_a title 'echo "${PROMPT_COMMAND}"'
a_k_a ver 'cat /proc/version'
a_k_a vol 'lsblk -af'
a_k_a xcopy 'cp -riv'
