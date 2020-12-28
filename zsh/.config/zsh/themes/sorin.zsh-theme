#!/usr/bin/env zsh


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

# Copyright (c) 2020, XGQT
# Licensed under the GNU GPL v3 License


post_git_check=" "

PROMPT=$'%F{cyan}%~ %F{white}$(git_check)%B%F{red}>%F{yellow}>%F{green}>%b%f '

RPROMPT=$'%(?..%B%F{red}%? \u2ba0 %f%b)'
