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

# Some python modules that can be executed like a shell command

# This file is meant to be sourced by ~/.profile from mydot


a_k_a http.server 'python -m http.server'

for _m in \
    appdirs \
    ast \
    asyncio \
    bottle \
    cProfile \
    calendar \
    cgi \
    code \
    compileall \
    dis \
    doctest \
    ensurepip \
    entrypoints \
    ipykernel \
    jedi \
    lib2to3 \
    mailcap \
    mccabe \
    mimetypes \
    modulefinder \
    nbconvert \
    nntplib \
    notebook \
    patch_ng \
    pickle \
    pickletools \
    platform \
    profile \
    pstats \
    pybind11 \
    pygments \
    pyparsing \
    qtconsole \
    smtpd \
    sphinx \
    symtable \
    sysconfig \
    tabnanny \
    tarfile \
    textwrap \
    this \
    timeit \
    tokenize \
    trace \
    unittest \
    uu \
    venv \
    virtualenv \
    zipapp \
    zipfile
do
    a_k_a "${_m}" "python -m ${_m}"
done
unset _m
