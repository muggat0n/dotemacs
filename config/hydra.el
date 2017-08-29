;; ---------- HYDRA -------------------------------------------------------

(defhydra hydra-buffer (:color blue :columns 3 :hint nil)
  "
^NAV^     ^MENU^           ^DELETE^           ^ACTIONS^
_n_ext      _b_: switch      _d_: del ←         ^ ^
_p_rev    _M-b_: ibuffer   _C-d_: del →       _s_ave
^ ^       _C-b_: menu      _M-d_: del + win   _._: window
  "
  ("n" next-buffer :color red)
  ("p" previous-buffer :color red)
  ("b" ivy-switch-buffer)
  ("M-b" ibuffer)
  ("C-b" buffer-menu)
  ("d" kill-this-buffer :color red)
  ;; don't come back to previous buffer after delete
  ("C-d" (progn (kill-this-buffer) (next-buffer)) :color red)
  ("M-d" (progn (kill-this-buffer) (delete-window)) :color red)
  ("s" save-buffer :color red)
  ("." hydra-window/body :color blue)
  ("q" nil "quit" :color blue))

(defhydra hydra-buffer-menu
  (:color pink
   :hint nil)
  "
^NAV^      ^MARK^         ^UNMARK^        ^ACTIONS^          ^SEARCH^
_p_: prev  _m_: mark      _u_: unmark     _x_: execute       _R_: re-isearch
_n_: next  _s_: save      _U_: unmark up  _b_: bury          _I_: isearch
^ ^        _d_: delete    ^ ^             _g_: refresh       _O_: multi-occur
^ ^        _D_: delete up ^ ^             _T_: files only: % -28`Buffer-menu-files-only
^ ^        _~_: modified
"
  ("p" previous-line)
  ("n" next-line)
  ("m" Buffer-menu-mark)
  ("u" Buffer-menu-unmark)
  ("U" Buffer-menu-backup-unmark)
  ("d" Buffer-menu-delete)
  ("D" Buffer-menu-delete-backwards)
  ("s" Buffer-menu-save)
  ("~" Buffer-menu-not-modified)
  ("x" Buffer-menu-execute)
  ("b" Buffer-menu-bury)
  ("g" revert-buffer)
  ("T" Buffer-menu-toggle-files-only)
  ("O" Buffer-menu-multi-occur :color blue)
  ("I" Buffer-menu-isearch-buffers :color blue)
  ("R" Buffer-menu-isearch-buffers-regexp :color blue)
  ("c" nil "cancel")
  ("v" Buffer-menu-select "select" :color blue)
  ("o" Buffer-menu-other-window "other-window" :color blue)
  ("q" quit-window "quit" :color blue))

(defhydra hydra-bongo (:color red :columns 3 :hint nil)
  "
BONGO
_s_tart     _n_ext
_S_top      _p_revious
^ ^    _SPC_: PLAY!!"
  ("S" bongo-stop)
  ("s" bongo-start)
  ("n" bongo-next)
  ("p" bongo-previous)
  ("b" bongo  "bongo" :color blue)
  ("SPC" bongo-play)
  ("q" nil  "quit" :color blue ))

(defhydra hydra-dired-main (:color pink :hint nil :columns 4)
  "
^^^NAV^ ^^   ^EDIT^                ^MARK^      ^ACTION^
^ ^ _s_ ^ ^  _o_pen other window   _m_ark        _h_: show hidden
_c_ ^ ^ _r_  _R_ename              _u_nmark      _'_: eshell
^ ^ _t_ ^ ^  _S_ort                _d_elete    _C-'_: shell
"
  ("t" dired-next-line :color red)
  ("s" dired-previous-line :color red)
  ("r" dired-find-file :color blue)
  ("c" dired-up-directory :color red)
  ("o" dired-find-file-other-window :color blue)
  ("R" dired-rename-file)
  ("S" hydra-dired-sort/body :color blue)
  ("u" dired-unmark)
  ("m" dired-mark)
  ("d" hydra-dired-delete/body :color blue)
  ("h" dired-omit-mode)
  ("'" eshell-here :color blue)
  ("C-'" shell :color blue)
  ("." nil "toggle hydra" :color blue)
  ("q" nil "quit" :color blue))

(defhydra hydra-dired-delete (:color pink :hint nil :columns 4)
  ("d" dired-flag-file-deletion "flag delete")
  ("x" dired-do-flagged-delete "DEL flagged")
  ("D" dired-do-delete "delete this")
  ("q" hydra-dired-main/body "back" :color blue))

(defhydra hydra-error ()
  ("t" next-error "next")
  ("n" next-error "next")
  ("s" previous-error "previous")
  ("p" previous-error "previous"))

(defhydra hydra-file (:hint nil :exit t)
  "
  ^FIND^           ^RECENT^      ^COMMAND^      ^BOOKMARKS^
  _f_: file        _r_: recent   _s_: save      _i_: init
_C-f_: other wdw _C-r_: fasd     _R_: rename    _k_: keybindings
  _p_: project      ^^           _d_: delete    _O_: org
  _o_: open         ^^            ^^            _F_: functions
   ^^               ^^            ^^            _t_: todo
"
  ("p" counsel-git)
  ("f" counsel-find-file)
  ("C-f" find-file-other-window)
  ("o" sam--open-in-external-app)
  ("r" ivy-switch-buffer)
  ("C-r" fasd-find-file)
  ("s" save-buffer)
  ("R" rename-file)
  ("d" sam--delete-current-buffer-file)
  ("k" (lambda () (interactive) (find-file "~/dotfile/emacs/keybindings.el")))
  ("i" (lambda () (interactive) (find-file "~/dotfile/emacs/init.el")))
  ("O" (lambda () (interactive) (find-file "~/dotfile/emacs/org.el")))
  ("F" (lambda () (interactive) (find-file "~/dotfile/emacs/functions.el")))
  ("t" sam--edit-todo))

(defun sam--set-font (font)
  (interactive)
  (set-frame-font font))

(defun sam-chose-font ()
  "Return HEX code from solarized color map."
  (interactive)
  (ivy-read
   "Chose font :"
   '(("Go" "Go Mono 12")
     ("Hack" "Hack 12")
     ("SCP light" "Source Code Pro Light 12")
     ("Iosevka" "Iosevka Light 12")
     ("Fira" "Fira Code 12")
     ("Ubuntu" "Ubuntu Mono 12")
     ("Roboto" "Roboto 13"))
   :action '(1 ("o" (lambda (x)
                      (with-ivy-window
                        (sam--set-font (elt x 1))))))))

(defhydra hydra-font (:hint nil :color red)
  "
^MONO^               ^VAR^         ^PROP^
_g_o      _u_buntu   _r_oboto    _C-i_nput
_h_ack    _i_osevka
_s_cp     _f_ira
"
  ;; mono
  ("g" (sam--set-font "Go Mono 12"))
  ("h" (sam--set-font "Hack 12"))
  ("s" (sam--set-font "Source Code Pro Light 12"))
  ("i" (sam--set-font "Iosevka Light 12"))
  ("f" (sam--set-font "Fira Code 14"))
  ("u" (sam--set-font "Ubuntu Mono 12"))
  ;; prop
  ("C-i" (lambda () (interactive) (set-frame-font "Input Sans 12" t) (text-scale-increase 1)))
  ;; variable
  ("r" (sam--set-font "Roboto 13"))
  ;; other
  ("z" hydra-zoom/body "zoom" :color blue)
  ("é" sam-chose-font "chose" :color blue)
  ("q" (progn  (hydra-secondary/body) (message "Back to previous hydra")) "back" :color blue))

(defhydra hydra-frame (:hint nil :columns 3 :color blue)
  "frames"
  ("d" delete-frame "delete")
  ("n" new-frame "new")
  ("D" delete-other-frames "delete other"))

(defhydra hydra-git
  (:body-pre (git-gutter-mode 1)
   :post (progn (kill-diff-buffers)
                (message "killed diff buffers"))
   :hint nil)
  "
^NAV^               ^HUNK^            ^FILES^        ^ACTIONS^
  _n_: next hunk    _s_tage hunk      _S_tage        _c_ommit
  _p_: prev hunk    _r_evert hunk     _R_evert       _b_lame
_C-P_: first hunk   _P_opup hunk      _d_iff         _C_heckout
_C-N_: last hunk    _R_evision start  _t_imemachine
"
  ("n" git-gutter:next-hunk)
  ("p" git-gutter:previous-hunk)
  ("C-P" (progn (goto-char (point-min)) (git-gutter:next-hunk 1)))
  ("C-N" (progn (goto-char (point-min)) (git-gutter:previous-hunk 1)))
  ("s" git-gutter:stage-hunk)
  ("r" git-gutter:revert-hunk)
  ("P" git-gutter:popup-hunk)
  ("R" git-gutter:set-start-revision)
  ("S" magit-stage-file)
  ("R" magit-revert)
  ("d" magit-diff-unstaged :color blue)
  ("t" git-timemachine :color blue)
  ("c" magit-commit :color blue)
  ("b" magit-blame)
  ("C" magit-checkout)
  ("v" magit-status "status" :color blue)
  ("q" nil "quit" :color blue)
  ("Q" (progn
         (git-gutter-mode -1)
         ;; git-gutter-fringe doesn't seem to
         ;; clear the markup right away
         (sit-for 0.1)
         (git-gutter:clear))
   "quit git-gutter"
   :color blue))

(defhydra hydra-ibuffer-main (:color pink :hint nil)
  ;; Ibuffer
  ;; this is genius hydra making from
  ;; https://github.com/abo-abo/hydra/wiki/Ibuffer
  "
  ^NAVIGATION^     ^MARK^          ^ACTIONS^          ^VIEW^
  _s_:    ↑        _m_: mark       _d_: delete        _g_: refresh
  _r_:  visit      _u_: unmark     _S_: save          _O_: sort
  _t_:    ↓        _*_: specific   _a_: all actions   _/_: filter
"
  ("t" ibuffer-forward-line)
  ("r" ibuffer-visit-buffer :color blue)
  ("s" ibuffer-backward-line)

  ("m" ibuffer-mark-forward)
  ("u" ibuffer-unmark-forward)
  ("*" hydra-ibuffer-mark/body :color blue)

  ("d" ibuffer-do-delete)
  ("S" ibuffer-do-save)
  ("a" hydra-ibuffer-action/body :color blue)

  ("g" ibuffer-update)
  ("O" hydra-ibuffer-sort/body :color blue)
  ("/" hydra-ibuffer-filter/body :color blue)

  ("o" ibuffer-visit-buffer-other-window "other window" :color blue)
  ("q" ibuffer-quit "quit ibuffer" :color blue)
  ("." nil "toggle hydra" :color blue))

(defhydra hydra-ibuffer-sort (:color amaranth :columns 3)
  "Sort"
  ("i" ibuffer-invert-sorting "invert")
  ("a" ibuffer-do-sort-by-alphabetic "alphabetic")
  ("v" ibuffer-do-sort-by-recency "recently used")
  ("s" ibuffer-do-sort-by-size "size")
  ("f" ibuffer-do-sort-by-filename/process "filename")
  ("m" ibuffer-do-sort-by-major-mode "mode")
  ("b" hydra-ibuffer-main/body "back" :color blue))

(defhydra hydra-ibuffer-action (:color teal :columns 4
                                :after-exit
                                (if (eq major-mode 'ibuffer-mode)
                                    (hydra-ibuffer-main/body)))
  "Action"
  ("A" ibuffer-do-view "view")
  ("E" ibuffer-do-eval "eval")
  ("F" ibuffer-do-shell-command-file "shell-command-file")
  ("I" ibuffer-do-query-replace-regexp "query-replace-regexp")
  ("H" ibuffer-do-view-other-frame "view-other-frame")
  ("N" ibuffer-do-shell-command-pipe-replace "shell-cmd-pipe-replace")
  ("M" ibuffer-do-toggle-modified "toggle-modified")
  ("O" ibuffer-do-occur "occur")
  ("P" ibuffer-do-print "print")
  ("Q" ibuffer-do-query-replace "query-replace")
  ("R" ibuffer-do-rename-uniquely "rename-uniquely")
  ("T" ibuffer-do-toggle-read-only "toggle-read-only")
  ("U" ibuffer-do-replace-regexp "replace-regexp")
  ("V" ibuffer-do-revert "revert")
  ("W" ibuffer-do-view-and-eval "view-and-eval")
  ("X" ibuffer-do-shell-command-pipe "shell-command-pipe")
  ("b" nil "back"))

(defhydra hydra-ibuffer-filter (:color amaranth :columns 4)
  "Filter"
  ("m" ibuffer-filter-by-used-mode "mode")
  ("M" ibuffer-filter-by-derived-mode "derived mode")
  ("n" ibuffer-filter-by-name "name")
  ("c" ibuffer-filter-by-content "content")
  ("e" ibuffer-filter-by-predicate "predicate")
  ("f" ibuffer-filter-by-filename "filename")
  (">" ibuffer-filter-by-size-gt "size")
  ("<" ibuffer-filter-by-size-lt "size")
  ("/" ibuffer-filter-disable "disable")
  ("b" hydra-ibuffer-main/body "back" :color blue))

(defhydra hydra-ibuffer-mark (:color teal :columns 5
                              :after-exit (hydra-ibuffer-main/body))
  "Mark"
  ("*" ibuffer-unmark-all "unmark all")
  ("M" ibuffer-mark-by-mode "mode")
  ("m" ibuffer-mark-modified-buffers "modified")
  ("u" ibuffer-mark-unsaved-buffers "unsaved")
  ("s" ibuffer-mark-special-buffers "special")
  ("r" ibuffer-mark-read-only-buffers "read-only")
  ("/" ibuffer-mark-dired-buffers "dired")
  ("e" ibuffer-mark-dissociated-buffers "dissociated")
  ("h" ibuffer-mark-help-buffers "help")
  ("z" ibuffer-mark-compressed-file-buffers "compressed")
  ("b" hydra-ibuffer-main/body "back" :color blue))

(defhydra hydra-insert (:hint nil :color blue)
  "
^INSERT^       ^LINK^    ^FINDER^
_t_: time      _m_: md   _M_: md
_s_: sentence  _o_: org  _O_: org
_p_: paragraph
"
  ("t" sam--insert-timestamp)
  ("m" (lambda () (interactive) (insert (grab-mac-link 'chrome 'markdown))))
  ("o" (lambda () (interactive) (insert (grab-mac-link 'chrome 'markdown))))
  ("M" (lambda () (interactive) (insert (grab-mac-link 'finder 'markdown))))
  ("O" (lambda () (interactive) (insert (grab-mac-link 'finder 'org))))

  ("s" lorem-ipsum-insert-sentences :color red)
  ("p" lorem-ipsum-insert-paragraphs :color red)
  ("q" nil "quit")
  ("." hydra-main/body "back"))

(defhydra hydra-launcher (:color blue :hint nil)
  "
^WEB^       ^BLOG^         ^EXPLORER^     ^APPS^
_g_oogle    _bn_ew post    _d_ired        _s_hell
_r_eddit    _bp_ublish     _D_eer         _S_hell gotodir
_w_iki      _bs_server     _r_anger       _a_pps
_t_witter
"
  ("a" counsel-osx-apps)
  ("bn" (hugo-new-post))
  ("bp" (hugo-publish))
  ("bs" (hugo-server))
  ("d" dired)
  ("D" deer)
  ("r" ranger)
  ("g" (browse-url "https://www.google.fr/"))
  ("R" (browse-url "http://www.reddit.com/r/emacs/"))
  ("w" (browse-url "http://www.emacswiki.org/"))
  ("t" (browse-url "https://twitter.com/?lang=fr"))
  ("s" (sam--iterm-focus))
  ("S" (sam--iterm-goto-filedir-or-home))
  ("q" nil "quit"))

(defhydra hydra-make (:hint nil :columns 2)
  "
[_c_]: compile
"
  ("c" compile :color blue)
  ("q" nil "quit" :color blue))

(defhydra hydra-quit (:hint nil :color blue)
  "
^QUIT^
_q_: emacs
_r_: restart
"
  ("q" save-buffers-kill-terminal)
  ("r" restart-emacs)
  ("." hydra-main/body "back"))

(defhydra hydra-rectangle (:body-pre (rectangle-mark-mode 1)
                           :hint nil
                           :color pink
                           :post (deactivate-mark))
  "
  ^_s_^     _d_elete      _S_tring    _k_ill
_c_   _r_   _q_uit        _y_ank
  ^_t_^     _n_ew-copy    _R_eset
^^^^        _e_xchange    _u_ndo
^^^^        ^ ^
"
  ("c" backward-char)
  ("r" forward-char)
  ("s" previous-line)
  ("t" next-line)
  ("e" exchange-point-and-mark)
  ("n" copy-rectangle-as-kill)
  ("d" delete-rectangle)
  ("R" (if (region-active-p)
           (deactivate-mark)
         (rectangle-mark-mode 1)))
  ("y" (lambda () (interactive) (save-excursion (yank-rectangle))))
  ("u" undo)
  ("S" string-rectangle)
  ("k" kill-rectangle)
  ("SPC" (lambda () (interactive) (rectangle-mark-mode 1)) "set")
  ("q" nil))

(defhydra hydra-term (:hint nil :exit t)
  "
^TERM^           ^MULTITERM^
_t_: term     |  _m_: multi  _c_: close
_e_: eshell   |  _n_: next   _o_: open
_s_: shell    |  _p_: prev   _S_: select
^ ^           |  ^ ^         _T_: toggle
"
  ("t" (lambda () (interactive) (term "/usr/local/bin/bash")))
  ("e" eshell)
  ("s" shell)
  ("m" multi-term)
  ("n" multi-term-next)
  ("p" multi-term-prev)
  ("o" multi-term-dedicated-open)
  ("c" multi-term-dedicated-close)
  ("S" multi-term-dedicated-select)
  ("T" multi-term-dedicated-toggle)
  ("q" nil :color blue))

(defhydra hydra-toggle (:hint nil :color blue)
  "
^THEMES^  ^MODES^        ^MODELINE^   ^FRAME^        ^LINE^
_d_ark    _f_lycheck     _T_ime       _F_ullscreen   _t_runcate
_l_ight   li_n_um        ^ ^          _m_aximized
^^        _w_hitespace   ^ ^          ^ ^
^^        _p_ersp-mode   ^ ^          ^ ^
"
  ;; ("d" (lambda () (interactive) (load-theme 'apropospriate-dark t)))

  ("d" (lambda () (interactive) (load-theme 'misterioso t)))
  ("l" (lambda () (interactive) (load-theme 'leuven t)))

  ("f" flycheck-mode)
  ("n" nlinum-mode)
  ("T" display-time-mode)
  ("p" persp-mode)
  ("m" toggle-frame-maximized)
  ("F" toggle-frame-fullscreen)
  ("w" blank-mode :color red)
  ("t" toggle-truncate-lines)
  ("q" nil "quit" :color blue))

(defhydra hydra-transparency
  (:columns 2
   :body-pre
   (let* ((alpha (frame-parameter (selected-frame) 'alpha)))
     (cond ((not alpha) (sam--set-transparency -10))
           ((eql alpha 100) (sam--set-transparency -10))
           (t nil))))
  "
ALPHA : [ %(frame-parameter nil 'alpha) ]
"
  ("t" (lambda () (interactive) (sam--set-transparency +1)) "+ more")
  ("s" (lambda () (interactive) (sam--set-transparency -1)) "- less")
  ("T" (lambda () (interactive) (sam--set-transparency +10)) "++ more")
  ("S" (lambda () (interactive) (sam--set-transparency -10)) "-- less")
  ("=" (lambda (value) (interactive "nTransparency Value 0 - 100 opaque:")
         (set-frame-parameter (selected-frame) 'alpha value)) "Set to ?" :color blue))

(defhydra hydra-window-enlarge (:hint nil)
  "
^SIZE^ ^^^^
^ ^ ^ ^ _S_ ^ ^
^ ^ ^ ^ _s_ ^ ^
_C_ _c_ ^ ^ _r_ _R_
^ ^ ^ ^ _t_ ^ ^
^ ^ ^ ^ _T_ ^ ^
^ ^ ^ ^ ^ ^ ^ ^
"
  ("s" (lambda () (interactive) (enlarge-window -1)))
  ("S" (lambda () (interactive) (enlarge-window -10)))
  ("c" enlarge-window-horizontally)
  ("C" (lambda () (interactive) (enlarge-window-horizontally 10)))
  ("r" (lambda () (interactive) (enlarge-window-horizontally -1)))
  ("R" (lambda () (interactive) (enlarge-window-horizontally -10)))
  ("t" (lambda () (interactive) (enlarge-window 1)))
  ("T" (lambda () (interactive) (enlarge-window 10)))
  ("q" nil :color blue))

(defhydra hydra-window
  (:hint nil
   :color amaranth
   :columns 4
   :pre (winner-mode 1)
   :post (balance-windows))
  "
^MOVE^ ^^^^   ^SPLIT^          ^SIZE^   ^COMMAND^   ^WINDOW^
^ ^ _s_ ^ ^   _-_ : split H    ^ ^     _d_elete    ^1^ ^2^ ^3^ ^4^
_c_ _é_ _r_   _|_ : split V    _e_     _m_aximize  ^5^ ^6^ ^7^ ^8^
^ ^ _t_ ^ ^   _h_ : split H    ^ ^     _u_ndo      ^9^ ^0^
^ ^ ^ ^ ^ ^   _v_ : split V    ^ ^     _R_edo
"
  ("c" windmove-left :color blue)
  ("r" windmove-right :color blue)
  ("t" windmove-down :color blue)
  ("s" windmove-up :color blue)

  ;; splt
  ("-" split-window-vertically)
  ("|" split-window-horizontally)
  ("v" split-window-horizontally :color blue)
  ("h" split-window-vertically :color blue)

  ;; size
  ("e" hydra-window-enlarge/body :color blue)

  ("u" winner-undo)
  ("R" winner-redo)
  ("m" delete-other-windows)
  ("d" delete-window)

  ;; change height and width
  ("0" select-window-0 :color blue)
  ("1" select-window-1 :color blue)
  ("2" select-window-2 :color blue)
  ("3" select-window-3 :color blue)
  ("4" select-window-4 :color blue)
  ("5" select-window-5 :color blue)
  ("6" select-window-6 :color blue)
  ("7" select-window-7 :color blue)
  ("8" select-window-8 :color blue)
  ("9" select-window-9 :color blue)

  ("=" balance-windows)
  ("é" ace-window)
  ("." hydra-buffer/body "buffers" :color blue)
  ("'" hydra-tile/body "tile" :color blue)
  ("q" nil "quit" :color blue))

(defhydra hydra-zoom (:hint nil)
  "
^BUFFER^   ^FRAME^    ^ACTION^
_t_: +     _T_: +     _0_: reset
_s_: -     _S_: -     _q_: quit
"
  ("t" zoom-in)
  ("s" zoom-out)
  ("T" zoom-frm-in)
  ("S" zoom-frm-out)
  ("0" zoom-frm-unzoom)
  ("q" nil :color blue))

;; ---------- MAIN HYDRA --------------------------------------------------

(defhydra hydra-main (:hint nil :color teal)
  "
_a_: applications  _f_: file      _o_: outline   _T_: term
_b_: buffer        _i_: insert    _p_: project   _v_: git
_B_: frames        _j_: journal   _Q_: quit      _z_: zoom
_é_: window        _m_: make      _t_: toggle
"
  ("a" hydra-launcher/body)
  ("b" hydra-buffer/body)
  ("B" hydra-frame/body)
  ("é" hydra-window/body)
  ("f" hydra-file/body)
  ("i" hydra-insert/body)
  ("j" org-capture)
  ("m" hydra-make/body)
  ("o" hydra-outline/body)
  ("p" hydra-projectile-if-projectile-p)
  ("Q" hydra-quit/body)
  ("t" hydra-toggle/body)
  ("T" hydra-term/body)
  ("v" hydra-git/body)
  ("z" hydra-zoom/body)
  ("s-<tab>" other-frame)
  ("<tab>" hydra-secondary/body "secondary")
  ("q" (message "Quit Primary Hydra") "quit" :color blue))

(defhydra hydra-secondary (:hint nil :color teal)
  "
_a_: agenda  _b_: bongo
_f_: font
_t_: todo
"
  ("a" (lambda () (interactive) (org-agenda 1 "a")))
  ("b" hydra-bongo/body)
  ("f" hydra-font/body)
  ("t" (lambda () (interactive) (org-agenda 1 "t")))
  ("<tab>" hydra-main/body "primary")
  ("q" (message "Abort") "abort" :color blue))
(defun hydra-projectile-if-projectile-p ()
    (interactive)
    (if (projectile-project-p)
        (hydra-projectile/body)
      (counsel-projectile)))

  (defhydra hydra-projectile
    (:color teal :hint nil
     :pre (projectile-mode))
    "
     PROJECTILE: %(projectile-project-root)
    ^FIND FILE^        ^SEARCH/TAGS^        ^BUFFERS^       ^CACHE^                    ^PROJECT^
    _f_: file          _a_: ag              _i_: Ibuffer    _c_: cache clear           _p_: switch proj
    _F_: file dwim     _g_: update gtags    _b_: switch to  _x_: remove known project
  _C-f_: file pwd      _o_: multi-occur   _s-k_: Kill all   _X_: cleanup non-existing
    _r_: recent file   ^ ^                  ^ ^             _z_: cache current
    _d_: dir
   ^SHELL^
   _e_: eshell
"
    ("e"   projectile-run-eshell)
    ("a"   projectile-ag)
    ("b"   projectile-switch-to-buffer)
    ("c"   projectile-invalidate-cache)
    ("d"   projectile-find-dir)
    ("f"   projectile-find-file)
    ("F"   projectile-find-file-dwim)
    ("C-f" projectile-find-file-in-directory)
    ("g"   ggtags-update-tags)
    ("s-g" ggtags-update-tags)
    ("i"   projectile-ibuffer)
    ("K"   projectile-kill-buffers)
    ("s-k" projectile-kill-buffers)
    ("m"   projectile-multi-occur)
    ("o"   projectile-multi-occur)
    ("p"   projectile-switch-project)
    ("r"   projectile-recentf)
    ("x"   projectile-remove-known-project)
    ("X"   projectile-cleanup-known-projects)
    ("z"   projectile-cache-current-file)
    ("q"   nil "cancel" :color blue))

  (defhydra hydra-persp (:hint nil :color blue)
    "
^Nav^        ^Buffer^      ^Window^     ^Manage^      ^Save/load^
^---^        ^------^      ^------^     ^------^      ^---------^
_n_: next    _a_: add      ^ ^          _r_: rename   _w_: save
_p_: prev    _b_: → to     ^ ^          _c_: copy     _W_: save subset
_s_: → to    _i_: import   _S_: → to    _C_: kill     _l_: load
^ ^          ^ ^           ^ ^          ^ ^           _L_: load subset
"
    ("n" persp-next :color red)
    ("p" persp-prev :color red)
    ("s" persp-switch)
    ("S" persp-window-switch)
    ("r" persp-rename)
    ("c" persp-copy)
    ("C" persp-kill)
    ("a" persp-add-buffer)
    ("b" persp-switch-to-buffer)
    ("i" persp-import-buffers-from)
    ("I" persp-import-win-conf)
    ("o" persp-mode)
    ("w" persp-save-state-to-file)
    ("W" persp-save-to-file-by-names)
    ("l" persp-load-state-from-file)
    ("L" persp-load-from-file-by-names)
    ("q" nil "quit"))

(defhydra hydra-tile (:hint nil :color red :columns 4
                        :body-pre (winner-mode 1))
    "tile "
    ("a" (tile :strategy tile-tall-3) "tall 3")
    ("u" (tile :strategy (tile-split-n-tall 4)) "tall 4")
    ("i" (tile :strategy (tile-split-n-wide 2)) "wide 2")
    ("e" (tile :strategy (tile-split-n-wide 3)) "wide 3")
    ("c" (tile :strategy tile-master-left-3) "left 3")
    ("t" (tile :strategy tile-master-bottom-3) "bottom 3")
    ("s" (tile :strategy tile-master-top-3) "top 3")
    ("r" (tile :strategy tile-master-right-3) "right 3")

    ("m" tile-select "chose")
    ("w" (tile :strategy tile-one) "one")
    ("n" tile "tile")
    ("C-u" winner-undo "undo")
    ("M-u" winner-redo "redo")
    ("é" hydra-window/body "windows" :color blue)

    ("q" nil :color blue "quit"))

 (defhydra hydra-markdown (:hint nil)
    "
Formatting         _s_: bold          _e_: italic     _b_: blockquote   _p_: pre-formatted    _c_: code
Headings           _h_: automatic     _1_: h1         _2_: h2           _3_: h3               _4_: h4
Lists              _m_: insert item
Demote/Promote     _l_: promote       _r_: demote     _U_: move up      _D_: move down
Links, footnotes   _L_: link          _U_: uri        _F_: footnote     _W_: wiki-link      _R_: reference
undo               _u_: undo
"


    ("s" markdown-insert-bold)
    ("e" markdown-insert-italic)
    ("b" markdown-insert-blockquote :color blue)
    ("p" markdown-insert-pre :color blue)
    ("c" markdown-insert-code)

    ("h" markdown-insert-header-dwim)
    ("1" markdown-insert-header-atx-1)
    ("2" markdown-insert-header-atx-2)
    ("3" markdown-insert-header-atx-3)
    ("4" markdown-insert-header-atx-4)

    ("m" markdown-insert-list-item)

    ("l" markdown-promote)
    ("r" markdown-demote)
    ("D" markdown-move-down)
    ("U" markdown-move-up)

    ("L" markdown-insert-link :color blue)
    ("U" markdown-insert-uri :color blue)
    ("F" markdown-insert-footnote :color blue)
    ("W" markdown-insert-wiki-link :color blue)
    ("R" markdown-insert-reference-link-dwim :color blue)

    ("u" undo :color teal)
    )
(defhydra hydra-ivy (:hint nil
                       :color pink)
    "
^ ^ ^ ^ ^ ^ | ^Call^      ^ ^  | ^Cancel^ | ^Options^ | Action _b_/_é_/_p_: %-14s(ivy-action-name)
^-^-^-^-^-^-+-^-^---------^-^--+-^-^------+-^-^-------+-^^^^^^^^^^^^^^^^^^^^^^^^^^^^^---------------------------
^ ^ _s_ ^ ^ | _f_ollow occ_u_r | _i_nsert | _C_: calling %-5s(if ivy-calling \"on\" \"off\") _C-c_ase-fold: %-10`ivy-case-fold-search
_c_ ^+^ _r_ | _d_one      ^ ^  | _o_ops   | _m_: matcher %-5s(ivy--matcher-desc)^^^^^^^^^^^^ _T_runcate: %-11`truncate-lines
^ ^ _t_ ^ ^ | _g_o        ^ ^  | ^ ^      | _<_/_>_: shrink/grow^^^^^^^^^^^^^^^^^^^^^^^^^^^^ _D_efinition of this menu
"
    ;; arrows
    ("c" ivy-beginning-of-buffer)
    ("t" ivy-next-line)
    ("s" ivy-previous-line)
    ("r" ivy-end-of-buffer)
    ;; actions
    ("o" keyboard-escape-quit :exit t)
    ("C-g" keyboard-escape-quit :exit t)
    ("i" nil)
    ("C-o" nil)
    ("f" ivy-alt-done :exit nil)
    ("C-j" ivy-alt-done :exit nil)
    ("d" ivy-done :exit t)
    ("g" ivy-call)
    ("C-m" ivy-done :exit t)
    ("C" ivy-toggle-calling)
    ("m" ivy-toggle-fuzzy)
    (">" ivy-minibuffer-grow)
    ("<" ivy-minibuffer-shrink)
    ("b" ivy-prev-action)
    ("é" ivy-next-action)
    ("p" ivy-read-action)
    ("T" (setq truncate-lines (not truncate-lines)))
    ("C-c" ivy-toggle-case-fold)
    ("u" ivy-occur :exit t)
    ("D" (ivy-exit-with-action
          (lambda (_) (find-function 'hydra-ivy/body)))
     :exit t))

  (defun ivy-switch-project ()
    (interactive)
    (ivy-read
     "Switch to project: "
     (if (projectile-project-p)
         (cons (abbreviate-file-name (projectile-project-root))
               (projectile-relevant-known-projects))
       projectile-known-projects)
     :action #'projectile-switch-project-by-name))

  (global-set-key (kbd "C-c m") 'ivy-switch-project)

  (ivy-set-actions
   'ivy-switch-project
   '(("d" dired "Open Dired in project's directory")
     ("v" counsel-projectile "Open project root in vc-dir or magit")
     ("c" projectile-compile-project "Compile project")
     ("r" projectile-remove-known-project "Remove project(s)"))))
