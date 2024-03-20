;;; cc-isearch-menu.el --- A Transient menu for isearch -*- lexical-binding: t; -*-

;; Copyright (C) 2023-2024  Charles Choi

;; Author: Charles Choi <kickingvegas@gmail.com>
;; URL: https://github.com/kickingvegas/cc-isearch-menu
;; Keywords: wp
;; Version: 1.2.2
;; Package-Requires: ((emacs "29.1"))
;;

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Provides a Transient menu interface to a subset of isearch functions.
;; Said functions are grouped as follows in the following sections:
;; - Edit Search String
;; - Replace
;; - Toggle
;; - Misc
;; - Navigation

;; INSTALLATION
;; Enter the code below into your init file to load and install
;; `cc-isearch-menu'.  Tune the keybinding to your taste.

;; (require 'cc-isearch-menu)
;; (define-key isearch-mode-map (kbd "<f2>") 'cc-isearch-menu-transient)

;;; Code:

(require 'transient)

(transient-define-prefix cc-isearch-menu-transient ()
  "Transient menu for isearch."
  [["Edit Search String"
    ("e"
     "Edit the search string (recursive)"
     isearch-edit-string
     :transient t)
    ("w"
     "Pull next word or character from buffer"
     isearch-yank-word-or-char
     :transient t)
    ("s"
     "Pull next symbol or character from buffer"
     isearch-yank-symbol-or-char
     :transient t)
    ("l"
     "Pull rest of line from buffer"
     isearch-yank-line
     :transient t)
    ("y"
     "Pull string from kill ring"
     isearch-yank-kill
     :transient t)
    ("t"
     "Pull thing from buffer"
     isearch-forward-thing-at-point
     :transient t)]

   ["Replace"
    ("r"
     "Start ‘query-replace’"
     isearch-query-replace
     :if-nil buffer-read-only
     :transient nil)
    ("x"
     "Start ‘query-replace-regexp’"
     isearch-query-replace-regexp
     :if-nil buffer-read-only
     :transient nil)]]

  [["Toggle"
    ("X"
     "Regexp searching"
     isearch-toggle-regexp
     :transient t)
    ("S"
     "Symbol searching"
     isearch-toggle-symbol
     :transient t)
    ("W"
     "Word searching"
     isearch-toggle-word
     :transient t)
    ("F"
     "Case fold"
     isearch-toggle-case-fold
     :transient t)
    ("L"
     "Lax whitespace"
     isearch-toggle-lax-whitespace
     :transient t)]

   ["Misc"
    ("o"
     "occur"
     isearch-occur
     :transient nil)
    ("h"
     "highlight"
     isearch-highlight-regexp
     :transient nil)
    ("H"
     "highlight lines"
     isearch-highlight-lines-matching-regexp
     :transient nil)]

   ["Navigation"
    ("n" "Next"
     isearch-repeat-forward
     :transient t)
    ("p" "Previous"
     isearch-repeat-backward
     :transient t)]]

  [("q" "Dismiss" ignore :transient transient--do-exit)])

(provide 'cc-isearch-menu)
;;; cc-isearch-menu.el ends here
