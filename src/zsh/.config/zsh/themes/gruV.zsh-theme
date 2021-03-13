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

# Copyright (c) 2020-2021, Maciej Barć <xgqt@riseup.net>
# Licensed under the GNU GPL v3 License


PROMPT=$'%{\e[33m%}┌──╸%{\e[37m%}%n%{\e[33m%}::%{\e[37m%}%m%{\e[33m%} %{\e[31m%}%~%{\e[33m%}
└[%{\e[37m%}%!%{\e[33m%}::%{\e[37m%}%?%{\e[33m%}]──╸%{\e[0m%} '

RPROMPT=$'%{\e[33m%}[%*─%W]%{\e[0m%}'