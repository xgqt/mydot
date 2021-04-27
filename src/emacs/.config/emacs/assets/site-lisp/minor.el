;;; minor.el --- small tweaks that don't require packages.


;; This file is part of mydot.

;; mydot is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, version 3.

;; mydot is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with mydot.  If not, see <https://www.gnu.org/licenses/>.

;; Copyright (c) 2020-2021, Maciej Barć <xgqt@riseup.net>
;; Licensed under the GNU GPL v3 License



;;; Commentary:

;; Some small tweaks that don't require packages.

;; Use with mydot: https://gitlab.com/xgqt/mydot



;;; Code:


(require 'autorevert)
(require 'hl-line)
(require 'paren)
(require 'prog-mode)
(require 'xt-mouse)


;; Pass "y or n" instead of "yes or no"
(defalias 'yes-or-no-p 'y-or-n-p)

;; Use tabs as spaces
(setq-default indent-tabs-mode nil)

;; Column number display in the mode line
(setq column-number-mode t)

;; disable lock files:
(setq create-lockfiles nil)

;; disable autosave:
(setq auto-save-default nil)

;; backups directory
;;(setq backup-directory-alist '(("" . (w-u-e-d "backup"))))

;; no "bell" (audible notification):
(setq ring-bell-function 'ignore)

;; Scrolling
(setq scroll-conservatively 100)

;; Disable backups
(setq make-backup-files nil)

;; Disable clipboard
(setq x-select-enable-clipboard-manager nil)

;; Specal symbols
(when window-system
  (global-prettify-symbols-mode t)
  )

;; Size in GUI
(when window-system
  (set-frame-size (selected-frame) 88 36)
  )

;; Auto reloading of buffers
(global-auto-revert-mode t)

;; Highlighting of current line
(global-hl-line-mode t)

;; Highlight parens
(show-paren-mode t)

;; Use mouse in xterm
(xterm-mouse-mode t)


(provide 'minor)



;;; minor.el ends here
