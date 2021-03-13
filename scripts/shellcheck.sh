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

# shellcheck disable=2086


exit_result=0

# Standard shell / bash files
s_files="$(grep -R --exclude-dir='.git' --exclude-dir='zsh' '^#!/.*sh$' 2>/dev/null | cut -d ':' -f 1)"

# ZSH files
z_files="$(grep -R --exclude-dir='.git' --exclude-dir='plugins' --exclude="*.zsh-theme" '^#!/.*zsh$' 2>/dev/null | cut -d ':' -f 1)"


check_files() {
    for i in "${@}"
    do
        echo "File ${i}... checking"
        if ${command} "${i}"
        then
            echo "    file is correct"
        else
            echo "    there were errors found in the file"
            exit_result=1
        fi
        echo "File ${i}... done"
        echo
    done
}

command="shellcheck"
check_files ${s_files}

command="shellcheck --shell=bash"
check_files ${z_files}

if [ ${exit_result} = 0 ]
then
    echo "No errors reported"
    echo "Exiting successfully"
    exit ${exit_result}
else
    echo "Some errors reported"
    echo "Exiting without success"
    exit ${exit_result}
fi