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

# Change-directory aliases


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


# System
cd_alias conf         "/etc/conf.d"
cd_alias repos        "/var/db/repos"
cd_alias linux-src    "/usr/src/linux"
cd_alias localht      "/var/www/localhost/htdocs"
cd_alias logs         "/var/log"
cd_alias services     "/etc/init.d"
cd_alias tmp          "/tmp"
cd_alias www          "/var/www"

# User - standard
cd_alias data         "${HOME}/Data"
cd_alias desktop      "${HOME}/Desktop"
cd_alias diary        "${HOME}/Documents/Diary"
cd_alias documents    "${HOME}/Documents"
cd_alias downloads    "${HOME}/Downloads"
cd_alias games        "${HOME}/Games"
cd_alias music        "${HOME}/Music"
cd_alias pictures     "${HOME}/Pictures"
cd_alias programming  "${HOME}/Documents/Programming"
cd_alias videos       "${HOME}/Videos"

# User - hidden
cd_alias applications "${HOME}/.local/share/applications"
cd_alias apps         "${HOME}/.local/share/applications"
cd_alias autostart    "${HOME}/.config/autostart"
cd_alias bins         "${HOME}/.bin"
cd_alias cache        "${HOME}/.cache"
cd_alias config       "${HOME}/.config"
cd_alias data         "${HOME}/.local/share"
cd_alias eprefix      "${EPREFIX}"
cd_alias zcachedir    "${ZCACHEDIR}"
cd_alias zdotdir      "${ZDOTDIR}"
