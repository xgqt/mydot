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

# Copyright (c) 2021, Maciej Barć <xgqt@riseup.net>
# Licensed under the GNU GPL v3 License


trap 'exit 128' INT
export PATH


mkdir -p "${HOME}/.local/share/man/eclass/eclasses"
mkdir -p "${HOME}/.local/share/man/eclass/man5"
cd "${HOME}/.local/share/man/eclass"  || exit 1

[ ! -d "${EPREFIX}/var/db/repos" ] && exit 1
cp -n "${EPREFIX}"/var/db/repos/*/eclass/*.eclass ./eclasses  || exit 1

[ ! -e ./eclass-to-manpage ] &&
    git clone --depth 1 "https://github.com/mgorny/eclass-to-manpage"


cd  ./eclasses  || exit 1

for i in *.eclass
do
    echo "  - generating: ${i}"
    ../eclass-to-manpage/eclass-to-manpage.awk "${i}" > ../man5/"${i}.5"
done