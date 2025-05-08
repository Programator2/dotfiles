;;; init.el --- Personal EMACS config by Roderik Ploszek -*- lexical-binding: t; -*-

;; Copyright (C) 2018-2025 Roderik Ploszek

;; Author: Roderik Ploszek <roderik.ploszek@gmail.com>

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Items labelled 'modern-feature' are considered standard features in modern
;; programming text editors, but emacs doesn't use them by default. Use `M-s o'
;; to find them.

;;; Code:

;; garbage collection activates above 384 MB or when 60 % of the heap has been
;; allocated (thanks spacemacs project)
(setq gc-cons-threshold 402653184 gc-cons-percentage 0.6)

;; Init parts inspired by https://github.com/mrvdb/emacs-config/blob/master/mrb.org

;; Need to load
(if (version< emacs-version "27")
    (package-initialize))
;; MELPA
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives (cons "melpa" "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/"))
(unless package--initialized (package-initialize))

;;; Setup use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)
(setq use-package-always-defer t)
(setq use-package-compute-statistics t)
;; this allows introspection of hooks, you have to use the full name
(setq use-package-hook-name-suffix nil)

;; (use-package benchmark-init
;;   :ensure t
;;   :init
;;   (benchmark-init/activate)
;;   :config
;;   ;; To disable collection of benchmark data after init is done.
;;   (add-hook 'after-init-hook 'benchmark-init/deactivate))

;; (eval-and-compile
  ;; (setq use-package-always-ensure nil)  ; ESSENTIAL for `straight.el'
  ;; (setq use-package-always-defer nil)
  ;; (setq use-package-always-demand nil)
  ;; (setq use-package-expand-minimally nil)
  ;; (setq use-package-enable-imenu-support t)
  ;; (setq use-package-compute-statistics nil)
  ;; The following is VERY IMPORTANT.  Write hooks using their real name
  ;; instead of a shorter version: after-init ==> `after-init-hook'.
  ;;
  ;; This is to empower help commands with their contextual awareness,
  ;; such as `describe-symbol'.
  ;; (setq use-package-hook-name-suffix nil))


;; (use-package use-package
  ;; :init
  ;; (setq use-package-always-ensure nil)	; Try installing automatically
  ;; (setq use-package-verbose nil)		; Set to true when interested in load times
  ;; If running as daemon, there's no reason to defer,just load shite
  ;; to minimize chance of lockup, but it still happens sometimes.
  ;; (if (daemonp)
  ;;     (setq use-package-always-demand t))

;; (use-package use-package-ensure-system-package :ensure t))	; Need this because we are in use-package config

;; Location where I keep custom packages
;; (setq custom-package-directory (concat user-emacs-directory "lisp/"))

(pcase system-type
  ('windows-nt
  ;; Windows nomenclature
   (setq rod-userprofile-directory
	 (cond ((string= (system-name) "IdeaPad-5-Pro") "c:/Users/Progr/")
	       (t "c:/Users/Roderik/"))))
  ('gnu/linux
   (setq rod-userprofile-directory "~/")))

;; Emacs source
(pcase system-type
  ('windows-nt
   (setq source-directory
	 (concat rod-userprofile-directory
		 "Documents/Sources/C/emacs/")))
  ('gnu/linux
   (setq source-directory "/mnt/win/Users/Roderik/Documents/Sources/C/emacs/")))

;; https://github.com/jschaf/esup/issues/85#issuecomment-1130110196
;; Work around a bug where esup tries to step into the byte-compiled
;; version of `cl-lib', and fails horribly.
(setq esup-depth 0)

;; (setq esup-child-profile-require-level 0)

(defun rod-get-documents-dir ()
  "Return directory where user files are stored. It's the Documents
folder for Windows and ~ for GNU/Linux and other systems."
  (cond ((eq system-type 'windows-nt) (concat rod-userprofile-directory
					      "Documents/"))
        ((eq system-type 'gnu/linux) "~/")
	(t "~/")))

(defun rod-concat-documents-dir (path)
  "Return path to the requested PATH inside system's document
folder."
  (concat (rod-get-documents-dir) path))

(defun rod-concat-userprofile-dir (path)
  "Return path to the requested PATH inside system's userprofile
folder."
  (file-name-concat rod-userprofile-directory path))

(load-file (concat user-emacs-directory "init-private.el"))
;;; org-mode

;; taken from doom, lazy loading for org-protocol
;; (defun +org-init-protocol-lazy-loader-h ()
;;   "Brings lazy-loaded support for org-protocol, so external programs (like
;; browsers) can invoke specialized behavior from Emacs. Normally you'd simply
;; require `org-protocol' and use it, but the package loads all of org for no
;; compelling reason, so..."
;;   (defadvice +org--server-visit-files-a (args)
;;     "Advise `server-visit-flist' to invoke `org-protocol' lazily."
;;     :filter-args #'server-visit-files
;;     (cl-destructuring-bind (files proc &optional nowait) args
;;       (catch 'greedy
;;         (let ((flist (reverse files)))
;;           (dolist (var flist)
;;             (when (string-match-p ":/+" (car var))
;;               (require 'server)
;;               (require 'org-protocol)
;;               ;; `\' to `/' on windows
;;               (let ((fname (org-protocol-check-filename-for-protocol
;;                             (expand-file-name (car var))
;;                             (member var flist)
;;                             proc)))
;;                 (cond ((eq fname t) ; greedy? We need the t return value.
;;                        (setq files nil)
;;                        (throw 'greedy t))
;;                       ((stringp fname) ; probably filename
;;                        (setcar var fname))
;;                       ((setq files (delq var files)))))))))
;;       (list files proc nowait)))

;;   ;; Disable built-in, clumsy advice
;;   (after! org-protocol
;;     (ad-disable-advice 'server-visit-files 'before 'org-protocol-detect-protocol-server)))

;; add site-lisp for local and personal packages
(add-to-list 'load-path (concat user-emacs-directory "site-lisp"))

(use-package diminish)

(use-package org
  :ensure org-contrib
  :commands org-clock-in
  ;; :preface
  ;; (add-hook 'org-load-hook
  ;; #'+org-init-protocol-lazy-loader-h)
  :config
  ;; Load these packages automatically with org
  (add-to-list 'org-modules 'org-protocol)
  (add-to-list 'org-modules 'org-mouse)
  (add-to-list 'org-modules 'org-panel)
  (add-to-list 'org-modules 'org-id)
  (add-to-list 'org-modules 'org-expiry)
  (add-to-list 'org-modules 'ol-man)
  ;; XXX: Crazy bug from 2023-03: sometime in between versions 9.5.5 and 9.6.1,
  ;; function `org-insert-heading' introduced an errorneous behavior when
  ;; inserting heading at the end of a file. It probably also introduced other
  ;; problems that are happening when inside my large org file, but I haven't
  ;; been able to identify them exactly. I located the error to commit
  ;; 8e2fed82e. Specifically it happens on
  ;; [[file:c:/Users/Roderik/Documents/Sources/elisp/org-mode/lisp/org.el::((org-fold-folded-p][this]]
  ;; line. Thankfully, it is executed conditionally based on value of
  ;; `org-fold-core-style'. That's why the value is changed here.
  ;; TODO: File a bug report.
  (setq org-directory (rod-concat-documents-dir "System"))
  (setq org-refile-targets
   `((nil :maxlevel . 4)
     (,(rod-concat-documents-dir "System/knowledgebase.org") :maxlevel . 3)
     (org-agenda-files :maxlevel . 1)))
  (setq org-fold-core-style 'overlays)
  ;;gg (tags "CLOSED>=\"<today>\""
  ;; Make windmove work in Org mode:
  (add-hook 'org-shiftup-final-hook 'windmove-up)
  (add-hook 'org-shiftleft-final-hook 'windmove-left)
  (add-hook 'org-shiftdown-final-hook 'windmove-down)
  (add-hook 'org-shiftright-final-hook 'windmove-right)
  (setq org-default-notes-file (rod-concat-documents-dir
				"System/notes.org"))
  (setq org-capture-templates
	`(("t" "Todo" entry (file+headline
			     ,(rod-concat-documents-dir
			       "System/gtd.org")
			     "Inbox")
	   "* TODO %?\nCreated: %U\n%i\n%a")
	  ;; ("i" "Inbox" entry (file+headline "c:/Users/Roderik/Documents/System/notes.org" "Incoming")
	  ;; "* TODO %?\n  %i\n  %a\n  Created: %U")
	  ("j" "Journal" entry (file+olp+datetree "~/org/journal.org")
	   "* %?\nEntered on %U\n%i\n%a")
	  ("k" "Knowledgebase" entry (file ,(rod-concat-documents-dir
					     "System/knowledgebase.org"))
	   "* %?\n%U \n\n%i")
	  ("c" "Calendar task" entry (file+olp+datetree
				      ,(rod-concat-documents-dir
					"System/gtd.org")
				      "Calendar")
	   "* %?\n%T\nCreated: %U")))
  (setq org-refile-use-outline-path t
	org-outline-path-complete-in-steps nil)
  ;; ENTER jumps to a link
  (setq org-return-follows-link t)
  (setq org-todo-keywords
	'(
	  (sequence "TODO(t!)" "NEXT(n!)" "WAITING(w!)" "INPROGRESS(p!)" "|" "DONE(d)" "CANCELED(c)" "REOPEN(r)")
	  (type "INBOX(i!)")))
  (setq org-log-done 'time)
  (setq org-agenda-include-diary t)
  (setq org-latex-packages-alist '(("" "lmodern" nil)
				   ;; ("newfloat" "minted" nil)
				   ))
  ;; (setq org-latex-listings 'minted)
  ;; org-mode search
  (setq org-agenda-text-search-extra-files
	(directory-files-recursively (rod-concat-documents-dir "System/")
				     "org$"))
  ;; org-ol for summaries
  (defun my/get-stats-tasks (todo-tag from &optional tag to files category)
    "Get stats for tasks of last week with TODO-TAG TAG FROM optionally define TO date and source FILES to use."
    (let ((tasks
           (org-ql-query
             :from (or files (org-agenda-files))
             :where
             `(and (todo ,todo-tag)
                   (if ,tag (tags ,tag) t)
                   (if ,category (category ,category) t)
                   (ts :from ,from :to ,(or to 'today))))))
      `((tasks . ,(length tasks))
	(tasks-per-day . ,(/ (length tasks) (abs from))))))
  ;; changed in version 9.4 (fall 2020) after this mail in the mailing list:
  ;; https://lists.gnu.org/r/emacs-orgmode/2020-04/msg00452.html
  (setq org-startup-folded t)
  ;; This created some strange problems when "file was not in org mode"
  ;; (setq-default org-journal-enable-agenda-integration t)

  (setq org-journal-enable-cache t)
  ;; speed up:
  (setq org-journal-carryover-items "")

  ;; org clocking time
  (setq org-clock-mode-line-total 'current)
  (setq org-clock-history-length 20)
  ;; save the clock history across Emacs sessions
  (setq org-clock-persist 'history)
  (org-clock-persistence-insinuate)

  ;; for python blocks in org
  (setq-default org-src-preserve-indentation t)

  ;; org-babel lazy load
  (defvar +org-babel-mode-alist
    '((cpp . C)
      (C++ . C)
      (D . C)
      (sh . shell)
      (bash . shell)
      (matlab . octave)
      (amm . ammonite))
    "An alist mapping languages to babel libraries. This is necessary for babel
libraries (ob-*.el) that don't match the name of the language.
For example, with (fish . shell) will cause #+BEGIN_SRC fish to load ob-shell.el
when executed.")

  (defvar +org-babel-load-functions ()
    "A list of functions executed to load the current executing src block. They
take one argument (the language specified in the src block, as a string). Stops
at the first function to return non-nil.")

  (defun +org--babel-lazy-load (lang)
    (cl-check-type lang symbol)
    (or (run-hook-with-args-until-success '+org-babel-load-functions lang)
	(require (intern (format "ob-%s" lang)) nil t)
	(require lang nil t)))

  (defun +org--src-lazy-load-library-a (lang)
    "Lazy load a babel package to ensure syntax highlighting."
    (or (cdr (assoc lang org-src-lang-modes))
	(+org--babel-lazy-load lang)))
  (advice-add #'org-src--get-lang-mode :before #'+org--src-lazy-load-library-a)

  (defun +org--babel-lazy-load-library-a (info)
    "Load babel libraries lazily when babel blocks are executed."
    (let* ((lang (nth 0 info))
           (lang (cond ((symbolp lang) lang)
                       ((stringp lang) (intern lang))))
           (lang (or (cdr (assq lang +org-babel-mode-alist))
                     lang)))
      (when (and lang
		 (not (cdr (assq lang org-babel-load-languages)))
		 (+org--babel-lazy-load lang))
	(when (assq :async (nth 2 info))
          ;; ob-async has its own agenda for lazy loading packages (in the
          ;; child process), so we only need to make sure it's loaded.
          (require 'ob-async nil t))
	(add-to-list 'org-babel-load-languages (cons lang t)))
      t))
  (advice-add #'org-babel-confirm-evaluate :after-while #'+org--babel-lazy-load-library-a)
  ;; (org-babel-do-load-languages
  ;; 'org-babel-load-languages
  ;; '((perl . t)
  ;; (python . t)
  ;; (emacs-lisp . t)))

  (setq org-tags-exclude-from-inheritance (quote ("crypt")))

  ;; from http://yitang.uk/2022/07/05/move-between-window-using-builtin-package/
  (define-key org-read-date-minibuffer-local-map (kbd "<left>")
    (lambda ()
      (interactive)
      (org-eval-in-calendar
       '(calendar-backward-day 1))))
  (define-key org-read-date-minibuffer-local-map (kbd "<right>")
    (lambda ()
      (interactive)
      (org-eval-in-calendar
       '(calendar-forward-day 1))))
  (define-key org-read-date-minibuffer-local-map (kbd "<up>")
    (lambda ()
      (interactive)
      (org-eval-in-calendar
       '(calendar-backward-week 1))))
  (define-key org-read-date-minibuffer-local-map (kbd "<down>")
    (lambda ()
      (interactive)
      (org-eval-in-calendar
       '(calendar-forward-week 1))))

  ;; :init
  ;; (setq org-mru-clock-how-many 100
  ;; org-mru-clock-completing-read #'ivy-completing-read))
  ;; org global keybindings
  :bind (("C-c l" . org-store-link)
	 ("C-c a" . org-agenda)
	 ("C-c c" . org-capture)
	 ("C-c b" . org-switchb)
	 :map org-mode-map
	 ;; ("C-y" . rod-yank-with-indent)
	 ))

(defun rod-org-end-of-subtree ()
  "Goto to the end of a subtree."
  (interactive)
  (org-end-of-subtree))

(use-package engrave-faces)

(use-package org-web-tools)

;; org-remark
(use-package org-remark
  :diminish org-remark-global-tracking-mode
  :bind (:map org-remark-mode-map
	      ("C-c n o" . org-remark-open)
	      ("C-c n ]" . org-remark-view-next)
	      ("C-c n [" . org-remark-view-prev)
	      ("C-c n r" . org-remark-view-remove)))
(require 'org-remark-global-tracking)
(org-remark-global-tracking-mode +1)
(defun rod-org-remark-mark-and-open ()
  "Mark current region and open marginalia buffer for it."
  (interactive)
  (let ((region-was-active (use-region-p)))
    (call-interactively 'org-remark-mark)
    (save-excursion
      (if region-was-active (backward-char))
      (call-interactively 'org-remark-open))))
;; (diminish 'org-remark-global-tracking-mode "ormk")
(diminish 'org-remark-global-tracking-mode)

;;; functions for org agenda filtering

;; source: https://stackoverflow.com/questions/10074016/org-mode-filter-on-tag-in-agenda-view
(defun zin/org-agenda-skip-tag (tag &optional others)
  "Skip all entries that correspond to TAG.

If OTHERS is true, skip all entries that do not correspond to TAG."
  (let ((next-headline (save-excursion (or (outline-next-heading) (point-max))))
        (current-headline (or (and (org-at-heading-p)
                                   (point))
                              (save-excursion (org-back-to-heading)))))
    (if others
        (if (not (member tag (org-get-tags-at current-headline)))
            next-headline
          nil)
      (if (member tag (org-get-tags-at current-headline))
          next-headline
        nil))))

;; If you want to load these packages along with org-mode, you should add them
;; to org-modules list.
(use-package org-protocol
  :ensure nil)
(use-package org-mouse
  :ensure nil)
(use-package org-panel
  :ensure nil)
(use-package org-id
  :ensure nil)

(use-package calfw)
(use-package calfw-org :commands cfw:open-org-calendar)

(defun rod-set-calendar-location-to-bratislava ()
  "Set `calendar-location-name', `calendar-latitude' and
`calendar-longitude' to Bratislava."
  (interactive)
  (setq calendar-location-name "Bratislava"
        calendar-latitude 48.16
        calendar-longitude 17.06))

(defun rod-set-calendar-location-to-banska-bystrica ()
  "Set `calendar-location-name', `calendar-latitude' and
`calendar-longitude' to Banská Bystrica."
  (interactive)
  (setq calendar-location-name "Banská Bystrica"
	calendar-latitude 48.76
        calendar-longitude 19.17))

(use-package solar
  :ensure nil
  :config
  (rod-set-calendar-location-to-banska-bystrica)
  (if t
      (rod-set-calendar-location-to-bratislava)))

;; org-crypt
(use-package org-crypt
  :ensure nil
  :config
  (org-crypt-use-before-save-magic))
(use-package epa-file
  :ensure nil
  :config
  (epa-file-enable))
;; (setq auth-source-debug t)
(use-package rodlib-org
  :ensure nil
  :commands (rod-org-list-tags))
;; correct org links to pdf
(use-package org-pdftools
  :hook (org-mode-hook . org-pdftools-setup-link))
;; org export to markdown
;; disabled (1.03 s startup)
(use-package ox-md
  :ensure nil)
;; (require 'ox-md)
;; org export to beamer
(use-package ox-beamer
  :ensure nil)
;; (require 'ox-beamer)
;; export asynchronously in the background
;; bad thing about this is that it executes a new instance of emacs,
;; which makes it slower
;;
;; But good thing is that you can create a special init file that runs in this
;; instance. TODO
;;
;; (setq-default org-export-in-background nil)

(use-package org-journal
  :config
  ;; Dont want these hooks, everything is slowed down because of stupid
  ;; file-truename calls. Without them calendar opens faster.
  ;; You can still view the entries using the 'm' key.
  (remove-hook 'calendar-today-visible-hook 'org-journal-mark-entries)
  (remove-hook 'calendar-today-invisible-hook 'org-journal-mark-entries)
  :bind (("C-c j" . org-journal-new-entry)))
(use-package org-present
  :hook ((org-present-mode-hook . (lambda ()
				    (org-present-big)
				    (org-display-inline-images)))
	 (org-present-mode-quit-hook . (lambda ()
					 (org-present-small)
					 (org-remove-inline-images)))))
(use-package org-mru-clock
  :commands (org-mru-clock-in)
  :bind* (("C-c C-x C-x" . org-mru-clock-in)
          ("C-c C-x C-j" . org-mru-clock-select-recent-task)))


;;; ORG-MODE:  * My Task
;;;              SCHEDULED: <%%(rod-diary-last-day-of-month date)>
;;; DIARY:  %%(rod-diary-last-day-of-month date) Last Day of the Month
;;; See also:  (setq org-agenda-include-diary t)
;;; (rod-diary-last-day-of-month '(2 28 2017))
(defun rod-diary-last-day-of-month (date)
  "Return `t` if DATE is the last day of the month."
  (let* ((day (calendar-extract-day date))
         (month (calendar-extract-month date))
         (year (calendar-extract-year date))
         (last-day-of-month
          (calendar-last-day-of-month month year)))
    (= day last-day-of-month)))

(use-package org-trello
  :init
  (setq org-trello-current-prefix-keybinding "C-c o")
  (defun orgtrello-api-get-full-cards-from-page (board-id &optional before-id)
    "Create a paginated retrieval of 25 cards before BEFORE-ID from BOARD-ID."
    (orgtrello-api-make-query
     "GET"
     (format "/boards/%s/cards" board-id)
     `(("actions" .  "commentCard")
       ("checklists" . "all")
       ("limit" . "250")
       ("before" . ,(or before-id ""))
       ("filter" . "open")
       ("fields" .
	"closed,desc,due,idBoard,idList,idMembers,labels,name,pos"))))

  (defun orgtrello-controller--retrieve-full-cards (data &optional before-id)
    "Retrieve the full cards from DATA, optionally paginated from before-ID.
DATA is a list of (archive-cards board-id &rest buffer-name point-start).
Return the cons of the full cards and the initial list."
    (-let* (((archive-cards board-id &rest) data)
            (cards
             (-> board-id
		 (orgtrello-api-get-full-cards-from-page before-id)
		 (orgtrello-query-http-trello 'sync)))
            (more-cards
             (when cards
               (let ((before-id (car (sort (mapcar 'orgtrello-data-entity-id cards) 'string<))))
		 (car (orgtrello-controller--retrieve-full-cards data before-id))))))
      (cons (append more-cards cards) data))))

(use-package org-ref
  :defer t
  :commands (org-ref-bibtex-next-entry
             org-ref-bibtex-previous-entry
             org-ref-insert-link
             org-ref-open-in-browser
             org-ref-open-bibtex-notes
             org-ref-open-bibtex-pdf
             org-ref-bibtex-hydra/body
             org-ref-bibtex-hydra/org-ref-bibtex-new-entry/body-and-exit
             org-ref-sort-bibtex-entry
             arxiv-add-bibtex-entry
             arxiv-get-pdf-add-bibtex-entry
             doi-utils-add-bibtex-entry-from-doi
             isbn-to-bibtex
             pubmed-insert-bibtex-from-pmid)
  :init
  (progn
    (add-hook 'org-mode-hook (lambda () (require 'org-ref)))
    ;; Many of these variables are deprecated in version 3 (2021-11)
    (setq org-ref-completion-library 'org-ref-helm-bibtex))

  :bind (:map org-mode-map
	      ("C-c ]" . org-ref-insert-link)))

;; Weird behavior of org-ref (2022-07-15): When you press RET on a citation and
;; select `o' to go to the bibtex entry, it doesn't work. You have to actually
;; eval-defun the definition of `org-ref-open-citation-at-point' function and
;; only after that it starts to work.

(defun rod-org-ref-open-pdf-at-point ()
  "Open the pdf for bibtex key under point if it exists.

And if it doesn't exist, prompt for a path and hard-link it into
the first directory in `bibtex-completion-library-path'."
  (interactive)
  (let* ((bibtex-completion-bibliography (org-ref-find-bibliography))
	 (results (org-ref-get-bibtex-key-and-file))
         (key (car results))
         (pdf-file (bibtex-completion-find-pdf key t)))
    (pcase (length pdf-file)
      (0
       (let* ((old-pdf-path (read-file-name "Enter path to pdf: "))
	      (directory (car bibtex-completion-library-path))
	      (extension (car (-flatten bibtex-completion-pdf-extension)))
	      (new-pdf-path (f-join directory (concat key extension))))
	 (add-name-to-file old-pdf-path new-pdf-path)
	 (funcall bibtex-completion-pdf-open-function new-pdf-path)
	 ))
      (1
       (funcall bibtex-completion-pdf-open-function (car pdf-file)))
      (_
       (funcall bibtex-completion-pdf-open-function
		(completing-read "pdf: " pdf-file))))))

;; search titles in org mode
(defun rod-org-search-title (regexp)
  "Make a compact tree showing titles matching REGEXP."
  (interactive "sRegexp: \nP")
  (when (equal regexp "")
    (user-error "Regexp cannot be empty"))
  (occur (concat "\*+ " regexp)))
(defalias 'rod-org-occur-title 'rod-org-search-title)

(use-package alert
  :commands (alert-define-style))

(message "alert is defined: %s" (fboundp 'alert-define-style))

(pcase system-type
  ('windows-nt
   ;; custom alert style for Windows
   (defcustom alert-w32-notification-priorities
     '((urgent   . error)
       (high     . warning)
       (moderate . warning)
       (normal   . info)
       (low      . info)
       (trivial  . info))
     "A mapping of alert severities onto w32-notification priority values."
     :type '(alist :key-type symbol :value-type symbol)
     :group 'alert)

   (defun alert-w32-notification-notify (info)
     "Show the alert defined by INFO with `w32-notification-notify'."
     (let ((id (w32-notification-notify :title (plist-get info :title)
					:body  (plist-get info :message)
					:icon (plist-get info :icon)
					:level (cdr (assq (plist-get info :severity)
							  alert-w32-notification-priorities)))))
       (run-with-timer 8 nil #'w32-notification-close id))
     ;; (when id
     ;; (puthash id id alert-notifications-ids)))
     (alert-message-notify info))

   (defun alert-w32-notification-remove (info)
     "Remove the `w32-notification-notify' message based on INFO :id."
     (message "Removing")
     (let ((id (and (plist-get info :id)
		    (gethash (plist-get info :id) alert-notifications-ids))))
       (when id
	 (w32-notification-close id)
	 (remhash (plist-get info :id) alert-notifications-ids))))

   (alert-define-style 'w32-notification :title "Notify using w32-notification"
		       :notifier #'alert-w32-notification-notify)
   ;; :remover #'alert-w32-notification-remove)

   (setq alert-default-style 'w32-notification))
  ('gnu/linux
   (setq alert-default-style 'notifications)))

;; org latex export to koma script
(with-eval-after-load "ox-latex"
  (add-to-list 'org-latex-classes
               '("koma-article" "\\documentclass{scrartcl}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))

;; diary
 (add-hook 'diary-list-entries-hook 'diary-sort-entries t)

;; org-present
(tool-bar-mode 0)
;; (tooltip-mode -1)
(menu-bar-mode 0)
(blink-cursor-mode 0)

;; org-pomodoro
(use-package org-pomodoro)
(setq-default org-pomodoro-audio-player nil)

(use-package org-tidy
  :ensure t
  :hook
  (org-mode . org-tidy-mode))

;; org-roam
(use-package org-roam
  :custom
  (org-roam-directory (rod-concat-documents-dir "System"))
  ;; Nizsie pouzivam oblast osobnych klaves. Netreba to zmenit?
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol)
  :custom
  (org-roam-capture-templates
   `(("r" "reference to a website" entry
      ""
      :target
      (file+head ,(rod-concat-documents-dir
		   "System/knowledgebase.org")
		 "Notes on websites")))))

(use-package org-roam-timestamps
  :diminish org-roam-timestamps-mode)

(use-package deft
  :after org
  :bind
  ("C-c n d" . deft)
  :custom
  (deft-recursive t)
  (deft-use-filter-string-for-filename t)
  (deft-default-extension "org")
  (deft-directory org-roam-directory))

;; helm-org-rifle
(use-package helm-org-rifle
  :bind
  ("<f2> a" . helm-org-rifle-agenda-files)
  ("<f2> c" . helm-org-rifle-current-buffer))

(use-package helm-org
  :bind
  ("<f2> g" . helm-org-agenda-files-headings)
  ("<f2> h" . helm-org-in-buffer-headings))

(use-package org-modern
  :config
  (setq org-hide-emphasis-markers t
	org-pretty-entities t)
  )

(use-package valign)

(defun rod-goto-calendar ()
  "Go to the calendar heading of my GTD system."
  (interactive)
  (org-id-goto "a71c5010-9534-465f-948b-ad592c7fdd99"))

;;; end org-mode

(when (eq system-type 'windows-nt)
  (setq epg-gpg-home-directory (concat rod-userprofile-directory
				       "AppData/Roaming/gnupg")
        eww-download-directory (concat rod-userprofile-directory
				       "Downloads")
	flycheck-html-tidy-executable "C:\\Program Files\\tidy 5.8.0\\bin\\tidy.exe"
	lsp-fsharp-server-install-dir  (rod-concat-userprofile-dir
					".dotnet/tools/")
	python-shell-interpreter "c:/python312/python.exe"
	woman-manpath
	`("C:/tools/cygwin/usr/man"
	  "C:/tools/cygwin/usr/share/man"
	  "C:/tools/cygwin/usr/local/share/man"
	  ("/bin" . "/usr/share/man")
	  ("/usr/bin" . "/usr/share/man")
	  ("/sbin" . "/usr/share/man")
	  ("/usr/sbin" . "/usr/share/man")
	  ("/usr/local/bin" . "/usr/local/man")
	  ("/usr/local/bin" . "/usr/local/share/man")
	  ("/usr/local/sbin" . "/usr/local/man")
	  ("/usr/local/sbin" . "/usr/local/share/man")
	  ("/usr/X11R6/bin" . "/usr/X11R6/man")
	  ("/usr/bin/X11" . "/usr/X11R6/man")
	  ("/usr/games" . "/usr/share/man")
	  ("/opt/bin" . "/opt/man")
	  ("/opt/sbin" . "/opt/man")
	  ,(rod-concat-documents-dir "Documents/Sources/linux/man-pages")
	  "f:/usr/share/man")

))

;;; markdown
(use-package gh-md)
(use-package markdown-mode
  :config
  ;; From spacemacs:
  ;; Make markdown-mode behave a bit more like org w.r.t. code blocks i.e.
  ;; use proper syntax highlighting
  (setq markdown-fontify-code-blocks-natively t))
(use-package vmd-mode)

;;; html
;;
(use-package sgml-mode
  :hook
  ((html-mode-hook . sgml-electric-tag-pair-mode) ; automatically edit both tags
   ;; (html-mode-hook . sgml-name-8bit-mode)	  ; use html entities
   (sgml-mode-hook . (lambda nil (setq-default skeleton-end-newline nil)))))
;; when inserting new tag using sgml-tag, don't insert new line or reindent the
;; code
(add-hook 'sgml-mode-hook (lambda nil (setq-default skeleton-end-newline nil)))
(defalias 'rod-html-convert-to-entity 'sgml-namify-char)

;;; simple.el and general configuration

;; one space after a full stop
(setq-default sentence-end-double-space nil)

;; recentf-mode
(use-package recentf
  :config
  (setq-default recentf-max-saved-items 1000)
  (recentf-mode 1))

;; show parantheses (modern-feature)
(show-paren-mode 1)

;; view line number in mode line
(line-number-mode 1)

;; set to +1 to highlight the current line
(global-hl-line-mode 1)

;; Allows to replace a selection (modern-feature)
(delete-selection-mode 1)

;; Show a context menu on right click (Emacs 28 required) (modern-feature)
(context-menu-mode 1)

;; line numbers in programming modes
;; WARNING: don't use linum-mode! It slows down scrolling!
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
;; hs-minor-mode for code folding (modern-feature)
(add-hook 'prog-mode-hook 'hs-minor-mode)
;; auto-revert in programming modes
(add-hook 'prog-mode-hook 'auto-revert-mode)

;; hide scroll bar
(scroll-bar-mode -1)

;; return mark to the previous position if scrolled to the end
(setq scroll-error-top-bottom t)

;; faster scrolling
(setq auto-window-vscroll nil)

;; Useless whitespace
;; Automatically highlight trailing whitespace
(add-hook 'prog-mode-hook
	  (function (lambda () (setq show-trailing-whitespace t))))
(add-hook 'latex-mode-hook
	  (function (lambda () (setq show-trailing-whitespace t))))

;; Show trailing empty lines
(setq-default indicate-empty-lines t)

;; Specialne nastavenie na cvika pre PPDS
;; (setq-default frame-title-format "PPDS 10. cvičenie")
;; (setq-default eshell-prompt-function
;; 	      (lambda nil "$ "))

;;; variables for eshell (without namespace)
(setq dataset (rod-concat-documents-dir "FEI/dissertation/dataset"))

;; Display time in the modeline, in 24-hour format
(setq-default display-time-24hr-format t)
(display-time-mode 1)

;;; eshell
(use-package eshell
  :ensure nil
  :config
  (setq
   eshell-cmpl-use-paring nil
   eshell-hist-ignoredups t
   eshell-history-size 512
   ;; eshell-prompt-function
   ;; '(lambda nil
   ;;    #("$ " 0 2
   ;; 	(rear-nonsticky
   ;; 	 (font-lock-face read-only)
   ;; 	 front-sticky
   ;; 	 (font-lock-face read-only)
   ;; 	 font-lock-face eshell-prompt read-only t)))
   ;; eshell-prompt-regexp "^$ "
   )
  (add-hook 'eshell-mode-hook
            (lambda ()
              (define-key eshell-mode-map (kbd "C-c C-r") #'helm-eshell-history))))
  ;; :bind (:map eshell-mode-map
	      ;; ("C-c C-r" . helm-eshell-history)))

;; display of certain characters and control codes to UTF-8
(defun my-term-use-utf8 ()
  (set-buffer-process-coding-system 'utf-8-unix 'utf-8-unix))
(add-hook 'term-exec-hook 'my-term-use-utf8)

;;; helm
(use-package helm
  :diminish helm-mode
  :config (progn
	    ;; December 2022 removed in https://github.com/emacs-helm/helm/commit/e81fbbc687705595ab65ae5cd3bdf93c17a90743
	    ;; (require 'helm-config)

	    ;; July 2019 default keybindings for <left> and <right> were changed
	    ;; (https://github.com/emacs-helm/helm/commit/60466004daf894fb390b07f9ff8d4d9283a395ef),
	    ;; this changes them back
	    ;; Guess what ? They changed it back in May 2020
	    ;; (https://github.com/emacs-helm/helm/commit/b8cb661bae0d6649d1e555a4d7c65c08852bff11).
	    ;; But I guess I keep this setting in case they change their mind
	    ;; again
	    (setq helm-ff-lynx-style-map t)
	    (setq helm-completion-style 'emacs)
	    (helm-mode)
	    )
  :bind (
	 ("M-x" . helm-M-x)
	 ;; ("M-x" . execute-extended-command)
	 ;; ("M-x" . counsel-M-x)
	 ;; ("C-x b" . helm-mini)
	 ;; ("C-x b" . switch-to-buffer)
	 ("C-x b" . helm-buffers-list)
	 ;; ("C-x C-b" . helm-mini)
	 ("C-x C-f" . helm-find-files)
	 ("C-x C-r" . helm-recentf)
	 ;; ("C-c g" . helm-grep-do-git-grep)
	 ))

(use-package ivy
  :diminish ivy-mode
  :config
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (setq ivy-height 15)
  :custom
  (ivy-preferred-re-builders '((ivy--regex-ignore-order . "order")
			       (ivy--regex-plus . "ivy")
			       (ivy--regex-fuzzy . "fuzzy"))))

;;;; counsel
(use-package counsel
  :after ivy
  :defer 1
  :diminish counsel-mode
  :bind (
	 ;; ("M-x" . counsel-M-x)
         ;; ("M-y" . counsel-yank-pop)
         ;; ("C-x b" . counsel-ibuffer)
         ;; ("C-c c" . counsel-compile)
         ;; ("C-c F" . counsel-org-file)
         ("C-c g" . counsel-git-grep)
         ("C-c i" . counsel-imenu)
         ;; ("C-c j" . counsel-git-grep) ; M-s g
         ;; ("C-c f" . counsel-file-jump)
         ;; ("C-x l" . counsel-locate)
         ;; ("C-c L" . counsel-git-log)
         ;; ("C-c m" . counsel-linux-app)
         ;; ("C-c n" . counsel-fzf) ; M-s z
         ("C-c o" . counsel-outline)
         ;; ("C-c T" . counsel-load-theme)
         ;; ("C-c z" . counsel-bookmark)
         ;; ("C-x C-r" . counsel-recentf)
         ;; ("C-x C-f" . counsel-find-file)
	 ;; ("<f1> f" . counsel-describe-function)
	 ;; ("<f1> v" . counsel-describe-variable)
	 ;; ("<f1> l" . counsel-load-library)
	 ;; ("<f1> L" . counsel-find-library)
	 ;; ("<f2> i" . counsel-info-lookup-symbol)
	 ;; ("<f2> j" . counsel-set-variable)
	 ("<f2> u" . counsel-unicode-char)
	 ;; ("C-c /" . counsel-ag)
	 ;; ("C-c s" . counsel-rg) ; M-s z
	 ;; ("C-S-o" . counsel-rhythmbox)
	 )
  ;; (:map counsel-find-file-map
  ;; ("RET" . ivy-alt-done))
  ;; (:map minibuffer-local-map
  ;;       ("C-r" . 'counsel-minibuffer-history))
  )

(use-package helm-bibtex)

(use-package helm-lsp
  :after (lsp-mode)
  :commands (helm-lsp-workspace-symbol)
  :init (define-key lsp-mode-map [remap xref-find-apropos] #'helm-lsp-workspace-symbol))

;; helm-everything
;; (add-to-list 'load-path "~/.emacs.d/site-lisp/helm-everything")
;; (require 'helm-everything)
;; (setq everything-cmd "d:/Programs/Everything/es.exe")

;; savehist configuration borrowed from spacemacs with slight adjustments
(use-package savehist
  :init
  (progn
    ;; Minibuffer history
    (setq enable-recursive-minibuffers t ; Allow commands in minibuffers
          history-length 1000
          savehist-additional-variables '(mark-ring
                                          global-mark-ring
                                          search-ring
                                          regexp-search-ring
                                          extended-command-history
                                          kill-ring
					  compile-history
					  compile-command)
	  ;; just guessing something between spacemacs and default value
          savehist-autosave-interval 180)
    (savehist-mode t)))

;; which-key-mode
(use-package which-key
  :diminish which-key-mode
  :config
  (which-key-mode))

(use-package ace-window
  :bind ("M-o" . ace-window))

;; Vim-like o
(defun rod-vim-open-line ()
  "Begin a new line under the current line."
  (interactive)
  (move-end-of-line nil)
  (newline-and-indent))

;; org export inline css
(defun my-org-inline-css-hook (exporter)
  "Insert custom inline css."
  (when (eq exporter 'html)
    (let* ((dir (ignore-errors (file-name-directory (buffer-file-name))))
           (path (concat dir "style.css"))
           (homestyle (or (null dir) (null (file-exists-p path))))
           (final (if homestyle (rod-concat-documents-dir "System/rod-org-export.css") path))) ;; <- set your own style file path
      ;; (setq org-html-head-include-default-style nil)
      (setq org-html-head (concat
			   "<base target=\"_blank\">" ; otvori kazdy odkaz na novom tabe
                           "<style type=\"text/css\">\n"
                           "<!--/*--><![CDATA[/*><!--*/\n"
                           (with-temp-buffer
                             (insert-file-contents final)
                             (buffer-string))
                           "/*]]>*/-->\n"
                           "</style>\n")))))
(add-hook 'org-export-before-processing-hook 'my-org-inline-css-hook)
;; (remove-hook 'org-export-before-processing-hook 'my-org-inline-css-hook)

;;; personal global keybindings

;; Vim-like bindings
;; ffap (gf in Vim, so M-g M-f in Emacs)
;; use my "own" implementation
(global-set-key (kbd "M-g M-f") 'rod-ffap)
(global-set-key (kbd "C-S-o") 'rod-vim-open-line)
(global-set-key (kbd "C-c y") 'copy-line)

;; M-z is normally zap-to-char, which is less useful than zap-up-to-char
(global-set-key "\M-z" 'zap-up-to-char)
;; 2024-05 Something happened in Windows 11 (AMD graphics driver perhaps) and
;; \M-z doesn't work anymore
(global-set-key (kbd "C-c z") 'zap-up-to-char)

;; BETTER KEY bindings
;; -------------------
;; When I press M-; I want to comment the current line, not to add a comment at
;; the end of the line. That functionality (comment-dwim) was moved to C-x C-;.
(global-set-key (kbd "M-;") 'comment-line)
(global-set-key (kbd "C-x C-;") 'comment-dwim)

(global-set-key [f9]
		(lambda () (interactive)
		  (sgml-tag "p")))

;; Various M-x bindings when needed
;; (global-set-key (kbd "M-x") 'execute-extended-command)

;; Key-bind `org-remark-mark' to global-map so that you can call it
;; globally before the library is loaded.
(define-key global-map (kbd "C-c n m") #'rod-org-remark-mark-and-open)

;; User reserved space. Mnemonic s -- shell.
(global-set-key (kbd "C-c s") 'rod-start-pwsh-here)
(global-set-key (kbd "C-c s") 'rod-start-alacritty-here)
;; transpose-frame
(global-set-key (kbd "C-c t") 'transpose-frame)
;; open in explorer shortcut
(global-set-key (kbd "C-c e") 'rod-open-explorer)
;; find-files: because right now I'm using helm and emacs' internal find files
;; has better processing when pasting a path (it ignores what's already in their
;; buffer)
(global-set-key (kbd "C-c f") 'find-file)
;; Originally bound to `kill-buffer', but 99.99% used to kill current buffer.
(global-set-key (kbd "C-x k") 'kill-current-buffer)
(global-set-key [f5] 'evil-mode)
(global-set-key [f6] 'replace-regexp)
;; (global-set-key [f7] 'avy-goto-line)	;changed to M-g f
(global-set-key [f7] 'redraw-display)
(global-set-key [f8] 'neotree-toggle)
(global-set-key [f12] 'swiper)
(global-set-key
 (kbd "C-c 2")
 (lambda () (interactive)
   (find-file
    (rod-concat-documents-dir "System/gtd.org"))))
;; mnemonic: recent clock
(global-set-key (kbd "C-c r")
		(lambda () (interactive)
		  (let ((current-prefix-arg '(4)))
		    (call-interactively 'org-clock-in))))

;; theme & font
(use-package doom-themes
  :init
  (setq doom-oceanic-next-brighter-comments t
	doom-oceanic-next-brighter-modeline t
	doom-oceanic-next-comment-bg nil
	doom-oceanic-next-padded-modeline nil
	doom-themes-padded-modeline nil
	doom-dracula-brighter-comments t
	doom-flatwhite-brighter-modeline t
	doom-nord-brighter-modeline t
	doom-one-light-brighter-comments t
	doom-one-light-brighter-modeline t
	doom-challenger-deep-brighter-modeline t
	doom-dracula-brighter-modeline nil
	doom-dracula-padded-modeline nil
	doom-horizon-brighter-comments t
	doom-horizon-brighter-modeline nil
	doom-horizon-comment-bg nil
	doom-horizon-padded-modeline t)
  ;; (load-theme 'doom-oceanic-next t) ;; alternativa k solarized, perfektne cisla riadkov
  ;; (load-theme 'doom-wilmersdorf t)
  ;; (load-theme 'doom-challenger-deep t) ;; fialove pozadie, syte farby, ale nie je to pouzitelne kvoli farbam v helme
  ;; (load-theme 'doom-henna t)
  ;; (load-theme 'doom-horizon t) ;; pozadie hnede, ale syte farby, komentare kurzivou, cisla riadkov slabo viditelne
  ;; (load-theme 'doom-laserwave t)
  ;; (load-theme 'doom-material-dark t) ;; hnede pozadie. syte farby
  ;; (load-theme 'doom-monokai-machine t)
  ;; (load-theme 'doom-monokai-octagon t) ;; fialove pozadie
  ;; (load-theme 'doom-monokai-spectrum t) ;; hnedosive pozadie, ale syte farby
  ;; (load-theme 'doom-moonlight t) ;; svetlejsie fialove pozadie, slaby kontrast pri lsp definicii fcie
  ;; (load-theme 'doom-palenight t) ;; do fialova, ale nie velmi syte
  ;; (load-theme 'doom-shades-of-purple t) ;; velmi syte, kontrast cisel riadkov slaby
  ;; (load-theme 'doom-snazzy t) ;; sivsie pozadie, syte farby
  ;; (load-theme 'doom-tokyo-night t) ;; tmave sivofialove pozadie, slaba farebnost
  ;; (load-theme 'rebecca t) ;; komentare maju slaby kontrast

  ;; (load-theme 'doom-dracula t)		; komentare bez kurzivy
  ;; (doom-themes-visual-bell-config)
  ;; (doom-themes-org-config)
  )


(use-package all-the-icons
  :if (display-graphic-p))

;; choco install nerd-fonts-ibmplexmono
(use-package nerd-icons)
(use-package nerd-icons-dired)
;; :hook
;; (dired-mode . nerd-icons-dired-mode))

;; v starsej verzii sa nastavoval skript 'symbol, ale min. od verzie 28.1 sa
;; pouziva 'emoji
(when (member "Segoe UI Emoji" (font-family-list))
  (set-fontset-font
   t 'emoji (font-spec :family "Segoe UI Emoji") nil 'prepend))
(defun rod-font-10 ()
  "Set font size to 10."
  (interactive)
  (set-face-attribute 'default nil :height 100))
(defun rod-font-11 ()
  "Set font size to 11."
  (interactive)
  (set-face-attribute 'default nil :height 110))
(defun rod-font-12 ()
  "Set font size to 12."
  (interactive)
  (set-face-attribute 'default nil :height 120))
(defun rod-default-font (size)
  "Set default font in all frames height to SIZE."
  (interactive "nEnter font height: ")
  (set-face-attribute 'default nil :height size))
(defun rod-low-dpi-72 ()
  "Adjust font size to a low-DPI screen"
  (interactive)
  (set-face-attribute 'default (selected-frame) :height 72))
(defun rod-low-dpi-67 ()
  "Adjust font size to a low-DPI screen"
  (interactive)
  (set-face-attribute 'default (selected-frame) :height 67))
(defun rod-frame-font (size)
  "Set font in the current frame frames height to SIZE."
  (interactive "nEnter font height: ")
  (set-face-attribute 'default (selected-frame) :height size))
;;(face-remap-add-relative 'variable-pitch :family "IBM Plex Sans"
;;			 :height 140)
(when (member "IBM Plex Sans" (font-family-list))
  (custom-theme-set-faces
   'user
   '(variable-pitch ((t (:family "IBM Plex Sans"))))))
;; '(variable-pitch ((t (:family "IBM Plex Sans" :height 110)))))

;; Warning! Fira Mono doesn't have italics
;; (set-frame-font "Fira Mono-8" nil t)
;; Plex Mono has italics
;; (set-frame-font "IBM Plex Mono-16" nil t)  ;; quite high

(when (member "Cascadia Code" (font-family-list))
  (set-frame-font "Cascadia Code-12" nil t))

;; Font size adjustment
;; From https://www.reddit.com/r/emacs/comments/dpc2aj/comment/f5uasez/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
;; Disadvantage: manual setting of frame font size now doesn't work
(defun rod-adjust-font-size (frame)
  "Inspired by https://emacs.stackexchange.com/a/44930/17066. FRAME is ignored.
If I let Windows handle DPI everything looks blurry."
  ;; Using display names is unreliable...switched to checking the resolution
  (let* ((attrs (frame-monitor-attributes)) ;; gets attribs for current frame
         (monitor-name (cdr (nth 3 attrs)))
         (width-mm (nth 1 (nth 2 attrs)))
         (width-px (nth 3 (nth 0 attrs)))
         (size 90)) ;; default for first screen at work
    (when (eq width-px 2560) ;; middle display at work
      (setq size 120))
    (when (eq width-px 1920) ;; laptop screen
      (setq size 90))
    (when (eq (length (display-monitor-attributes-list)) 1) ;; override everything if no external monitors!
      (setq size 90))
    (rod-frame-font size)
    ;; (message "hello")
    ))
(add-hook 'window-size-change-functions #'rod-adjust-font-size)
(remove-hook 'window-size-change-functions #'rod-adjust-font-size)

;; light, smaller height than fira
;; (set-frame-font "DejaVu Sans Mono-12" nil t)
;; almost the same (metrically the same) as DejaVu
;; (set-frame-font "Droid Sans Mono Slashed-11" nil t)
;; large height, not very wide, bolder, good readability, different
;; warning - wrong spacing in some cases!
;; (set-frame-font "Iosevka-8" nil t)
;; standard Windows
;; (set-frame-font "Lucida Console-11" nil t)
;; (set-frame-font "Liberation Mono-11" nil t)
;; serif monospace, like Chinese monospace Latin
;; (set-frame-font "Libertinus Mono-8" nil t)
;; (set-frame-font "Noto Mono-11" nil t)
;; large height, large linespacing
;; (set-frame-font "Overpass Mono-8" nil t)
;; light and wide
;; (set-frame-font "Source Code Pro-8" nil t)
;; (set-frame-font "Ubuntu Mono-12" nil t)

;; automatically disable current theme before loading a new one
(defadvice load-theme
  (before theme-dont-propagate activate)
  (mapc #'disable-theme custom-enabled-themes))

;; set auto fill mode for org-mode
(setq-default fill-column 79)
(add-hook 'org-mode-hook 'turn-on-auto-fill)

;; weekday numbers in the calendar
(copy-face font-lock-constant-face 'calendar-iso-week-face)
(set-face-attribute 'calendar-iso-week-face nil
		    :slant 'italic)
(setq calendar-intermonth-text
      '(propertize
        (format "%2d"
                (car
                 (calendar-iso-from-absolute
                  (calendar-absolute-from-gregorian (list month day year)))))
        'font-lock-face 'calendar-iso-week-face))
;; Header for week column
;; for now commented out, it just isn't aligned well
;; (setq calendar-intermonth-header
      ;; '(propertize "W" 'font-lock-face 'calendar-iso-week-face))
;; Week starts with Monday
(setq calendar-week-start-day 1)
(setq holiday-general-holidays nil)
(setq holiday-hebrew-holidays nil)
(setq holiday-islamic-holidays nil)
(setq holiday-bahai-holidays nil)
(setq holiday-oriental-holidays nil)
(setq holiday-other-holidays
      '((holiday-fixed 1 1 "Deň vzniku Slovenskej republiky")
	(holiday-fixed 1 6 "Zjavenie Pána (Traja králi)")
	(holiday-easter-etc  +1 "Veľkonočný pondelok")
	(holiday-fixed 5 1 "Sviatok práce")
	(holiday-fixed 5 8 "Deň víťazstva nad fašizmom")
	(holiday-fixed 7 5 "Sviatok svätého Cyrila a Metoda")
	(holiday-fixed 8 29 "Výročie SNP")
	(holiday-fixed 9 1 "Deň Ústavy Slovenskej republiky")
	(holiday-fixed 9 15 "Sedembolestná Panna Mária")
	(holiday-fixed 11 1 "Sviatok všetkých svätých")
	(holiday-fixed 11 17 "Deň boja za slobodu a demokraciu")
	(holiday-fixed 12 24 "Štedrý deň")
	(holiday-fixed 12 26 "Druhý sviatok vianočný")))

(use-package astro-ts-mode)

;; inspired by https://github.com/xiaoxinghu/dotfiles/blob/master/emacs/.emacs.d/modules/treesitter.el
(use-package treesit
  :ensure nil ;; internal package
  :commands (treesit-install-language-grammar)
  :init
  (setq treesit-language-source-alist
	'((astro . ("https://github.com/virchau13/tree-sitter-astro"))
	  (bash . ("https://github.com/tree-sitter/tree-sitter-bash"))
	  (c . ("https://github.com/tree-sitter/tree-sitter-c"))
	  (cpp . ("https://github.com/tree-sitter/tree-sitter-cpp"))
	  (css . ("https://github.com/tree-sitter/tree-sitter-css"))
	  (go . ("https://github.com/tree-sitter/tree-sitter-go"))
	  (html . ("https://github.com/tree-sitter/tree-sitter-html"))
	  (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript"))
	  (json . ("https://github.com/tree-sitter/tree-sitter-json"))
	  (lua . ("https://github.com/Azganoth/tree-sitter-lua"))
	  (make . ("https://github.com/alemuller/tree-sitter-make"))
	  ;; (ocaml . ("https://github.com/tree-sitter/tree-sitter-ocaml" "ocaml/src" "ocaml"))
	  (python . ("https://github.com/tree-sitter/tree-sitter-python"))
	  (php . ("https://github.com/tree-sitter/tree-sitter-php" "master" "php/src"))
	  (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "typescript/src" "typescript"))
	  (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src"))
	  (ruby . ("https://github.com/tree-sitter/tree-sitter-ruby"))
	  (rust . ("https://github.com/tree-sitter/tree-sitter-rust"))
	  (sql . ("https://github.com/m-novikov/tree-sitter-sql"))
	  (toml . ("https://github.com/tree-sitter/tree-sitter-toml"))
	  ;; (zig . ("https://github.com/GrayJack/tree-sitter-zig"))
	  (yaml . ("https://github.com/ikatyang/tree-sitter-yaml"))
	  ))
  :config
  (treesit-major-mode-setup)
  ;; (use-package combobulate
  ;;   :preface
  ;;   ;; You can customize Combobulate's key prefix here.
  ;;   ;; Note that you may have to restart Emacs for this to take effect!
  ;;   (setq combobulate-key-prefix "C-c m"))
  )

(setq major-mode-remap-alist
 '((python-mode . python-ts-mode)))

(use-package php-mode
  :mode ("\\.php\\'" . php-mode))

;;; auctex
;(require 'tex-site)			; TODO: Why is this here? This shouldn't
					; really be here. Can you debug it?
(use-package tex
  ;; Test if work on Windows or change to auctex
  :ensure nil				; package is called auctex

  ;; This is a function from pdf-tools. I have to find a way to properly bind it
  ;; without errors.
  ;;
  ;; :bind ("C-c C-g" . pdf-sync-forward-search)

  :init
  (progn
    (setq TeX-auto-save t
	  TeX-parse-self t
	  ;; ask for master file automatically
	  TeX-master nil
	  TeX-show-compilation nil)
    (add-hook 'LaTeX-mode-hook 'TeX-fold-mode)
    ;; turn on outline-minor-mode
    (add-hook 'LaTeX-mode-hook 'outline-minor-mode)
    (add-hook 'LaTeX-mode-hook 'turn-on-auto-fill))
  :hook (tex-mode-hook . (lambda ()
			   (setq-local search-whitespace-regexp
				       (concat search-whitespace-regexp "\\|~")))))

(use-package reftex
  :ensure nil
  :hook (LaTeX-mode-hook . turn-on-reftex)
  :config
  (setq reftex-plug-into-AUCTeX '(nil nil t t t) ; from spacemacs
	reftex-use-fonts t))

(use-package magic-latex-buffer
  :defer t
  :init
  (progn
    ;; Disable on 2023-02-08, not useful
    ;; (add-hook 'TeX-update-style-hook 'magic-latex-buffer)
    (setq
     ;; magic-latex-enable-block-align nil
     magic-latex-enable-inline-image nil)))

(use-package auctex-latexmk
  :hook (LaTeX-mode-hook . auctex-latexmk-setup)
  :config
  ;; output PDF, not DVI
  (setq auctex-latexmk-inherit-TeX-PDF-mode t))

(use-package lsp-latex
  :hook
  (tex-mode-hook    . lsp)
  (latex-mode-hook  . lsp)
  (LaTeX-mode-hook  . lsp)
  (yatex-mode-hook  . lsp)
  (bibtex-mode-hook . lsp))

(use-package outline
  :ensure nil
  :diminish outline-minor-mode)

;; Backups
(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backups"))))

;; Open files where I left them
(use-package saveplace
  :init
  (progn
    (save-place-mode 1)))

;; template system yasnippet
(use-package yasnippet-snippets)
(use-package yasnippet
  :defer t
  :commands (yas-global-mode yas-minor-mode yas-activate-extra-mode)
  :diminish yas-minor-mode " y"
  :hook (prog-mode-hook . yas-minor-mode)
  (org-mode-hook . yas-minor-mode)
  :config (yas-global-mode)
					; personal snippets
  (add-to-list 'yas-snippet-dirs
	       (concat user-emacs-directory "snippets")))

(use-package help-fns+
  :load-path "site-lisp/help-fns+"
  :commands (describe-keymap)
  :init
  (progn
    (advice-add 'help-do-xref :after (lambda (_pos _func _args)
				       (setq-local tab-width 8)))))

;; quickrun from spacemacs
(use-package quickrun)
  ;; :init
  ;;(setq quickrun-focus-p nil)

;;; python

;; for jupyter
;; but doesn't seem to work correctly
;; errors:
;; ein: [warn] ein:jupyter-default-kernel: (json-readtable-error 84)
;; error in process sentinel: ein:websocket--prepare-cookies: Invalid function: ein:log
;; error in process sentinel: Invalid function: ein:log
(use-package ein)

;; After installing a new version of python, run this in an administrator shell:
;; `pip install pylint flake8'
(when (eq system-type 'windows-nt)
      (setq flycheck-python-pylint-executable "c:/python312/python.exe")
      (setq flycheck-python-flake8-executable "c:/python312/python.exe")
      (setq flycheck-python-pycompile-executable "c:/python312/python.exe"))

;; lsp python

(use-package python
  :mode (("SConstruct\\'" . python-ts-mode) ("SConscript\\'" . python-ts-mode))
  :hook (python-ts-mode-hook . (lambda ()
			      ;; (require 'lsp-pylsp)
			      (lsp)
			      )))
(use-package blacken)
(use-package pyvenv)
(use-package pip-requirements)
(use-package pippel)
(use-package pipenv)
(use-package py-isort)
(use-package pydoc)
(use-package pyenv-mode)
(use-package sphinx-doc)
(use-package python-docstring)
;; pip install python-lsp-server

;;; Rust

(use-package cargo)
(use-package rust-mode)
(use-package toml-mode
  :mode "/\\(Cargo.lock\\|\\.cargo/config\\)\\'")
(use-package ron-mode
  :mode ("\\.ron\\'" . ron-mode)
  :defer t)
(use-package flycheck-rust
  :defer t
  :init (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

(defun rod-copy-whole-buffer ()
  "Copy whole buffer."
  (interactive)
  (kill-ring-save 1 (+ (buffer-size) 1)))

(defun rod-replace-whole-buffer ()
  "Replace whole buffer with contents from the kill ring."
  (interactive)
  (erase-buffer)
  (yank))

(defun rod-replace-at (str)
  "Advice function for mail addresses from AIS"
  (replace-regexp-in-string
   " \\[at\\] " "@"
   str))

(advice-add 'current-kill :filter-return #'rod-replace-at)

(defun rod-remove-uim-prefix (str)
  "Advice function for mail addresses from AIS"
  (string-remove-prefix
   "https://uim.fei.stuba.sk"
   str))

(advice-add 'current-kill :filter-return #'rod-remove-uim-prefix)
(advice-remove 'current-kill #'rod-remove-uim-prefix)

(defun rod-kill-current-buffer-and-enter-dired ()
  (interactive)
  (save-excursion
    (dired))
  (kill-buffer))

(defun rod-start-cmd-here ()
  "Open cmd in current directory.

But it has non-functional terminal! Ie. no colors!"
  (interactive)
  (let ((proc (start-process "cmd" nil "cmd.exe" "/C" "start" "cmd.exe")))
    (set-process-query-on-exit-flag proc nil)))

(defun rod-start-pwsh-here ()
  "Open pwsh in current directory.

But it has non-functional terminal! Ie. no colors!"
  (interactive)
  (let ((proc (start-process "pwsh" nil "C:/Program Files/PowerShell/7/pwsh.exe" "-NoExit" "-c" "start pwsh.exe")))
    (set-process-query-on-exit-flag proc nil)))

(defun rod-start-alacritty-here ()
  "Open alacritty in current directory.

This is the best! Colors work."
  (interactive)
  (let ((proc (start-process "alacritty" nil "C:/Program Files/Alacritty/alacritty.exe")))
    (set-process-query-on-exit-flag proc nil)))

(defun rod-start-console-here ()
  "Open Console in the current directory."
  (interactive)
  (let ((proc (start-process "kgx" nil "kgx")))
    (set-process-query-on-exit-flag proc nil)))

(defun rod-copy-emacs-cwd ()
  "Copy current working directory to the clipboard."
  (interactive)
  (kill-new (expand-file-name ".")))

(when (eq system-type 'windows-nt)
  (defun rod-copy-windows-cwd ()
    "Copy current working directory to the clipboard."
    (interactive)
    (kill-new (replace-regexp-in-string "/" "\\\\" (expand-file-name ".")))))

(defun rod-copy-buffer-file-name ()
  "Copy path of the current file to the clipboard"
  (interactive)
  (kill-new buffer-file-name))

(defun rod-surround-doublehash ()
  "Surround selection with ##."
  (interactive)
  (let (pt)
    (skip-chars-backward "_().A-Za-z0-9")
    (setq pt (point))
    (skip-chars-forward "_().A-Za-z0-9")
    (set-mark pt))
  (goto-char (region-end))
  (insert "##")
  (goto-char (region-beginning))
  (insert "##"))

;; (global-set-key [f9] 'rod-surround-doublehash)

(defun rod-surround-p ()
  "Surround selection with ##."
  (interactive)
  (goto-char (region-end))
  (insert "</p>")
  (goto-char (region-beginning))
  (insert "<p>"))

;; (global-set-key [f9] 'rod-surround-p)

;; ffap that works more like in vim
(defun rod-ffap ()
  "Go to the file under the point."
  (interactive)
  (find-file (ffap-file-at-point)))

(defun rod-clone-file-visting-buffer (&optional newname display-flag)
  "Create a clone of a file visiting buffer and switch to it. This
is useful if you want to view an alternative version of a file
before switching to a different branch in version control."
  (interactive
   (progn
     (if (get major-mode 'no-clone)
	 (error "Cannot clone a buffer in %s mode" mode-name))
     (list (if current-prefix-arg
	       (read-buffer "Name of new cloned buffer: " (current-buffer)))
	   t)))
  (if (get major-mode 'no-clone)
      (error "Cannot clone a buffer in %s mode" mode-name))
  (setq newname (or newname (buffer-name)))
  (if (string-match "<[0-9]+>\\'" newname)
      (setq newname (substring newname 0 (match-beginning 0))))
  (let ((buf (current-buffer))
	(ptmin (point-min))
	(ptmax (point-max))
	(pt (point))
	(mk (if mark-active (mark t)))
	(modified (buffer-modified-p))
	(mode major-mode)
	(new (generate-new-buffer (or newname (buffer-name)))))
    (save-restriction
      (widen)
      (with-current-buffer new
	(insert-buffer-substring buf)))
    (with-current-buffer new
      (narrow-to-region ptmin ptmax)
      (goto-char pt)
      (if mk (set-mark mk))
      (set-buffer-modified-p modified)

      ;; Now set up the major mode.
      (funcall mode)

      (setq mark-ring (mapcar (lambda (mk) (copy-marker (marker-position mk)))
                              mark-ring))
      (if display-flag
          ;; Presumably the current buffer is shown in the selected frame, so
          ;; we want to display the clone elsewhere.
          (let ((same-window-regexps nil)
		(same-window-buffer-names))
            (pop-to-buffer new)))
      new)))

(defun rod-newline-advice (&optional arg interactive)
  "Remove trailing whitespace when adding a newline."
  (delete-horizontal-space t))

(advice-add #'newline :before #'rod-newline-advice)

(when (eq system-type 'windows-nt)
      (defun rod-open-in-notepad++ ()
	"Open current file or dir in notepad++.

Inspired by URL
`http://ergoemacs.org/emacs/emacs_dired_open_file_in_ext_apps.html'
Version 2020-02-13"
	(interactive)
	(let (($path (if (buffer-file-name) (buffer-file-name) (expand-file-name default-directory ) )))
	  ;; (message "path is %s" $path)
	  (let ((proc (start-process "notepad++" nil "C:\\Program Files\\Notepad++\\notepad++.exe" $path)))
	    (set-process-query-on-exit-flag proc nil)))))

(defun rod-open-in-gvim ()
  "Open current file or dir in gvim.

Inspired by URL
`http://ergoemacs.org/emacs/emacs_dired_open_file_in_ext_apps.html'
Version 2020-02-13"
  (interactive)
  (let (($path (if (buffer-file-name) (buffer-file-name) (expand-file-name default-directory))))
    ;; (message "path is %s" $path)
    (let ((proc (start-process
		 "gvim"
		 nil
		 "c:/tools/vim/vim82/gvim.exe"
		 $path
		 (format "+%d" (line-number-at-pos)))))
      (set-process-query-on-exit-flag proc nil))))

;; So that rod-open-explorer can work correctly, we have to set handler for
;; non-html files as `browse-url-default-browser' which runs explorer on Windows
(setq browse-url-handlers
      '((browse-url--non-html-file-url-p . browse-url-default-browser)))


;; TODO: When the filename is long, the explorer fails to select the correct
;; file and opens the Documents directory. Find out why.
;; 2023-02-16: It's probably windows coding
(defun rod-open-explorer ()
  "Open the current file's directory however the OS would. If the
current mode is dired-like, open explorer.exe or nautilus with
the current file selected."
  (interactive)
  (if default-directory
      (if (derived-mode-p 'dired-mode)
	  (let ((proc
		 (pcase system-type
		   ('windows-nt
		    (start-process "explorer" nil "explorer.exe"
				   (concat "/select,"
					   (dired-get-filename 'no-dir)
					   "")))
		   ('gnu/linux
		    (start-process "nautilus"
				   nil
				   "nautilus"
				   "-s"
				   (dired-get-filename 'no-dir)
				   )))))
	    (set-process-query-on-exit-flag proc nil))
	(browse-url-of-file (expand-file-name default-directory)))
    (error "No `default-directory' to open")))

;; TODO: Check if this is not a duplicate
(defun rod-copy-cwd-path ()
  "Yank current default directory."
  (interactive)
  (if default-directory
      (progn
	(if (eq last-command 'kill-region)
            (kill-append (expand-file-name default-directory) nil)
          (kill-new (expand-file-name default-directory)))
	(message "%s" (expand-file-name default-directory)))
    (error "No `default-directory' to open")))

(defmacro rod-dired (name path)
  "Create function that opens PATH in dired."
  (list 'defun (intern (format "rod-dired-%s" name)) ()
	(list 'interactive)
	(list 'dired path)))

(when (eq system-type 'windows-nt)
      (rod-dired downloads (rod-concat-userprofile-dir "Downloads"))
      (rod-dired c "c:"))

(use-package dired-recent)
(dired-recent-mode 1)

;; (defmacro rod-create-timer-fun (ext time name)
;;   "Create chronos timer function named rod-chronos-EXT that counts
;; down string TIME minutes with timer named NAME."
;;   (list 'defun (intern (format "rod-chronos-%s" ext)) ()
;; 	(list 'interactive)
;; 	(list 'chronos-add-timer time name nil)
;; 	(list 'switch-to-buffer chronos--buffer)))

(use-package chronos)

(defun rod-kozarovce ()
  "Count time until Kozarovce from Levice."
  (interactive)
  (chronos-add-timer "10" "Kozárovce" nil)
  (switch-to-buffer chronos--buffer))

(defun rod-zarnovica ()
  "Count time until Žarnovica fron Žiar nad Hronom."
  (interactive)
  (chronos-add-timer "12" "Žarnovica" nil)
  (switch-to-buffer chronos--buffer))

(defun rod-nova-bana ()
  "Count time until Nova Bana from Žarnovica."
  (interactive)
  (chronos-add-timer "10" "Nová Baňa" nil)
  (switch-to-buffer chronos--buffer))

(defun rod-podhajska ()
  "Count time until Podhajska."
  (interactive)
  (chronos-add-timer "24" "Podhájska" nil)
  (switch-to-buffer chronos--buffer))

(defun rod-sala ()
  "Count time until Sala from Galanta."
  (interactive)
  (chronos-add-timer "7" "Sala" nil)
  (switch-to-buffer chronos--buffer))

(defun rod-bratislava-hlavna-stanica ()
  "Count time until Bratislava hlavna stanica."
  (interactive)
  (chronos-add-timer "6" "Bratislava hl. st." nil)
  (switch-to-buffer chronos--buffer))

;; (rod-create-timer-fun nova-bana "11" "Nová Baňa")

(use-package name-this-color
  :commands ntc-name-this-color)

(defun rod-name-this-color (color-code)
  "Interactive version of `ntc-name-this-color'."
  (interactive "MEnter color name: ")
  (message (ntc-name-this-color color-code)))

;; title case, very useful
(defun xah-title-case-region-or-line (@begin @end)
  "Title case text between nearest brackets, or current line, or text selection.
Capitalize first letter of each word, except words like {to, of, the, a, in, or, and, …}. If a word already contains cap letters such as HTTP, URL, they are left as is.

When called in a elisp program, *begin *end are region boundaries.
URL `http://ergoemacs.org/emacs/elisp_title_case_text.html'
Version 2017-01-11"
  (interactive
   (if (use-region-p)
       (list (region-beginning) (region-end))
     (let (
           $p1
           $p2
           ($skipChars "^\"<>(){}[]“”‘’‹›«»「」『』【】〖〗《》〈〉〔〕"))
       (progn
         (skip-chars-backward $skipChars (line-beginning-position))
         (setq $p1 (point))
         (skip-chars-forward $skipChars (line-end-position))
         (setq $p2 (point)))
       (list $p1 $p2))))
  (let* (
         ($strPairs [
                     [" A " " a "]
                     [" And " " and "]
                     [" At " " at "]
                     [" As " " as "]
                     [" By " " by "]
                     [" Be " " be "]
                     [" Into " " into "]
                     [" In " " in "]
                     [" Is " " is "]
                     [" It " " it "]
                     [" For " " for "]
                     [" Of " " of "]
                     [" Or " " or "]
                     [" On " " on "]
                     [" Via " " via "]
                     [" The " " the "]
                     [" That " " that "]
                     [" To " " to "]
                     [" Vs " " vs "]
                     [" With " " with "]
                     [" From " " from "]
                     ["'S " "'s "]
                     ["'T " "'t "]
                     ]))
    (save-excursion
      (save-restriction
        (narrow-to-region @begin @end)
        (upcase-initials-region (point-min) (point-max))
        (let ((case-fold-search nil))
          (mapc
           (lambda ($x)
             (goto-char (point-min))
             (while
                 (search-forward (aref $x 0) nil t)
               (replace-match (aref $x 1) "FIXEDCASE" "LITERAL")))
           $strPairs))))))

(defun rod-load-dark-theme ()
  "Load the dark theme."
  (interactive)
  ;; (load-theme 'doom-one))
  ;; (load-theme 'doom-oceanic-next))
  ;; (load-theme 'doom-dracula))
  (modus-themes-load-vivendi))

(defun rod-load-light-theme ()
  "Load the dark theme."
  (interactive)
  ;; (load-theme 'doom-one-light)
  ;; (load-theme 'spacemacs-light))
  (modus-themes-load-operandi))

(defun rod-convert-cp1250-to-utf8 ()
  "Revert the current buffer in cp1250 and save it as utf8."
  (interactive)
  (revert-buffer-with-coding-system 'windows-1250)
  (set-buffer-file-coding-system 'utf-8)
  (save-buffer)
  (kill-current-buffer))

;; edit from firefox
(use-package edit-server
  :commands edit-server-start
  :init (if after-init-time
            (edit-server-start)
          (add-hook 'after-init-hook
                    #'(lambda() (edit-server-start)))))
  ;; :config (setq edit-server-new-frame-alist
                ;; '((name . "Edit with Emacs FRAME")
                  ;; (top . 200)
                  ;; (left . 200)
                  ;; (width . 80)
                  ;; (height . 25)
                  ;; (minibuffer . t)
                  ;; (menu-bar-lines . t)
                  ;; (window-system . x))))

(use-package avy
  :bind
  (("C-:"     . avy-goto-char)
   ("C-`"     . avy-goto-char-2)
   ("M-g l"   . avy-goto-line)
   ("M-g M-l" . avy-goto-line)
   ("M-g w"   . avy-goto-word-1)
   ("M-g M-w" . avy-goto-word-1)
   ("M-g e"   . avy-goto-word-0)
   ("M-g M-e" . avy-goto-word-0)))

(use-package dired
  :ensure nil
  :config
  ;; (require 'dired+)
  ;; -a list all files, -g don't print user, -G don't print group
  ;; -F append classificator, -h human readable size,
  ;; -l list, -v sort version numbers, -D dired output
  (setq-default dired-listing-switches "-agGFhlvD"
		dired-dwim-target t)
  (add-hook 'dired-mode-hook 'turn-on-gnus-dired-mode)
  :init
  (defun rod-dired-copy-windows-full-path (&optional arg)
    "Copy absolute file names of marked (or next ARG) files into
the kill ring. The names are separated by a space and are in
Windows format."
    (interactive "P")
    (let ((string
           (or (dired-get-subdir)
               (mapconcat #'identity
                          (dired-get-marked-files)
			  " "))))
      (unless (string= string "")
	(setq string (replace-regexp-in-string "/" "\\\\" string))
	(if (eq last-command 'kill-region)
            (kill-append string nil)
          (kill-new string))
	(message "%s" string))))
  :bind (:map dired-mode-map
	      ("e" . rod-dired-do-explorer)
	      ("r" . rod-dired-copy-windows-full-path)))

(use-package image-dired
  :config
  (setq image-dired-queue-active-limit 16))

(use-package dired-aux
  :ensure nil
  :config
  (add-to-list 'dired-compress-file-suffixes
	       ;; Extract rar files using 7z to directory with the same name
	       ;; (-o*) and skip overwriting existing files (-aos).
               '("\\.rar\\'" "" "7z x \"%i\" -o* -aos"))
  (add-to-list 'dired-compress-file-suffixes
               '("\\.tar\\.bz2\\'" "" "tar -xf %i")))

(when (eq system-type 'windows-nt)
      (defun rod-dired-do-explorer ()
	"Open file at point using default handler program in Windows."
	(interactive)
	(dired-do-shell-command
	 "explorer"
	 nil
	 ;; Replace second argument by current-prefix-arg if you want to use file near
	 ;; point only if the prefix argument has been given.
	 (dired-get-marked-files t t nil nil t))))

;; Thanks leah aka bcmertz for inspiration.
;; https://github.com/bcmertz/dotfiles/blob/main/.emacs.d/lisp/custom-keybindings.el
(use-package general
  :config
  (general-override-mode 1)
  (general-create-definer rod-general-definer
			  :prefix "M-n")
  (rod-general-definer
   "" nil
   "h"   (general-simulate-key "C-h" :which-key "help")
   "u"   (general-simulate-key "C-u" :which-key "u")

   "SPC" '(avy-goto-char :which-key "goto char")
   "j" '(avy-goto-line :which-key "goto line")
   "p"  (general-simulate-key "C-c p" :which-key "projectile")
   "\\" '(neotree-project-dir-toggle :which-key "neotree")
   ";" '(er/expand-region :which-key "expand")
   "m" '(:ignore t :which-key "mode")

   "x"  '(:ignore t :which-key "file")
   "xf" 'counsel-find-file
   "xS" 'save-some-buffers
   "xa" 'counsel-ag

   "w"  '(:ignore t :which-key "window")
   "w=" 'enlarge-window-horizontally
   "w+" 'enlarge-window
   "w-" 'shrink-window-horizontally
   "w_" 'shrink-window
   "w1" 'delete-other-windows
   "w2" 'split-window-below
   "w3" 'split-window-right

   "t"  '(:ignore t :which-key "theme")
   "th" 'global-hl-line-mode
   "tn" 'global-display-line-numbers-mode
   "tt" 'modus-themes-toggle
   "tf" 'rod-frame-font

   "f"  '(:ignore t :which-key "folding")
   "ff" 'vimish-fold
   "fd" 'vimish-fold-delete
   "fl" 'vimish-fold-avy
   "fD" 'vimish-fold-delete-all

   "c"  '(:ignore t :which-key "multicurse")
   "c." 'mc/mark-next-like-this
   "c," 'mc/mark-previous-like-this
   "ca" 'mc/mark-all-like-this
   "ce" 'mc/edit-lines

   ;; Buffer operations
   "b"   '(:ignore t :which-key "buffer")
   "bk"  'kill-this-buffer
   "bK"  'kill-buffer-and-window
   "b]"  'next-buffer
   "b["  'previous-buffer
   "bR"  'rename-file-and-buffer
   "br"  'revert-buffer

   ;; SmartParens
   "e" '(:ignore t :which-key "SmartParens")
   "ee" 'sp-show-enclosing-pair
   "eu" 'sp-up-sexp
   "ed" 'sp-down-sexp
   "ec" 'sp-change-enclosing
   "er" 'sp-rewrap-sexp

  ;; org
  "o" '(:ignore t :which-key "org")
  "og" 'org-clock-goto
  "oc" 'org-expiry-insert-created
  "op" 'org-pomodoro
  "o2" 'rod-goto-calendar))

;;; aliases
;;
;; Find, visit. Emacs is consistent, but sometimes it can use a bit more
;; consistency. Hence, these aliases.
(defalias 'rod-open-tags-file 'visit-tags-table)
(defalias 'rod-update-packages 'package-refresh-contents)
(defalias 'rod-toggle-break-line-mode 'toggle-truncate-lines)
;; for rg, I remember command name ripgrep and then wonder why is "rgrep" so
;; slow
(defalias 'rod-ripgrep 'rg)
;; less typing
(setq use-short-answers t)		; Supported from Emacs 28
;; (defalias 'yes-or-no-p 'y-or-n-p)

;; vc-mode
(defalias 'rod-vc-switch-tag-or-branch 'vc-retrieve-tag)

;; icicles (banned by MELPA, had to install manually)
;; (add-to-list 'load-path "~/.emacs.d/site-lisp/icicles")
;; (require 'icicles)

;; pos-tip for jedi, system popup
(add-to-list 'load-path (concat user-emacs-directory "site-lisp/pos-tip"))
(use-package pos-tip
  :ensure nil)				;isn't tested with use package

;; NeoTree
;; (setq neo-theme (if (display-graphic-p) 'icons 'arrow))

(use-package saveplace-pdf-view)

;; pdf-tools
(use-package pdf-tools
  :mode (("\\.pdf\\'" . pdf-view-mode))
  :config
  (progn
    (pdf-tools-install)
    (require 'saveplace-pdf-view))
  :hook (pdf-view-mode-hook . auto-revert-mode)
  :bind (:map pdf-view-mode-map
              ("C-c C-s" . rod-open-pdf-in-sumatra)
	      ("/" . pdf-annot-add-squiggly-markup-annotation)
	      ("\\" . pdf-annot-add-squiggly-markup-annotation)
	      ("z" . pdf-annot-add-strikeout-markup-annotation)
	      ("x" . pdf-annot-add-highlight-markup-annotation)))

(defun rod-pdf-tools-compile-epdfinfo-server ()
  "Unconditionally compile epdfinfo server for pdf-tools package."
  (interactive)
  (let ((target-directory
	 (or (and (stringp pdf-info-epdfinfo-program)
                  (file-name-directory
                   pdf-info-epdfinfo-program))
             pdf-tools-directory)))
    (pdf-tools-build-server
     target-directory
     nil
     nil
     (lambda (executable)
       (let ((msg (format
                   "Building the PDF Tools server %s"
                   (if executable "succeeded" "failed"))))
         (if (not executable)
	     (funcall (if nil #'message #'error) "%s" msg)
           (message "%s" msg)
           (setq pdf-info-epdfinfo-program executable)
           (let ((pdf-info-restart-process-p t))
	     (pdf-tools-install-noverify))))))
    (message "PDF Tools not activated")))

;; projectile
(use-package projectile
  ;; 2024-12-01 Have to turn this off.
  ;; projectile-track-known-projects-find-file-hook is slowing down everything
  ;; (org-mode and company completions)

  ;; :hook (prog-mode-hook . projectile-mode)
  ;; (remove-hook 'prog-mode-hook 'projectile-mode)
  :bind
  ("C-c p" . projectile-command-map)
  :diminish projectile-mode
  :config
  (setq projectile-globally-ignored-file-suffixes
	'(".eps" ".bst" ".aux" ".bbl" ".bcf" ".blg" ".fdb_latexmk" ".fls" ".lof" ".lot" ".out" ".pri" ".tox")))

;; smartparens

;; stolen from spacemacs
(defun spacemacs/smartparens-pair-newline (id action context)
  (save-excursion
    (newline)
    (indent-according-to-mode)))

(defun spacemacs/smartparens-pair-newline-and-indent (id action context)
  (spacemacs/smartparens-pair-newline id action context)
  (indent-according-to-mode))

(use-package smartparens
  :diminish smartparens-mode
  ;; These hooks caused problems (2023-05-03) "smartparens.elc failed to define
  ;; function smartparens".
  ;;
  ;; :hook (prog-mode-hook org-mode-hook latex-mode-hook)
  :custom (sp-base-key-bindings 'sp)
  (sp-override-key-bindings '(("C-<right>". nil)
			      ("C-<left>" . nil)
			      ("C-S-<backspace>" . nil)
			      ("C-M-<right>" . sp-forward-sexp)
			      ("C-M-<left>" . sp-backward-sexp)
			      ;; https://github.com/Fuco1/smartparens/issues/602#issuecomment-1249061100
			      ;; ("M-<backspace>" . sp-backward-kill-sexp)
			      ("M-[ M-[" . sp-backward-slurp-sexp)
			      ("M-] M-]" . sp-forward-slurp-sexp)
			      ("M-[ M-]" . sp-backward-barf-sexp)
			      ("M-] M-[" . sp-forward-barf-sexp)
			      ("M-] M-p" . sp-unwrap-sexp)
			      ("M-[ M-p" . sp-rewrap-sexp)))
  ;; :init
  ;; (require 'smartparens-config)
  :hook ((prog-mode-hook org-mode-hook) . smartparens-mode)
  :config
  (require 'smartparens-config)
  ;; (smartparens-global-mode 1)
  ;; (sp-use-smartparens-bindings)
  ;; (sp--update-override-key-bindings)
  ;; don't create a pair with single quote in minibuffer
  (sp-local-pair 'minibuffer-inactive-mode "'" nil :actions nil)
  (sp-local-pair 'minibuffer-mode "'" nil :actions nil)
  (sp-pair "{" nil :post-handlers
           '(:add (spacemacs/smartparens-pair-newline-and-indent "RET")))
  (sp-pair "[" nil :post-handlers
           '(:add (spacemacs/smartparens-pair-newline-and-indent "RET")))
  :commands (smartparens-mode show-smartparens-mode))

(use-package yaml-mode)

;; gnus
(use-package gnus
  :defer t
  :commands gnus
  :config
  (progn
    ;; org-mime to write html mails
    ;; org-mime installed via package manager
    (use-package org-mime
      :config
      (setq org-mime-library 'mml)
      (setq org-mime-export-options '(:section-numbers nil
						       :with-author nil
						       :with-toc nil
						       :with-sub-superscripts nil)))
    ;; stolen from Spacemacs
    (setq-default
     gnus-summary-line-format "%U%R%z %(%&user-date;  %-15,15f  %B %s%)\n"
     gnus-user-date-format-alist '((t . "%Y-%m-%d %H:%M"))
     ;; gnus-group-line-format "%M%S%p%P%5y:%B %G\n";;"%B%(%g%)"
     gnus-summary-thread-gathering-function 'gnus-gather-threads-by-references
     ;; gnus-thread-sort-functions '(gnus-thread-sort-by-most-recent-date)
     gnus-ignored-newsgroups "^to\\.\\|^[0-9. ]+\\( \\|$\\)\\|^[\”]\”[#’()]"
     gnus-sum-thread-tree-false-root ""
     gnus-sum-thread-tree-indent " "
     gnus-sum-thread-tree-leaf-with-other "├► "
     gnus-sum-thread-tree-root ""
     gnus-sum-thread-tree-single-leaf "╰► "
     gnus-sum-thread-tree-vertical "│"
     gnus-article-browse-delete-temp t
     gnus-treat-strip-trailing-blank-lines 'last
     gnus-summary-display-arrow nil ; Don't show that annoying arrow:
     gnus-mime-display-multipart-related-as-mixed t ; Show more MIME-stuff:
     gnus-auto-select-first nil ; Don't get the first article automatically:
     smiley-style 'medium)
    (setq gnus-refer-article-method
	  '(current
            (nnregistry)))))

;; some inspiration taken from https://github.com/Thaodan/emacs.d/
;; recent mail using gnus-notes
(use-package gnus-notes
  :after gnus
  :config
  (gnus-notes-init))
(use-package gnus-notes-helm
  :ensure nil
  :after gnus-notes
  :config (defalias 'rod-gnus-history 'gnus-notes-helm)

  ;; create more memorable command
  (defalias 'rod-recent-mail 'gnus-notes-helm)
  (defalias 'rod-gnus-recent 'gnus-notes-helm)
  (defalias 'rod-gnus-history 'gnus-notes-helm))

(use-package gnus-sum
  :ensure nil
  :after (gnus gnus-group)
  ;; :demand
  :config
  ;; (setq gnus-auto-select-first nil)
  ;; (setq gnus-summary-ignore-duplicates t)
  ;; (setq gnus-suppress-duplicates t)
  ;; (setq gnus-summary-goto-unread nil)
  ;; (setq gnus-summary-make-false-root 'adopt)
  ;; (setq gnus-summary-thread-gathering-function 'gnus-gather-threads-by-subject)
  ;; (setq gnus-thread-sort-functions
        ;; '((not gnus-thread-sort-by-number)
          ;; (not gnus-thread-sort-by-date)))
  ;; (setq gnus-subthread-sort-functions
        ;; 'gnus-thread-sort-by-date)
  ;; (setq gnus-thread-hide-subtree nil)
  ;; (setq gnus-thread-ignore-subject t)
  ;; (setq gnus-user-date-format-alist
        ;; '(((gnus-seconds-today) . "Today at %R")
          ;; ((+ 86400 (gnus-seconds-today)) . "Yesterday, %R")
          ;; (t . "%Y-%m-%d %R")))
  ;; (setq gnus-summary-line-format "%U%R%z %-16,16&user-date;  %4L:%-30,30f  %B%S\n")
  ;; (setq gnus-summary-mode-line-format "Gnus: %p (%U)")
  ;; (setq gnus-sum-thread-tree-false-root "")
  ;; (setq gnus-sum-thread-tree-indent " ")
  ;; (setq gnus-sum-thread-tree-leaf-with-other "├─➤ ")
  ;; (setq gnus-sum-thread-tree-root "")
  ;; (setq gnus-sum-thread-tree-single-leaf "└─➤ ")
  ;; (setq gnus-sum-thread-tree-vertical "│")
  :hook
  (gnus-summary-exit-hook . gnus-summary-bubble-group)
  (gnus-summary-exit-hook . gnus-group-sort-groups-by-rank))
  ;; :bind (:map gnus-agent-summary-mode-map
              ;; ("<delete>" . gnus-summary-delete-article)
              ;; ("n" . gnus-summary-next-article)
              ;; ("p" . gnus-summary-prev-article)
              ;; ("N" . gnus-summary-next-unread-article)
              ;; ("P" . gnus-summary-prev-unread-article)
              ;; ("M-n" . gnus-summary-next-thread)
              ;; ("M-p" . gnus-summary-prev-thread)
              ;; ("C-M-n" . gnus-summary-next-group)
              ;; ("C-M-p" . gnus-summary-prev-group)
              ;; ("C-M-^" . gnus-summary-refer-thread)))
;; -GnusSummary

(use-package gnus-msg
  :ensure nil
  :config
  (setq gnus-gcc-mark-as-read t))

(use-package gnus-notes)

;; inspired by
;; https://github.com/verdammelt/dotfiles/blob/master/.emacs.d/init-gnus.el
;;
;; But doesn't seem to work -- something about the clone function.
(use-package gnus-registry
  :ensure nil
  :disabled ; see comment above, also added 5 sec to startup
  :init (gnus-registry-initialize)
  :config
  (progn
    (setq gnus-registry-install t
          ;; gnus-registry-split-strategy 'majority
          gnus-registry-max-entries 500000)))
    ;; (push '("spam" t) gnus-registry-ignored-groups)))

;;;; RECEIVE

(use-package smtpmail-multi
  :config
  (setq message-send-mail-function 'smtpmail-multi-send-it)
  (setq smtpmail-debug-info t)
  (setq smtpmail-debug-verbose t)
  ;; toto funguje pre stubu
  ;; (setq smtpmail-stream-type 'starttls)
  ;; (setq smtpmail-stream-type nil)
  ;; (setq smtpmail-stream-type 'ssl)
  )

(require 'bbdb)
(bbdb-initialize 'gnus 'message)
(bbdb-mua-auto-update-init 'gnus 'message)
;; disable syntax checking of american phone numbers
(setq bbdb-north-american-phone-numbers-p nil)
(setq bbdb-complete-name-allow-cycling t)

;; I think this is for copying a line, but I didn't document it so now I don't
;; remember.
(put 'kill-ring-save 'interactive-form
     '(interactive
       (if (use-region-p)
           (list (region-beginning) (region-end))
         (list (line-beginning-position) (line-beginning-position 2)))))
(put 'kill-region 'interactive-form
     '(interactive
       (if (use-region-p)
           (list (region-beginning) (region-end))
         (list (line-beginning-position) (line-beginning-position 2)))))

(defun copy-line (arg)
  "Copy lines (as many as prefix argument) in the kill ring.
      Ease of use features:
      - Move to start of next line.
      - Appends the copy on sequential calls.
      - Use newline as last char even on the last line of the buffer.
      - If region is active, copy its lines."
    (interactive "p")
    (let ((beg (line-beginning-position))
          (end (line-end-position arg)))
      (when mark-active
        (if (> (point) (mark))
            (setq beg (save-excursion (goto-char (mark)) (line-beginning-position)))
          (setq end (save-excursion (goto-char (mark)) (line-end-position)))))
      (if (eq last-command 'copy-line)
          (kill-append (buffer-substring beg end) (< end beg))
        (kill-ring-save beg end)))
    (kill-append "\n" nil)
    (beginning-of-line (or (and arg (1+ arg)) 2))
    (if (and arg (not (= 1 arg))) (message "%d lines copied" arg)))

;; drag minor mode
;; for moving lines with M-up and M-down
(use-package drag-stuff)
(drag-stuff-global-mode 1)
;; don't use it in org-mode, it has its own functionality for this
(add-to-list 'drag-stuff-except-modes 'org-mode)
;; Use just up and down keys, don't use left and right
;; taken from drag-stuff.el
(define-key drag-stuff-mode-map (drag-stuff--kbd 'up) 'drag-stuff-up)
(define-key drag-stuff-mode-map (drag-stuff--kbd 'down) 'drag-stuff-down)

;; nov.el
(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))

;; start the daemon server
(server-start)

(when (eq system-type 'windows-nt)
      ;; use GNU tools from cygwin
      (add-to-list 'exec-path "C:/tools/cygwin/bin")
      (setenv "PATH" (concat "C:\\tools\\cygwin\\bin;" (getenv "PATH")))

      (setq ispell-program-name "aspell.exe")
      (setq ispell-aspell-dict-dir "c:/tools/cygwin/lib/aspell-0.60")
      (setq ispell-aspell-data-dir  "c:/tools/cygwin/lib/aspell-0.60"))
(setq ispell-dictionary "slovak")

;; ivy-posframe
(setq ivy-posframe-display-functions-alist
      '((t . ivy-posframe-display-at-frame-top-center)))
;; (ivy-posframe-mode 0)

;;; locale settings

;; I've read that this is not recommended, so I'm commenting it out (2022-01-02)
;; (set-language-environment "UTF-8")

;; This is a better way to do it. See
;; https://www.masteringemacs.org/article/working-coding-systems-unicode-emacs
;; for more
;;
;; One Windows caveat: For my use case it is better to use 'utf-8-unix rather
;; than 'utf-8. That's because, for example, when org-mode creates a temporary
;; buffer for babel code block execution, it will have UNIX line endings and
;; that works better with UNIX utilities such as sed.
(prefer-coding-system 'utf-8-unix)

;; This has to be set, because Emacs on Windows sets this to cp1252 and
;; functions like format-time-string (used by e.g. org-journal) output gibberish
;; diacritic characters. TODO: Why is it set to cp1252 by default?
(when (eq system-type 'windows-nt)
      (setq locale-coding-system 'cp1250))

(use-package rg)

;; wait for Emacs 30
;; (use-package corfu)

(use-package lsp-mode
  :diminish lsp-mode
  ;; uncomment to enable gopls http debug server
  ;; :custom (lsp-gopls-server-args '("-debug" "127.0.0.1:0"))
  :custom
  (lsp-keymap-prefix "C-c i")
  :commands (lsp lsp-deferred)
  :hook
  (lsp-mode-hook . lsp-enable-which-key-integration) ;enable which-key integration
  :config (progn
            ;; use flycheck, not flymake
            (setq lsp-prefer-flymake nil)
	    ;; lsp needs to read large amounts of data
	    (setq read-process-output-max (* 1024 1024))))

;; optional - provides fancy overlay information
(use-package lsp-ui
  :after lsp-mode
  :commands lsp-ui-mode
  :config (progn
            ;; disable inline documentation
            ;; (setq lsp-ui-sideline-enable nil)
            ;; disable showing docs on hover at the top of the window
            ;; (setq lsp-ui-doc-enable nil)
	    )
  )

;; lsp-booster: download and/or compile exe from https://github.com/blahgeek/emacs-lsp-booster

(defun lsp-booster--advice-json-parse (old-fn &rest args)
  "Try to parse bytecode instead of json."
  (or
   (when (equal (following-char) ?#)
     (let ((bytecode (read (current-buffer))))
       (when (byte-code-function-p bytecode)
         (funcall bytecode))))
   (apply old-fn args)))
(advice-add (if (progn (require 'json)
                       (fboundp 'json-parse-buffer))
                'json-parse-buffer
              'json-read)
            :around
            #'lsp-booster--advice-json-parse)

(defun lsp-booster--advice-final-command (old-fn cmd &optional test?)
  "Prepend emacs-lsp-booster command to lsp CMD."
  (let ((orig-result (funcall old-fn cmd test?)))
    (if (and (not test?)                             ;; for check lsp-server-present?
             (not (file-remote-p default-directory)) ;; see lsp-resolve-final-command, it would add extra shell wrapper
             lsp-use-plists
             (not (functionp 'json-rpc-connection))  ;; native json-rpc
             (executable-find "emacs-lsp-booster"))
        (progn
          (when-let ((command-from-exec-path (executable-find (car orig-result))))  ;; resolve command from exec-path (in case not found in $PATH)
            (setcar orig-result command-from-exec-path))
          (message "Using emacs-lsp-booster for %s!" orig-result)
          (cons "emacs-lsp-booster" orig-result))
      orig-result)))
(advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command)

(use-package company
  :diminish company-mode
  :config (progn
            ;; don't add any dely before trying to complete thing being typed
            ;; the call/response to gopls is asynchronous so this should have little
            ;; to no affect on edit latency
            (setq company-idle-delay 0)
            ;; start completing after a single character instead of 3
            (setq company-minimum-prefix-length 1)
            ;; align fields in completions
            (setq company-tooltip-align-annotations t))
  :hook ((prog-mode-hook . company-mode)
	 (message-mode-hook . company-mode)))

;; optional package to get the error squiggles as you edit
(use-package flycheck
  :hook ((prog-mode-hook . flycheck-mode)))

(use-package vue-mode)

(use-package typescript-mode)

(use-package lsp-java :config (add-hook 'java-mode-hook 'lsp))

;;; golang
(use-package go-mode
  :bind (
         ;; If you want to switch existing go-mode bindings to use lsp-mode/gopls instead
         ;; uncomment the following lines
         ("C-c C-j" . lsp-find-definition)
         ("C-c C-d" . lsp-describe-thing-at-point))
  :hook ((go-mode-hook . lsp-deferred))
  :init (add-hook 'go-mode-hook
		  (lambda ()
		    (add-hook 'before-save-hook 'lsp-format-buffer 0 t)
		    (add-hook 'before-save-hook 'lsp-organize-imports 0 t))))

;; fsharp
(use-package fsharp-mode
  :hook ((fsharp-mode-hook . lsp-deferred)))

(use-package keyfreq
  :config
  (setq keyfreq-excluded-commands
	'(self-insert-command
	  abort-recursive-edit
	  forward-char
	  backward-char
	  previous-line
	  next-line
	  left-char
	  right-char
	  lsp-ui-doc--handle-mouse-movement
	  helm-next-line))
  :init
  (keyfreq-mode 1)
  (keyfreq-autosave-mode 1))

(when (eq system-type 'windows-nt)
  (defun rod-open-pdf-in-sumatra ()
    "Open current buffer in system's default PDF reader."
    (interactive)
    (let (($path (if (buffer-file-name) (buffer-file-name) (expand-file-name default-directory ) )))
      (let ((proc (start-process "sumatra" nil (rod-concat-userprofile-dir "AppData/Local/SumatraPDF/SumatraPDF.exe") $path)))
	(set-process-query-on-exit-flag proc nil)))))

(use-package elfeed
  :commands elfeed-add-feed)

;; (defun rod-finish ()
;;   "Put \" at the end of line"
;;   (interactive)
;;   (while (not (eobp))
;;     (move-end-of-line nil)
;;     (insert "\"")
;;     (next-line)))

(defun rod-day-difference (a b)
  "Return number of days between two dates A and B."
  (/ (float-time (time-subtract
		  (parse-iso8601-time-string a)
		  (parse-iso8601-time-string b)))
     86400))

(defun rod-insert-en-dash ()
  "Insert en dash."
  (interactive)
  (insert "–"))

(defun rod-insert-pdflatex-command ()
  "Insert pdflatex command with my favourite parameters."
  (interactive)
  (insert "latexmk -pdf --synctex=1 -interaction=nonstopmode -file-line-error "))

(use-package solaire-mode
  :init
  (solaire-mode))

(use-package expand-region
  :bind ("C-=" . er/expand-region))

(use-package hideshow
  :diminish hs-minor-mode
  :bind (:map hs-minor-mode-map
	      ("\C-c@h" .     'hs-hide-block)
	      ("\C-c@s" .     'hs-show-block)
	      ("\C-c@\M-h" .   'hs-hide-all)
	      ("\C-c@\M-s" .  'hs-show-all)
	      ("\C-c@l" .     'hs-hide-level)
	      ("\C-c@c" .     'hs-toggle-hiding)
	      ("\C-c@f" .     'hs-toggle-hiding) ; mnemonic - fold
	      ("\C-c TAB" .     'hs-toggle-hiding)
	      ("<C-tab>" .     'hs-toggle-hiding) ; experimenting with different
						 ; keybindings
	      ("\C-c@a" .     'hs-show-all)
	      ("\C-c@t" .     'hs-hide-all)
	      ("\C-c@d" .     'hs-hide-block)
	      ("\C-c@e" .     'hs-toggle-hiding)))

(winner-mode t)

;; (use-package centaur-tabs
  ;; :config
  ;; (setq centaur-tabs-style "bar"
	;; centaur-tabs-height 32
	;; centaur-tabs-set-icons t
	;; centaur-tabs-set-modified-marker t
	;; centaur-tabs-show-navigation-buttons t
	;; centaur-tabs-set-bar 'under
	;; x-underline-at-descent-line t))

;; magit
(setq-default magit-revert-buffers 1)

;; my own packages and modes
(add-to-list 'load-path (concat user-emacs-directory "site-lisp/music-notes"))
(use-package music-notes
  :ensure nil)

(add-to-list 'load-path (concat user-emacs-directory "site-lisp/snow.el"))
(use-package snow
  :ensure nil)

(use-package everything
  :ensure nil)

(add-to-list 'load-path (concat user-emacs-directory "site-lisp/consult-everything"))
(use-package consult-everything
  :ensure nil
  :if (eq system-type 'windows-nt))
  ;; :config
  ;; (general-define-key ; set key in Normal state for Evil users.
   ;; :states 'normal
   ;; "SPC L" 'consult-everything))

(use-package dired+
  :ensure nil)

(use-package evil
  ;; Tutorial: how to use toggle-input-method in evil-mode. You don't have to do
  ;; anything! Insert mode of evil will automatically take the input method that
  ;; was set in Emacs mode. So as long as you have input method set to
  ;; slovak-qwerty in evil insert mode, make sure that input method is toggled in
  ;; Emacs mode and you don't have to add hook for it.
  :config
  (evil-set-initial-state 'calendar-mode 'emacs)
  (setq evil-default-state 'normal
	evil-symbol-word-search t))

(use-package evil-org
  :ensure t
  :after (evil org)
  :diminish evil-org-mode
  :hook ((org-mode-hook . evil-org-mode)
	 (org-agenda-mode-hook . evil-org-mode))
  :config
  (require 'evil-org-agenda)
  (evil-org-set-key-theme
   '(navigation insert return textobjects additional calendar))
  (evil-org-agenda-set-keys))

;; faster scrolling in long lines
;; (setq bidi-paragraph-direction 'left-to-right)
(setq bidi-paragraph-direction nil)
(setq bidi-inhibit-bpa nil)

;; customized slovak-qwerty that's not included with Emacs
(register-input-method
 "slovak-qwerty" "Slovak" 'quail-use-package
 "SK" "Slovak QWERTY keyboard."
 "slovak")

;; (add-to-list 'load-path (concat user-emacs-directory "site-lisp/audit"))
;; (use-package audit)

;; setting up bash from
;; https://www.masteringemacs.org/article/running-shells-in-emacs-overview
;; 2022-02-09: Because calibredb needs windows shell (it uses
;; `shell-quote-argument'), I have temporarily commented some of these lines
;; out. This should be fixable later.
;; List of packages that use it also:
;; - projectile
;; - auctex (preview, tex-buf)
;; - with-editor
;; - python-docstring
;; - ripgrep
;; - org-roam
;; - pdf-tools
;; - org-ref
;; - polymode (core, export, weave)
;; - org-pomodoro
;; - msvc (env)
;; - go-mode
;; - ggtags
;; - fd-dired
;; - flycheck
;; - helm (externals, id-utils, grep, git, files, locate, net)
;; - org (org, ob-plantuml, ox-groff, ox-taskjuggler, attach-git, macs, mobile,
;;        ox-latex, ox-odt)
;; - lsp-mode (mode, php)
;; - disaster
;; - lsp-mode
;; - counsel
;; - calibredb (utils, ivy, core)
;; - magit (process)
;; -
;; (setq shell-file-name "bash")
;; (setq explicit-shell-file-name "bash")
(setq explicit-bash-args '("--noediting" "--login" "-i"))
(setq explicit-bash.exe-args '("--noediting" "--login" "-i"))
;; (setenv "SHELL" shell-file-name)
;; (add-hook 'comint-output-filter-functions 'comint-strip-ctrl-m)

;; for shell to work
;; https://github.com/d5884/fakecygpty/

;; commented out on 2022-02-09 (see above)
;; (require 'fakecygpty)
;; (fakecygpty-activate)

;; (require 'cygwin-mount)
;; (cygwin-mount-activate)


;; git-package to easily install packages from git repositories
;; (use-package git-package
  ;; :ensure t
  ;; :config
;; (git-package-setup-use-package))

(use-package calibredb
  :defer t
  :config
  (setq calibredb-db-dir (expand-file-name "metadata.db" calibredb-root-dir))
  (when (eq system-type 'windows-nt)
    (setq calibredb-root-dir (rod-concat-userprofile-dir "Calibre Library"))))

(use-package slime
  :commands slime-mode
  :init
  (progn
    (setq slime-contribs '(slime-asdf
                           slime-fancy
                           slime-indentation
                           slime-sbcl-exts
                           slime-scratch)
          inferior-lisp-program "sbcl")
    ;; enable fuzzy matching in code buffer and SLIME REPL
    (setq slime-complete-symbol*-fancy t)
    (setq slime-complete-symbol-function 'slime-fuzzy-complete-symbol)))

(use-package esup
  :ensure t)

(use-package pylookup
  :ensure nil
  :load-path "site-lisp/pylookup"
  :commands pylookup-lookup)

;; for repeating commands like C-x o
(use-package repeat
  :ensure nil
  ;; For some reason, repeat has to be started in a hook, otherwise it doesn't
  ;; work (looks enabled, but keybindings don't repeat)
  :hook (after-init-hook . repeat-mode)
  :config
  (setq repeat-on-final-keystroke t))

(use-package autorevert
  :ensure nil
  :diminish auto-revert-mode)

(require 'good-scroll)
(use-package good-scroll
  :bind (
	 ;; ([next] . good-scroll-up-full-screen)
	 ;; ([prior] . good-scroll-down-full-screen)
	 ([next] . scroll-up-command)
	 ([prior] . scroll-down-command)
	 ))

(use-package emacs
  :ensure nil
  :custom
  ;; https://www.masteringemacs.org/article/improving-performance-emacs-display-engine
  ;; https://www.reddit.com/r/emacs/comments/8sw3r0/finally_scrolling_over_large_images_with_pixel/
  ;; https://www.reddit.com/r/emacs/comments/9rwb4h/why_does_fast_scrolling_freeze_the_screen/
  ;; https://emacs.stackexchange.com/questions/10354/smooth-mouse-scroll-for-inline-images
  ;; https://emacs.stackexchange.com/questions/28736/emacs-pointcursor-movement-lag
  ;; (next-screen-context-lines       2) ;; Number of lines of continuity to retain when scrolling by full screens
  ;; (scroll-conservatively       10000) ;; only 'jump' when moving this far off the screen
  ;; (scroll-step                     1) ;; Keyboard scroll one line at a time
  (mouse-wheel-progressive-speed nil) ;; Don't accelerate scrolling
  ;; (mouse-wheel-follow-mouse        t) ;; Scroll window under mouse
  (fast-but-imprecise-scrolling    t) ;; No (less) lag while scrolling lots.
  ;; (auto-window-vscroll           nil) ;; Cursor move faster
  )

;; Press C-SPC repeatedly after C-u C-SPC
(setq set-mark-command-repeat-pop t)

;; don't show empty line indicators (looks prettier) (modern-feature)
(setq-default indicate-empty-lines nil)

;; (setq debug-on-error nil)

;; END OF CONFIG
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Info-additional-directory-list '("C:\\tools\\cygwin\\usr\\share\\info"))
 '(LaTeX-command "latex -shell-escape")
 '(LaTeX-indent-environment-list
   '(("verbatim" current-indentation) ("verbatim*" current-indentation)
     ("filecontents" current-indentation) ("filecontents*" current-indentation)
     ("tabular" LaTeX-indent-tabular) ("tabular*" LaTeX-indent-tabular)
     ("array" LaTeX-indent-tabular) ("eqnarray" LaTeX-indent-tabular)
     ("eqnarray*" LaTeX-indent-tabular) ("align" LaTeX-indent-tabular)
     ("align*" LaTeX-indent-tabular) ("aligned" LaTeX-indent-tabular)
     ("alignat" LaTeX-indent-tabular) ("alignat*" LaTeX-indent-tabular)
     ("alignedat" LaTeX-indent-tabular) ("xalignat" LaTeX-indent-tabular)
     ("xalignat*" LaTeX-indent-tabular) ("xxalignat" LaTeX-indent-tabular)
     ("flalign" LaTeX-indent-tabular) ("flalign*" LaTeX-indent-tabular)
     ("split" LaTeX-indent-tabular) ("matrix" LaTeX-indent-tabular)
     ("pmatrix" LaTeX-indent-tabular) ("bmatrix" LaTeX-indent-tabular)
     ("Bmatrix" LaTeX-indent-tabular) ("vmatrix" LaTeX-indent-tabular)
     ("Vmatrix" LaTeX-indent-tabular) ("smallmatrix" LaTeX-indent-tabular)
     ("cases" LaTeX-indent-tabular) ("matrix*" LaTeX-indent-tabular)
     ("pmatrix*" LaTeX-indent-tabular) ("bmatrix*" LaTeX-indent-tabular)
     ("Bmatrix*" LaTeX-indent-tabular) ("vmatrix*" LaTeX-indent-tabular)
     ("Vmatrix*" LaTeX-indent-tabular) ("smallmatrix*" LaTeX-indent-tabular)
     ("psmallmatrix" LaTeX-indent-tabular)
     ("psmallmatrix*" LaTeX-indent-tabular)
     ("bsmallmatrix" LaTeX-indent-tabular)
     ("bsmallmatrix*" LaTeX-indent-tabular)
     ("vsmallmatrix" LaTeX-indent-tabular)
     ("vsmallmatrix*" LaTeX-indent-tabular)
     ("Vsmallmatrix" LaTeX-indent-tabular)
     ("Vsmallmatrix*" LaTeX-indent-tabular) ("dcases" LaTeX-indent-tabular)
     ("dcases*" LaTeX-indent-tabular) ("rcases" LaTeX-indent-tabular)
     ("rcases*" LaTeX-indent-tabular) ("drcases" LaTeX-indent-tabular)
     ("drcases*" LaTeX-indent-tabular) ("cases*" LaTeX-indent-tabular)
     ("displaymath") ("equation") ("picture") ("tabbing") ("gather")
     ("gather*") ("gathered") ("equation*") ("multline") ("multline*")
     ("macrocode") ("macrocode*") ("algorithmic" current-indentation)) nil nil "Package algorithms is not supported, therefore I had to turn off indentation for algorithmic.")
 '(TeX-electric-math '("\\(" . "\\)"))
 '(TeX-source-correlate-mode t)
 '(TeX-view-program-selection
   '(((output-dvi style-pstricks) "dvips and start") (output-dvi "Yap")
     (output-pdf "PDF Tools") (output-html "start")))
 '(all-the-icons-dired-monochrome nil)
 '(ansi-term-color-vector
   [unspecified "#fafafa" "#ca1243" "#50a14f" "#c18401" "#4078f2" "#a626a4"
		"#4078f2" "#383a42"] t)
 '(bbdb-message-all-addresses t)
 '(bbdb-mua-interactive-action '(create . query))
 '(bbdb-mua-pop-up nil)
 '(blacken-line-length 'fill)
 '(blacken-skip-string-normalization t)
 '(calendar-time-display-form
   '(24-hours ":" minutes (if time-zone " (") time-zone (if time-zone ")")))
 '(calendar-view-holidays-initially-flag t)
 '(calibredb-ids-width 10)
 '(column-number-mode t)
 '(comint-move-point-for-output 'all)
 '(completion-cycle-threshold 5)
 '(completion-styles '(basic partial-completion substring initials))
 '(custom-safe-themes t)
 '(default-input-method "slovak-qwerty")
 '(dired-dwim-target 'dired-dwim-target-recent)
 '(dired-listing-switches "-agGFhlvD")
 '(dired-recursive-copies 'always)
 '(display-battery-mode t)
 '(dynamic-completion-mode t)
 '(ef-themes-variable-pitch-ui t)
 '(electric-indent-mode t)
 '(electric-pair-mode nil)
 '(elfeed-search-date-format '("%y-%m-%d %H:%M" 14 :left))
 '(elfeed-search-filter "@6-months-ago")
 '(epg-debug t)
 '(epg-passphrase-coding-system 'utf-8)
 '(eshell-cmpl-use-paring nil)
 '(ffap-file-name-with-spaces t)
 '(file-name-at-point-functions nil nil nil "Slows down helm, all fhook functions disabled 2023-05-02")
 '(global-hl-line-sticky-flag t)
 '(gnus-prompt-before-saving t)
 '(gnus-search-use-parsed-queries t nil nil "To easily search using GG. Use from:, body:, recipient:, attachment:, before:, after:.")
 '(gnus-summary-line-format "%U%R%z%I%(%[%D: %-23,23f%]%) %s\12")
 '(helm-M-x-always-save-history t)
 '(helm-M-x-reverse-history nil)
 '(helm-M-x-show-short-doc t)
 '(helm-adaptive-mode t)
 '(helm-autoresize-mode t)
 '(helm-candidate-number-limit 50)
 '(helm-org-ignore-autosaves t)
 '(httpd-port 8081)
 '(ignored-local-variable-values
   '((eval font-lock-add-keywords nil
	   `
	   ((,(concat "("
		      (regexp-opt
		       '("sp-do-move-op" "sp-do-move-cl" "sp-do-put-op"
			 "sp-do-put-cl" "sp-do-del-op" "sp-do-del-cl")
		       t)
		      "\\_>")
	     1 'font-lock-variable-name-face)))))
 '(image-dired-cmd-create-thumbnail-options
   '("convert" "-size" "%wx%h" "%f[0]" "-resize" "%wx%h>" "-strip" "jpeg:%t"))
 '(image-dired-cmd-create-thumbnail-program "magick")
 '(image-dired-thumb-relief 0)
 '(image-use-external-converter t)
 '(insert-shebang-ignore-extensions '("txt" "org" "el" "py" "php"))
 '(ivy-height 20)
 '(ivy-hooks-alist '((t . toggle-input-method)))
 '(kill-do-not-save-duplicates t)
 '(kill-ring-max 120)
 '(line-number-mode t)
 '(lsp-enable-indentation nil)
 '(lsp-progress-spinner-type 'vertical-rising)
 '(lsp-ruff-server-command '("ruff" "server" "--preview"))
 '(magic-latex-enable-block-align nil)
 '(magic-latex-enable-pretty-symbols t)
 '(magit-copy-revision-abbreviated t)
 '(markdown-max-image-size '(700))
 '(mode-line-format
   '("%e" mode-line-front-space mode-line-mule-info mode-line-client
     mode-line-modified mode-line-remote mode-line-frame-identification
     mode-line-buffer-identification "   " mode-line-position
     evil-mode-line-tag (vc-mode vc-mode) "  " mode-line-modes
     mode-line-misc-info mode-line-end-spaces))
 '(native-comp-async-jobs-number 2)
 '(neo-smart-open t t)
 '(org-M-RET-may-split-line '((default)))
 '(org-agenda-compact-blocks nil)
 '(org-agenda-time-grid
   '((daily weekly today require-timed remove-match)
     (600 700 800 830 900 930 1000 1030 1100 1130 1200 1230 1300 1330 1400 1430
	  1500 1530 1600 1630 1700 1730 1800 1830 1900 2000 2100 2200 2300)
     "......" "----------------"))
 '(org-babel-python-command "py")
 '(org-capture-use-agenda-date t)
 '(org-clock-report-include-clocking-task t)
 '(org-confirm-babel-evaluate nil)
 '(org-expiry-inactive-timestamps t)
 '(org-export-in-background nil)
 '(org-file-apps
   '((auto-mode . emacs) (directory . emacs) ("\\.mm\\'" . default)
     ("\\.x?html?\\'" . default) ("\\.pdf\\'" . emacs)))
 '(org-fontify-done-headline nil)
 '(org-fontify-todo-headline nil)
 '(org-format-latex-options
   '(:foreground default :background default :scale 2.0 :html-foreground "Black"
		 :html-background "Transparent" :html-scale 1.0 :matchers
		 ("begin" "$1" "$" "$$" "\\(" "\\[")))
 '(org-html-doctype "html5")
 '(org-html-head-include-scripts t)
 '(org-html-html5-fancy t)
 '(org-html-with-latex 'mathjax)
 '(org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id)
 '(org-image-actual-width '(450))
 '(org-latex-engraved-preamble
   "\\usepackage{fvextra}\12\12[FVEXTRA-SETUP]\12\12% Make line numbers smaller and grey.\12\\renewcommand\\theFancyVerbLine{\\footnotesize\\color{black!40!white}\\arabic{FancyVerbLine}}\12\12\\usepackage{xcolor}\12\12% In case engrave-faces-latex-gen-preamble has not been run.\12\\providecolor{EfD}{HTML}{f7f7f7}\12\\providecolor{EFD}{HTML}{28292e}\12\12% Define a Code environment to prettily wrap the fontified code.\12\\usepackage[breakable,xparse]{tcolorbox}\12\\DeclareTColorBox[]{Code}{o}%\12{colback=EfD!98!EFD, colframe=EfD!95!EFD,\12  fontupper=\\tiny\\setlength{\\fboxsep}{0pt},\12  colupper=EFD,\12  IfNoValueTF={#1}%\12  {boxsep=2pt, arc=2.5pt, outer arc=2.5pt,\12    boxrule=0.5pt, left=2pt}%\12  {boxsep=2.5pt, arc=0pt, outer arc=0pt,\12    boxrule=0pt, leftrule=1.5pt, left=0.5pt},\12  right=2pt, top=1pt, bottom=0.5pt,\12  breakable}\12\12[LISTINGS-SETUP]")
 '(org-latex-pdf-process
   '("%latex -interaction nonstopmode -shell-escape -output-directory %o %f"
     "%latex -interaction nonstopmode -shell-escape -output-directory %o %f"
     "%latex -interaction nonstopmode -shell-escape -output-directory %o %f"))
 '(org-latex-src-block-backend 'engraved)
 '(org-latex-tables-booktabs t)
 '(org-log-into-drawer t)
 '(org-man-command 'woman)
 '(org-mru-clock-how-many 80)
 '(org-pomodoro-keep-killed-pomodoro-time t)
 '(org-pomodoro-long-break-length 15)
 '(org-pomodoro-manual-break t)
 '(org-refile-use-outline-path t)
 '(org-roam-file-exclude-regexp "\\.gpg$")
 '(org-src-lang-modes
   '(("C" . c) ("C++" . c++) ("asymptote" . asy) ("bash" . sh) ("beamer" . latex)
     ("calc" . fundamental) ("cpp" . c++) ("conf" . conf) ("ditaa" . artist)
     ("desktop" . conf-desktop) ("dot" . fundamental) ("elisp" . emacs-lisp)
     ("ocaml" . tuareg) ("screen" . shell-script) ("shell" . sh)
     ("sqlite" . sql) ("toml" . conf-toml)))
 '(org-src-preserve-indentation t)
 '(org-stuck-projects
   '("+project/-MAYBE-DONE" ("TODO" "NEXT" "NEXTACTION") nil ""))
 '(org-tags-exclude-from-inheritance '("crypt" "project"))
 '(org-trello-current-prefix-keybinding "C-c o")
 '(org-use-speed-commands t)
 '(org-use-sub-superscripts '{})
 '(package-menu-async nil)
 '(package-selected-packages
   '(all-the-icons astro-ts-mode auctex-latexmk blacken calfw calfw-org calibredb
		   cargo chronos company counsel deft diminish dired-recent
		   doom-themes drag-stuff edit-server ein elfeed ellama
		   engrave-faces esup evil-numbers evil-org expand-region
		   flycheck-rust fsharp-mode general gh-md gnus-notes go-mode
		   good-scroll gptel helm-bibtex helm-lsp helm-org
		   helm-org-rifle insert-shebang keyfreq lsp-java lsp-latex
		   lsp-ui lua-mode magic-latex-buffer magit modus-themes
		   name-this-color nasm-mode neotree nerd-icons-dired notmuch
		   org-contrib org-journal org-mime org-modern org-mru-clock
		   org-pdftools org-pomodoro org-present org-ref org-remark
		   org-roam-timestamps org-roam-ui org-tidy org-trello
		   org-web-tools php-mode pip-requirements pipenv pippel
		   pkg-info popup projectile py-isort pydoc pyenv-mode
		   python-docstring quickrun rg ron-mode rust-mode rustic
		   saveplace-pdf-view slime smartparens smtpmail-multi
		   solaire-mode sphinx-doc svelte-mode toml-mode
		   typescript-mode use-package valign vmd-mode vue-mode
		   which-key window-purpose x86-lookup yaml-mode
		   yasnippet-snippets))
 '(pdf-view-continuous t)
 '(pdf-view-selection-style 'glyph)
 '(projectile-indexing-method 'alien)
 '(projectile-sort-order 'recentf)
 '(projectile-use-git-grep t)
 '(python-fill-docstring-style 'pep-257-nn)
 '(python-skeleton-autoinsert t)
 '(request-backend 'url-retrieve)
 '(ring-bell-function 'ignore)
 '(safe-local-variable-values
   '((vc-prepare-patches-separately) (diff-add-log-use-relative-names . t)
     (vc-git-annotate-switches . "-w")))
 '(save-interprogram-paste-before-kill t)
 '(search-default-mode 'char-fold-to-regexp)
 '(search-whitespace-regexp "[ \11\15\12]+")
 '(sgml-tag-alist
   '(("![" ("ignore" t) ("include" t)) ("!attlist") ("!doctype") ("!element")
     ("!entity") ("code")))
 '(smtpmail-debug-verb t)
 '(solaire-mode-auto-swap-bg nil)
 '(spacemacs-theme-comment-italic t)
 '(spacemacs-theme-keyword-italic t)
 '(spacemacs-theme-org-agenda-height t)
 '(spacemacs-theme-org-highlight t)
 '(tags-revert-without-query t)
 '(tooltip-frame-parameters
   '((name . "tooltip") (internal-border-width . 4) (border-width . 1)
     (no-special-glyphs . t)))
 '(visible-bell t)
 '(warning-suppress-types '((comp)))
 '(which-key-idle-delay 0.4)
 '(which-key-is-verbose t)
 '(which-key-mode t)
 '(which-key-side-window-max-height 0.5)
 '(whitespace-line-column 72)
 '(windmove-default-keybindings '([f2]))
 '(woman-fill-column 70)
 '(yas-indent-line 'fixed))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(fixed-pitch ((t (:inherit default))))
 '(helm-M-x-short-doc ((t (:foreground "DimGray"))))
 '(helm-candidate-number ((((class color) (min-colors 256)) :background "#bfc9ff" :foreground "#000000")))
 '(helm-ff-directory ((((class color) (min-colors 256)) :foreground "#00d3d0")))
 '(helm-ff-dotted-directory ((((class color) (min-colors 256)) :foreground "#c6daff")))
 '(helm-ff-executable ((((class color) (min-colors 256)) :foreground "#ffffff" :inherit italic)))
 '(helm-ff-file ((((class color) (min-colors 256)) :foreground "#ffffff")))
 '(helm-ff-prefix ((((class color) (min-colors 256)) :foreground "#b6a0ff")))
 '(helm-grep-file ((((class color) (min-colors 256)) :foreground "#feacd0")))
 '(helm-grep-finish ((((class color) (min-colors 256)) :foreground "#6ae4b9")))
 '(helm-grep-lineno ((((class color) (min-colors 256)) :foreground "#c6daff")))
 '(helm-grep-match ((((class color) (min-colors 256)) :foreground "#b6a0ff" :distant-foreground "#ff7f9f")))
 '(helm-lisp-show-completion ((((class color) (min-colors 256)) :background "#c0e7d4")))
 '(helm-locate-finish ((((class color) (min-colors 256)) :foreground "#44bc44")))
 '(helm-match ((((class color) (min-colors 256)) :inherit bold :foreground "#b6a0ff" :distant-foreground "#ffffff")))
 '(helm-moccur-buffer ((((class color) (min-colors 256)) :inherit link)))
 '(helm-selection ((((class color) (min-colors 256)) :inherit bold :background "#2f3849" :extend t :distant-foreground "#b6a0ff")))
 '(helm-separator ((((class color) (min-colors 256)) :foreground "#972500")))
 '(helm-source-header ((((class color) (min-colors 256)) :background "#303030" :foreground "#b6a0ff" :weight bold)))
 '(helm-visible-mark ((((class color) (min-colors 256)) :inherit (bold highlight))))
 '(holiday ((((class color) (min-colors 256)) :background "#f8e6f5" :foreground "#8f0075")))
 '(mode-line ((((class color) (min-colors 256)) :box (:line-width 3 :color "#ccdfff"))))
 '(mode-line-inactive ((((class color) (min-colors 256)) :box (:line-width 3 :color "#e6e6e6"))))
 '(org-agenda-date-today ((((class color) (min-colors 256)) :inherit org-agenda-date :background "#ecedff" :underline nil)))
 '(org-modern-label ((t (:box (:line-width (-3 . 1) :color "#ffffff") :underline nil :weight regular :width condensed))))
 '(tooltip ((((class color) (min-colors 256)) :background "#ccdfff" :foreground "#000000")))
 '(variable-pitch ((t (:family "IBM Plex Sans")))))
(put 'narrow-to-region 'disabled nil)
(put 'scroll-left 'disabled nil)
(put 'list-timers 'disabled nil)
(put 'erase-buffer 'disabled nil)

;; Modus has to be configured after custom-set-faces. Otherwise custom-set-faces
;; overrides configuration of modus-themes.

(require 'modus-themes)

;; modus-themes provide much better readability and support of modes than any
;; other theme currently available. Thank you Prot!
;;
(use-package modus-themes
  :config
  (setq modus-themes-bold-constructs t
	modus-themes-completions '((matches) (selection))
	modus-themes-headings '((1 rainbow))
	modus-themes-italic-constructs t
	modus-themes-mixed-fonts t
	modus-themes-variable-pitch-ui t)
  (setq modus-themes-common-palette-overrides
	`(
	  ;; From the section "Make the mode line borderless"
          (border-mode-line-active unspecified)
          (border-mode-line-inactive unspecified)

	  ;; Make the fringe invisible
	  (fringe unspecified)

	  ;; Remove underlines from links
	  (underline-link unspecified)
          (underline-link-visited unspecified)
          (underline-link-symbolic unspecified)

	  (bg-link bg-blue-nuanced)

	  ;; Here are contents of `modus-themes-preset-overrides-intense' copied
	  ;; here for manual adjustment:

	  (bg-region bg-cyan-intense)

	  (bg-completion       bg-cyan-subtle)
	  (bg-hover            bg-yellow-intense)
	  (bg-hover-secondary  bg-magenta-intense)
	  ;; (bg-hl-line          bg-cyan-subtle)

	  (bg-mode-line-active      bg-blue-subtle)
	  (fg-mode-line-active      fg-main)
	  ;; (border-mode-line-active  blue-intense)

	  ;; (fringe bg-inactive)
	  ;; (comment red-faint)

	  (date-common cyan)
	  (date-deadline red)
	  (date-event blue)
	  (date-holiday magenta-warmer)
	  (date-now blue-faint)
	  (date-scheduled yellow-warmer)
	  (date-weekday fg-main)
	  (date-weekend red-faint)

	  ;; (keybind blue-intense)

	  (mail-cite-0 blue)
	  (mail-cite-1 yellow)
	  (mail-cite-2 green)
	  (mail-cite-3 magenta)
	  (mail-part magenta-cooler)
	  (mail-recipient cyan)
	  (mail-subject red-warmer)
	  (mail-other cyan-cooler)

	  ;; (fg-prompt blue-intense)

	  (prose-block red-faint)
	  (prose-done green-intense)
	  (prose-metadata cyan-faint)
	  (prose-metadata-value blue-cooler)
	  (prose-table cyan)
	  (prose-todo red-intense)

	  (fg-heading-0 blue-cooler)
	  (fg-heading-1 magenta-cooler)
	  (fg-heading-2 magenta-warmer)
	  (fg-heading-3 blue)
	  (fg-heading-4 cyan)
	  (fg-heading-5 green-warmer)
	  (fg-heading-6 yellow)
	  (fg-heading-7 red)
	  (fg-heading-8 magenta)

	  (bg-tab-bar bg-main)
          (bg-tab-current bg-cyan-intense)
          (bg-tab-other bg-inactive)

	  ;; (bg-heading-0 unspecified)
	  ;; (bg-heading-1 bg-magenta-nuanced)
	  ;; (bg-heading-2 bg-red-nuanced)
	  ;; (bg-heading-3 bg-blue-nuanced)
	  ;; (bg-heading-4 bg-cyan-nuanced)
	  ;; (bg-heading-5 bg-green-nuanced)
	  ;; (bg-heading-6 bg-yellow-nuanced)
	  ;; (bg-heading-7 bg-red-nuanced)
	  ;; (bg-heading-8 bg-magenta-nuanced)

	  ;; (overline-heading-0 unspecified)
	  ;; (overline-heading-1 magenta-cooler)
	  ;; (overline-heading-2 magenta-warmer)
	  ;; (overline-heading-3 blue)
	  ;; (overline-heading-4 cyan)
	  ;; (overline-heading-5 green)
	  ;; (overline-heading-6 yellow-cooler)
	  ;; (overline-heading-7 red-cooler)
	  ;; (overline-heading-8 magenta)

	  ;; end of `modus-themes-preset-overrides-intense'

	  ;; ,@modus-themes-preset-overrides-intense
	  )
	modus-operandi-tinted-palette-overrides
	`(
	  (bg-mode-line-active      "#cab9b2")
	  ))
  (defun rod-modus-themes-custom-faces ()
    (modus-themes-with-colors
      (custom-set-faces
       ;; Make tooltips readable --RP
       `(tooltip ((,c :background ,bg-blue-subtle :foreground ,fg-main)))
       ;; Add "padding" to the mode lines
       `(mode-line ((,c :box (:line-width 3 :color ,bg-mode-line-active))))
       `(mode-line-inactive ((,c :box (:line-width 3 :color ,bg-mode-line-inactive))))
       ;;;; helm
       `(helm-selection              ((,c :inherit bold :background ,bg-hl-line :extend t :distant-foreground ,magenta-cooler)))
       `(helm-match                  ((,c :inherit bold :foreground ,magenta-cooler :distant-foreground ,fg-main)))
       `(helm-source-header          ((,c :background ,bg-inactive :foreground ,keyword :weight bold)))
       `(helm-visible-mark           ((,c :inherit (bold highlight))))
       `(helm-moccur-buffer          ((,c :inherit link)))
       `(helm-ff-file                ((,c :foreground ,fg-main)))
       `(helm-ff-prefix              ((,c :foreground ,keyword)))
       `(helm-ff-dotted-directory    ((,c :foreground ,fg-alt)))
       `(helm-ff-directory           ((,c :foreground ,variable)))
       `(helm-ff-executable          ((,c :foreground ,fg-main :inherit italic)))
       `(helm-grep-match             ((,c :foreground ,magenta-cooler :distant-foreground ,red-cooler)))
       `(helm-grep-file              ((,c :foreground ,fnname)))
       `(helm-grep-lineno            ((,c :foreground ,fg-alt)))
       `(helm-grep-finish            ((,c :foreground ,cyan-cooler)))
       `(helm-locate-finish          ((,c :foreground ,green)))
       `(helm-separator              ((,c :foreground ,red-warmer)))
       `(helm-candidate-number       ((,c :background ,bg-blue-intense :foreground ,fg-main)))
       `(helm-lisp-show-completion   ((,c :background ,bg-sage)))
       `(org-agenda-date-today       ((,c :inherit org-agenda-date :background ,bg-blue-nuanced :underline nil)))
       `(holiday ((,c :background ,bg-magenta-nuanced :foreground ,date-holiday)))
       )))

  ;; Hook doesn't work. Don't know why. Calling it explicitly after loading the
  ;; theme four lines below.
  ;;
  (add-hook 'modus-themes-after-load-theme-hook #'rod-modus-themes-custom-faces)
  (load-theme 'modus-vivendi :no-confim)
  (rod-modus-themes-custom-faces)
  )

;;; diminish

;; this was made before I started using use-package, so these have to be moved
;; later
(diminish 'ivy-posframe-mode)
(diminish 'drag-stuff-mode)
(diminish 'helm-ff-cache-mode)
(diminish 'eldoc-mode)
(diminish 'yas-minor-mode " y")
(diminish 'helm-mode)
(diminish 'auto-fill-function)

;; change garbage collection to a more suitable value (~50MB, spacemacs uses
;; ~100MB)
(setq gc-cons-threshold 50000000 gc-cons-percentage 0.1)

;; doom-modeline
;;(require 'doom-modeline)
;;(setq doom-modeline-height 10)
;;(setq doom-modeline-bar-width 6)
;;(setq doom-modeline-minor-modes t)
;;(doom-modeline-mode 1)

(let ((str
       (format "%s seconds"
	       (float-time
		(time-subtract (current-time) before-init-time)))))
  (message "Startup took %s. GC done %d times and took %f seconds. Ready." str gcs-done gc-elapsed))

(provide 'init)
;;; init.el ends here
