(setq user-full-name "Jason Graham"
      user-mail-address "jgraham20@gmail.com")

;;----------------------------------------------------------------------------
;; Adjust garbage collection thresholds during startup, and thereafter
;;----------------------------------------------------------------------------
(setq byte-compile-warnings '(not free-vars unresolved noruntime lexical make-local))

(eval-and-compile
 (setq gc-cons-threshold 402653184
       gc-cons-percentage 0.6))

(setq mac-option-modifier 'meta)
(setq mac-command-modifier 'super)
(setq mac-pass-command-to-system nil)
;;(setq server-socket-dir (expand-file-name "server" user-emacs-directory))

(eval-and-compile
  (setq load-prefer-newer t
      package-user-dir "~/.emacs.d/elpa"
      package--init-file-ensured t
      package-enable-at-startup nil)

(unless (file-directory-p package-user-dir)
  (make-directory package-user-dir t)))

(setq use-package-verbose t)

(eval-and-compile
  (setq load-path (append load-path (directory-files package-user-dir t "^[^.]" t))))

(eval-when-compile
  (require 'package)

 (unless (assoc-default "melpa" package-archives)
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t))
 (unless (assoc-default "melpa" package-archives)
 (add-to-list 'package-archives '("gnu"   . "http://elpa.gnu.org/packages/") t))
(unless (assoc-default "org" package-archives)
  (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t))


  (when (< emacs-major-version 27)
    (package-initialize))
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t))

(use-package delight
 :ensure t)

(use-package diminish)

(defun load-directory (dir)
  (let ((load-it (lambda (f)
         (load-file (concat (file-name-as-directory dir) f)))
       ))
  (mapc load-it (directory-files dir nil "\\.el$"))))

(load-directory "~/.emacs.d/lisp")

(scroll-bar-mode -1)
 (tool-bar-mode   -1)
 (tooltip-mode    -1)
 (menu-bar-mode   1)
 (desktop-save-mode 1)

 (set-default-font "PragmataPro 14")
 (add-to-list 'default-frame-alist '(font . "PragmataPro-14:spacing=100")) 
 (defun set-frame-size-according-to-resolution ()
  (interactive)
  (if window-system
  (progn
  ;; use 120 char wide window for largeish displays
  ;; and smaller 80 column windows for smaller displays
  ;; pick whatever numbers make sense for you
  (if (> (x-display-pixel-width) 1280)
         (add-to-list 'default-frame-alist (cons 'width 120))
         (add-to-list 'default-frame-alist (cons 'width 80)))
  ;; for the height, subtract a couple hundred pixels
  ;; from the screen height (for panels, menubars and
  ;; whatnot), then divide by the height of a char to
  ;; get the height we want
  (add-to-list 'default-frame-alist 
       (cons 'height (/ (- (x-display-pixel-height) 200)
                           (frame-char-height)))))))

   (set-frame-size-according-to-resolution)

 ;Set up the Fringe
 (define-fringe-bitmap 'tilde [64 168 16] nil nil 'center)
 (set-fringe-bitmap-face 'tilde 'fringe)  

 (use-package eyebrowse
  :ensure t
  :config 
   (eyebrowse-mode t))

 (use-package shackle
  :ensure t 
  :init
    (setq shackle-rules '((compilation-mode :noselect t))
          shackle-default-rule '(:select t))
    (setq helm-display-function 'pop-to-buffer) ; make helm play nice
    (setq shackle-rules '(("\\`\\*helm.*?\\*\\'" :regexp t :align t :size 0.4)))
  :config (shackle-mode)
 )

(use-package imenu-list
 :ensure t
 :demand t
 :config
 (setq imenu-list-focus-after-activation t)
 (general-define-key :keymaps 'imenu-list-major-mode-map
                     :states '(normal)
                     "|" 'imenu-list-minor-mode
                     "RET" 'imenu-list-goto-entry
                     "i" 'imenu-list-goto-entry
                     "q" 'imenu-list-quit-window)

 )

;; Vim mode
(use-package evil
  :ensure t
  :config
  (evil-mode 1))

(use-package evil-escape
  :ensure t
  :init
  (setq-default evil-escape-key-sequence "jk")
  :config
  (evil-escape-mode 1))
  
 (use-package evil-anzu
    :demand t
    :after (evil))

;; Theme

(use-package challenger-deep-theme
  :ensure t
  :init 
    (load-theme 'challenger-deep t))

 (use-package smart-mode-line
  :ensure t
  :init
   (setq sml/theme 'respectful)
   (setq sml/no-confirm-load-theme t)
   (sml/setup)
  :config
    (setq sml/shorten-directory t
          sml/shorten-modes t)
    (add-to-list 'sml/replacer-regexp-list '("^~/Notes/" ":org:"))
    (add-to-list 'sml/replacer-regexp-list '("^~/Dropbox/" ":DB:")))

(use-package ivy
         :ensure t
         :demand t
         :config
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;         (setq ivy-re-builders-alist '((t . ivy--regex-ignore-order)))		    ;;
 ;;         (define-key ivy-mode-map [escape] 'minibuffer-keyboard-quit)		    ;;
 ;;         (define-key ivy-minibuffer-map (kbd "C-i") 'ivy-call)			    ;;
 ;;         (define-key ivy-minibuffer-map (kbd "C-o") 'ivy-occur)			    ;;
 ;;       (general-define-key :keymaps '(ivy-occur-grep-mode-map)			    ;;
 ;;                           :states '(normal)						    ;;
 ;;                           "q" 'evil-delete-buffer)					    ;;
 ;;         (defvar pop-target-window)							    ;;
 ;;         (make-variable-buffer-local 'pop-target-window)				    ;;
 ;;         (advice-add 'compilation-goto-locus :around #'my-around-compilation-goto-locus) ;;
 ;;         (defun my-around-compilation-goto-locus (orig-func &rest args)		    ;;
 ;;           (advice-add 'pop-to-buffer :override #'my-pop-to-buffer)			    ;;
 ;;           (apply orig-func args))							    ;;
 ;;         (defun my-pop-to-buffer (buffer &optional action norecord)			    ;;
 ;;           (advice-remove 'pop-to-buffer #'my-pop-to-buffer)				    ;;
 ;;           (let ((from-buffer (current-buffer))					    ;;
 ;;                 (reused-window (display-buffer-reuse-window buffer nil)))		    ;;
 ;;             (cond (reused-window							    ;;
 ;;                    (select-window reused-window norecord))				    ;;
 ;;                   ((and (bound-and-true-p pop-target-window)			    ;;
 ;;                         (window-live-p pop-target-window))				    ;;
 ;;                    (window--display-buffer buffer pop-target-window 'reuse)		    ;;
 ;;                    (select-window pop-target-window norecord))			    ;;
 ;;                   (t								    ;;
 ;;                    (pop-to-buffer buffer action norecord)				    ;;
 ;;                    (with-current-buffer from-buffer					    ;;
 ;;                      (setq-local pop-target-window (selected-window)))))))		    ;;
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 (setq ivy-use-virtual-buffers t)							    
 (setq enable-recursive-minibuffers t)
 (setq ivy-count-format "(%d/%d) ")
 ;; Create and delete a view
 (global-set-key (kbd "C-c v") 'ivy-push-view)
 (global-set-key (kbd "C-c V") 'ivy-pop-view)
         (ivy-mode t))

 (use-package counsel
         :ensure t
         :demand t
         :config)

 (use-package swiper
         :ensure t
         :demand t
         :config
         (ivy-mode t))

 (use-package avy
         :ensure t
         :demand t
         :config
         (defun avy-line-saving-column ()
           (interactive)
           (let ((col (current-column)))
             (avy-goto-line)
             (move-to-column col)))
         )

(use-package all-the-icons-ivy
      :config
      (all-the-icons-ivy-setup))

     (use-package eyebrowse
      :ensure t)

(use-package helm
  :defer t
  :init
  (setq helm-M-x-fuzzy-match t
	helm-mode-fuzzy-match t
	helm-buffers-fuzzy-matching t
	helm-recentf-fuzzy-match t
	helm-locate-fuzzy-match t
	helm-semantic-fuzzy-match t
	helm-imenu-fuzzy-match t
	helm-completion-in-region-fuzzy-match t
	helm-candidate-number-list 150
	helm-split-window-in-side-p t
	helm-move-to-line-cycle-in-source t
	helm-echo-input-in-header-line t
	helm-autoresize-max-height 0
	helm-autoresize-min-height 20))

(use-package dired
   :ensure nil
   :defer t
   :bind* (("C-x d" . dired-other-window)
           ("C-x C-d" . dired))
   :commands (dired)
   :config
   (setq dired-use-ls-dired nil)
   (use-package dired-x
     :ensure nil
     :bind* (("C-x C-'" . dired-jump))
     :commands (dired-omit-mode)
     :init
     (add-hook 'dired-load-hook (lambda () (load "dired-x")))
     (add-hook 'dired-mode-hook #'dired-omit-mode)
     :config
     (setq dired-omit-verbose nil)
     (setq dired-omit-files
           (concat dired-omit-files "\\|^\\..*$\\|^.DS_Store$\\|^.projectile$\\|^.git$"))))

;;; Ranger:
(use-package ranger
  :ensure t
  :config
  (ranger-override-dired-mode t)
  (setq ranger-cleanup-on-disable t
        ranger-show-dotfiles nil
        ranger-show-literal nil))

(use-package ag
 :ensure t
 :defer t)

(use-package restart-emacs
  :ensure t
  :defer t
  :config (setq restart-emacs-restore-frames t))

(use-package simpleclip
 :ensure t
 :config 
  (simpleclip-mode 1))

;; Which Key
(use-package which-key
  :ensure t
  :init
  (setq which-key-separator " ")
  (setq which-key-prefix-prefix "+")
  :config
  (which-key-mode 1))

;; Custom keybinding
(use-package general
  :ensure t
  :config (general-define-key
  :states '(normal visual insert emacs)
  :prefix "SPC"
  :non-normal-prefix "M-SPC"
  "TAB" '(switch-to-prev-buffer :which-key "previous buffer")
  "/" '(swiper :which-key "Swiper")
  "SPC" '(counsel-M-x :which-key "M-x")
  ;;"pf"  '(helm-find-files :which-key "find files")
  ;; Magit
  "g" '(:ignore t :which-key "Git - Magit")
  "gs"  '(magit-status :which-key "magit status")
  ;; Buffers
  "b" '(:ignore t :which-key "Buffers")
  "bb"  '(ivy-switch-buffer :which-key "buffers list")
  "bd"  '(kill-this-buffer :which-key "kill buffer")
  ;; Counsel
  "c" '(:ignore t :which-key "Counsel")
  "cf" '(counsel-find-file :which-key "Counsel Find File")
  "cg" '(counsel-git :which-key "Counsel git")
  "cj" '(counsel-git-grep :which-key "Counsel git grep")
  "ck" '(counsel-ag :which-key "Counsel ag")
  "cl" '(counsel-locate :which-key "Counsel locate")
  "ch" '(counsel-minibuffer-history :which-key "Counsel History")
  "cv" '(counsel-push-view :which-key "Counsel Push View")
  "cV" '(counsel-pop-view :which-key "Counsel Pop View")
  ;; Undo
  "u" '(:ignore t :which-key "Undo")
  "uu" '(undo-tree-visualize :which-key "Undo Tree")
  ;; File
  "f" '(:ignore t :which-key "File")
  "fr"  '(ranger :which-key "open ranger")
  "fd"  '(dired :which-key "open dired")
  "ff"  '(counsel-find-file :which-key "find files")
  ;; Window
   "w" '(:ignore t :which-key "Windows")
  "wl"  '(windmove-right :which-key "move right")
  "wh"  '(windmove-left :which-key "move left")
  "wk"  '(windmove-up :which-key "move up")
  "wj"  '(windmove-down :which-key "move bottom")
  "w/"  '(split-window-right :which-key "split right")
  "w-"  '(split-window-below :which-key "split bottom")
  "wx"  '(delete-window :which-key "delete window")
  "wd"  '(delete-window :which-key "delete window")
  ;; Others
  "a" '(:ignore t :which-key "Applications")
  "at"  '(ansi-term :which-key "open terminal")
  "ao"  '(org-mode :which-key "org-mode")
  ;; Quit
  "q" '(:ignore t :which-key "Quit")
  "qq"  (general-simulate-key "C-u" :state 'restart-emacs) :which-key "restart -Q"))

(setq ns-use-proxy-icon  nil)
(setq frame-title-format nil)

(use-package aggressive-indent
  :ensure t
  :config)

(use-package company
:demand t
 :init
  (progn
    (setq company-idle-delay 0.2
          company-minimum-prefix-length 2
          company-require-match nil
          company-selection-wrap-around t
          company-dabbrev-ignore-case nil
          company-dabbrev-downcase nil))
 :config
 (global-company-mode)

 (define-key company-active-map [tab] 'company-complete)
 (define-key company-active-map (kbd "C-n") 'company-select-next)
 (define-key company-active-map (kbd "C-p") 'company-select-previous))

(use-package exec-path-from-shell
 :ensure t
 :init 
  (when (memq window-system '(mac ns x))
        (exec-path-from-shell-initialize)))

(use-package flycheck
 :ensure t
 :init (global-flycheck-mode))

;;; Magit
(use-package magit
  :config
  (require 'evil-magit))

(use-package evil-magit
  :after (magit))

(use-package diff-hl
  :ensure t
  :config
    (diff-hl-mode))

(use-package git-timemachine
  :ensure t)

(use-package yasnippet
:demand t
:config
(yas-global-mode 1))

;; Projectile
(use-package projectile
 :ensure t
 :delight '(:eval (concat "(P)" (projectile-project-name))) 
 :init
  (setq projectile-require-project-root nil)
  :config
  (projectile-mode 1))
;; All The Icons
(use-package all-the-icons :ensure t)

(use-package ibuffer :demand t)

(use-package undo-tree :ensure t)

(use-package smartparens
  :demand t
  :init
  (add-hook 'clojure-mode-hook 'turn-on-smartparens-strict-mode)
  (add-hook 'cide-clojure-interaction-mode-hook 'turn-on-smartparens-strict-mode)
  (add-hook 'lisp-interaction-mode-hook 'turn-on-smartparens-strict-mode)
  (add-hook 'cider-repl-mode-hook 'turn-on-smartparens-strict-mode)
  (add-hook 'emacs-lisp-mode-hook 'turn-on-smartparens-strict-mode)
  :config
  (setq sp-navigate-interactive-always-progress-point t)

  (sp-local-pair 'emacs-lisp-mode "'" nil :actions nil)
  (sp-local-pair 'clojure-mode "'" nil :actions nil)
  (sp-local-pair 'lisp-interaction-mode "'" nil :actions nil)
  (sp-local-pair 'clojure-interaction-mode "'" nil :actions nil)
  (sp-local-pair 'cider-repl-mode "'" nil :actions nil)


  (smartparens-global-mode 1)
  )

(use-package evil-smartparens
  :demand t
  :config)

(general-def 'normal
  ">" (general-key-dispatch 'evil-shift-right
        ")" 'sp-forward-slurp-sexp
        "(" 'sp-backward-barf-sexp)
  "<" (general-key-dispatch 'evil-shift-left
        ")" 'sp-forward-barf-sexp
        "(" 'sp-backward-slurp-sexp))

(use-package highlight-indent-guides
  :config
  (setq highlight-indent-guides-auto-character-face-perc 25)
  (setq highlight-indent-guides-method 'character)
  (add-hook 'prog-mode-hook 'highlight-indent-guides-mode))

;; NeoTree
(use-package neotree
  :ensure t
  :init
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow)))

;; Show matching parens
(setq show-paren-delay 0)
(show-paren-mode 1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (neotree projectile general which-key helm doom-themes evil-escape evil use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Disable backup files
(setq make-backup-files nil) ; stop creating backup~ files
(setq auto-save-default nil) ; stop creating #autosave# files

(setq org-id-link-to-org-use-id 'use-existing)
(setq org-startup-indented t)
(setq org-directory "~/Dropbox/Notes/")
(setq org-default-notes-file (concat org-directory "organizer.org"))
(setq org-imenu-depth 5)
(setq org-list-allow-alphabetical t)

(defun my/tangle-dotfiles ()
  "If the current file is in '~/.emacs.d', the code blocks are tangled"
  (when (equal (file-name-directory (directory-file-name buffer-file-name))
               (concat (getenv "HOME") "/.emacs.d/"))
    (org-babel-tangle)
    (message "%s tangled" buffer-file-name)))

(add-hook 'after-save-hook #'my/tangle-dotfiles)

(use-package ox-hugo
  :after ox)

(require 'org-protocol)
  (use-package s
   :ensure t)

  (defun make-capture-frame (&optional capture-url)
  "Create a new frame and run org-capture."
  (interactive)
  (make-frame '((name . "capture")
                (width . 120)
                (height . 15)))
  (select-frame-by-name "capture")
  (setq word-wrap 1)
  (setq truncate-lines nil)
  (if capture-url (org-protocol-capture capture-url) (org-capture)))

  (require 'org-protocol-capture-html)

  (defun jsg/org-captures() 
  (setq org-capture-templates
        '(("t" "Todo"
           entry (file+headline (lambda () (concat org-directory "organizer.org")) "Task List")
           "* TODO %?
  DEADLINE: %t
  :LOGBOOK:
  - State \"TODO\"       from \"\"           %U
  :END:
  see: %a\n")
          ("w" "Web site" 
          entry (file+headline "~/Notes/notes.org" "Links")
    "* %a :website:\n\n%U %?\n\n%:initial")
("W" "Web site"
 entry
 (file+olp "~/inbox.org" "Web")
 "* %c :website:\n%U %?%:initial")
("l" "A link, for reading later." entry
       (file+headline "notes.org" "Reading List")
       "* %:link\n%u\n\n%c\n\n%i"
       :empty-lines 1)
          ("n" "Note"
           entry (file+headline (lambda () (concat org-directory "organizer.org")) "Notes")
           "* %?
  %U\n%a\n")
          ("b" "Book" entry (file+headline (lambda () (concat org-directory "organizer.org")) "Books")
           "* %?
  (C-c C-w to refile to fiction/non-fiction)
  see %a
  entered on %U\n")
          ("q" "Clock (quick)" plain (clock)
           "%a%?\n")
          ("s" "Emacs tool sharpening"
           entry (file+olp (lambda () (concat org-directory "programming_notes.org"))
                           "Emacs"
                           "Sharpening list")
           "* %?
  see %a
  entered on %U\n")
          ("S" "General tool sharpening"
           entry (file+olp (lambda () (concat org-directory "programming_notes.org"))
                           "General sharpening")
           "* %?
  see %a
  entered on %U\n")
          ("d" "Date"
           entry (file+datetree+prompt (lambda () (concat org-directory "dates.org")))
           "* %?
  %t
  see %a\n")
          ("j" "Journal"
           plain (file+datetree (lambda () (concat org-directory "journal.org")))
           "**** <title>\n%U\n\n%?\n")
      ("p" "Protocol" entry (file+headline ,(concat org-directory "notes.org") "Inbox")
        "* %^{Title}\nSource: %u, %c\n #+BEGIN_QUOTE\n%i\n#+END_QUOTE\n\n\n%?")
          ("L" "Protocol Link" entry (file+headline ,(concat org-directory "notes.org") "Inbox")
        "* %? [[%:link][%:description]] \nCaptured On: %U")
          )
  ))

(use-package interleave
 :ensure t)

(setq org-enforce-todo-dependencies t)
(setq org-log-done 'time)
(setq org-log-note-clock-out nil)

(setq org-todo-keywords
      '((sequence "TODO(t!)" "WAIT(w@/!)" "|" "DONE(d!)" "CANCELED(c@!)")))
(setq org-log-into-drawer "LOGBOOK")

(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

;; from https://lists.gnu.org/archive/html/emacs-orgmode/2012-02/msg00515.html
(defun org-summary-checkboxes ()
  "Switch entry to DONE when all sub-checkboxes are done, to TODO otherwise."
  (save-excursion
    (org-back-to-heading t)
    (let ((beg (point)) end)
      (end-of-line)
      (setq end (point))
      (goto-char beg)
      (if (re-search-forward "\\[\\([0-9]*%\\)\\]\\|\\[\\([0-9]*\\)/\\([0-9]*\\)\\]" end t)
          (if (match-end 1)
              (if (equal (match-string 1) "100%")
                  (org-todo 'done)
                (org-todo 'todo))
            (if (and (> (match-end 2) (match-beginning 2))
                     (equal (match-string 2) (match-string 3)))
                (org-todo 'done)
              (org-todo 'todo)))))))

(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)
(add-hook 'org-checkbox-statistics-hook 'org-summary-checkboxes)

(defun jsg/org-sort-todos ()
  "Sort entries by TODO status"
  (interactive)
  (org-sort-entries nil ?o)
  (outline-hide-leaves))
(add-hook 'org-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c 6") 'jsg/org-sort-todos)))

(use-package org
  :demand
  :mode ("\\.org\\'" . org-mode)
  :diminish org-indent-mode
  :init
  (require 'org-indent)
  :config
  (setq org-completion-use-ido t
        org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-log-done t
        org-log-done-with-time t
        org-log-refile t
        org-support-shift-select t)

  (add-hook 'org-mode-hook 'auto-fill-mode))
 
(setq org-modules '(org-bbdb
                      org-gnus
                      org-drill
                      org-info
		      org-id
                      org-jsinfo
                      org-habit
                      org-irc
                      org-mouse
                      org-protocol
                      org-annotate-file
                      org-eval
                      org-expiry
                      org-interactive-query
                      org-man
                      org-collector
                      org-panel
                      org-screen
                      org-toc))
(eval-after-load 'org
 '(org-load-modules-maybe t))

 ;; Prepare stuff for org-export-backends
(setq org-export-backends '(org latex icalendar html ascii))

(bind-key "C-c c" 'org-capture)
(bind-key "C-c a" 'org-agenda)
(bind-key "C-c l" 'org-store-link)
(bind-key "C-c L" 'org-insert-link-global)
(bind-key "C-c O" 'org-open-at-point-global)
(bind-key "<f9> <f9>" 'org-agenda-list)
(bind-key "<f9> <f8>" (lambda () (interactive) (org-capture nil "r")))

(jsg/org-captures)
(menu-bar-mode 1)
(display-time-mode 1)

(diminish 'auto-revert-mode)
(diminish 'evil-escape-mode)

(setq gc-cons-threshold 16777216
     gc-cons-percentage 0.1)
(toggle-frame-maximized)
(server-start)
