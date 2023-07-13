;;; init-org.el --- -*- lexical-binding: t -*-;;;; Filename: init-org.el;; Description: Initialize Org, Toc-org, HTMLize, OX-GFM;; Author: Mingde (Matthew) Zeng;; Copyright (C) 2019 Mingde (Matthew) Zeng;; Created: Fri Mar 15 11:09:30 2019 (-0400);; Version: 3.0;; URL: https://github.com/MatthewZMD/.emacs.d;; Keywords: M-EMACS .emacs.d org toc-org htmlize ox-gfm;; Compatibility: emacs-version >= 26.1;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Commentary:;;;; This initializes org toc-org htmlize ox-gfm;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; This program is free software: you can redistribute it and/or modify;; it under the terms of the GNU General Public License as published by;; the Free Software Foundation, either version 3 of the License, or (at;; your option) any later version.;;;; This program is distributed in the hope that it will be useful, but;; WITHOUT ANY WARRANTY; without even the implied warranty of;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU;; General Public License for more details.;;;; You should have received a copy of the GNU General Public License;; along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Code:;; OrgPac(use-package org  :ensure nil  :defer t  :bind (("C-c l" . org-store-link)         ("C-c a" . org-agenda)         ("C-c c" . org-capture)         (:map org-mode-map (("C-c C-p" . eaf-org-export-to-pdf-and-open)                             ("C-c ;" . nil))))  :custom  (org-log-done 'time)  (org-log-done 'note)  (calendar-latitude 43.65107) ;; Prerequisite: set it to your location, currently default: Toronto, Canada  (calendar-longitude -79.347015) ;; Usable for M-x `sunrise-sunset' or in `org-agenda'  (org-export-backends (quote (ascii html icalendar latex md odt)))  (org-use-speed-commands t)  (org-confirm-babel-evaluate 'nil)  (org-latex-listings-options '(("breaklines" "true")))  (org-latex-listings t)  (org-deadline-warning-days 7)  (org-todo-keywords  '((sequence "TODO(t!@)" "DOING(i)" "HANGUP(h)" "|" "DONE(d!@)" "CANCEL(c!@)")    (sequence "⚑(T)" "🏴(I)" "❓(H)" "|" "✔(D)" "✘(C)")))  (org-agenda-window-setup 'other-window)  (org-latex-pdf-process   '("pdflatex -shelnl-escape -interaction nonstopmode -output-directory %o %f"     "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))  (org-agenda-current-time ((t (:foregroUnd "Spring green"))))  (org-todo-keyword-faces '(("HANGUP" . warning)                           ("❓" . warning)))  (org-priority-faces '((?A . error)                       (?B . warning)                       (?C . success)))  :config  (setq org-startup-indented t)  (setq org-enforce-todo-dependencies t)    ;; Add graphical view of agenda  (use-package org-timeline    :hook (org-agenda-finalize . org-timeline-insert-timeline))  (add-to-list 'org-latex-packages-alist '("" "listings"))  (unless (version< org-version "9.2")    (require 'org-tempo))  (when (file-directory-p "y:/org/agenda/")    (setq org-agenda-files (list "y:/org/agenda/"))    (setq org-directory (expand-file-name "y:/org/agenda")))    (setq org-modules nil                 ; Faster loading        org-capture-templates        `(("i" "Idea" entry (file ,(concat org-directory "/idea.org"))           "*  %^{Title} %?\n%U\n%a\n")          ("t" "Todo" entry (file ,(concat org-directory "/gtd.org"))           "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)          ("n" "Note" entry (file ,(concat org-directory "/note.org"))           "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)          ("j" "Journal" entry (file+olp+datetree ; head format                                ,(concat org-directory "/journal.org"))           "*  %^{Title} %?\n%U\n%a\n" :clock-in t :clock-resume t))        ;; Agenda styling        org-log-done 'time        org-catch-invisible-edits 'smart        org-pretty-entities nil        org-hide-emphasis-markers t)    (org-babel-do-load-languages     'org-babel-load-languages     '(;; other Babel languages       (C . t)       (python . t)       (plantuml . t)))    (defun org-export-toggle-syntax-highlight ()      "Setup variables to turn on syntax highlighting when calling `org-latex-export-to-pdf'."      (interactive)      (setq-local org-latex-listings 'minted)      (add-to-list 'org-latex-packages-alist '("newfloat" "minted")))    (defun org-table-insert-vertical-hline ()      "Insert a #+attr_latex to the current buffer, default the align to |c|c|c|, adjust if necessary."      (interactive)      (insert "#+attr_latex: :align |c|c|c|"))    );; -OrgPac;; Prettify UI;; version< is a function used to check if 27<emacs-version, return t if true(if (version< "27" emacs-version )(use-package org-modern  :hook ((org-mode . org-modern-mode)         (org-agenda-finalize . org-modern-agenda)         (org-modern-mode . (lambda ()                              "Adapt `org-modern-mode'."                              ;; Disable Prettify Symbols mode                              (setq prettify-symbols-alist nil)                              (prettify-symbols-mode -1))))));; OrgRoamPac(use-package org-roam  :after org  :custom  (org-roam-node-display-template   (concat "${title:*} "           (propertize "${tags:10}" 'face 'org-tag)))  (org-roam-completion-everywhere t)  :bind  (("C-c n l" . org-roam-buffer-toggle)   ("C-c n f" . org-roam-node-find)   ("C-c n i" . org-roam-node-insert)   ("C-c n h" . org-id-get-create))  :config  (when (file-directory-p "~/org/roam/")    (setq org-roam-directory (file-truename "~/org/roam")))  (org-roam-db-autosync-mode));; -OrgRoamPac;; TocOrgPac(use-package toc-org  :hook (org-mode . toc-org-mode)        (markdown-mode . toc-org-mode));; -TocOrgPac;; HTMLIZEPac(use-package htmlize :defer t);; -HTMLIZEPac;; OXGFMPac(use-package ox-gfm :defer t);; -OXGFMPac;; PlantUMLPac(use-package plantuml-mode  :defer t  :custom  (org-plantuml-jar-path (expand-file-name "~/tools/plantuml/plantuml.jar")));; -PlantUMLPac(provide 'init-org);;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; init-org.el ends here