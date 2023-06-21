  (require 'package)
  (setq package-enable-at-startup nil)
  (add-to-list 'package-archives
       '("melpa" . "https://melpa.org/packages/")
       '("elpa" . "https://elpa.gnu.org/packages/"))
  (add-to-list 'package-archives
       '("org" . "https://orgmode.org/elpa/")) ;; org-mode's repo
  (package-initialize)

  (unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))
  (setq use-package-always-ensure t)

  (use-package zenburn-theme
      :config
      (load-theme 'zenburn t))
  
  ;; disable scroll and toll bar
      (scroll-bar-mode -1)
      (tool-bar-mode -1)

  (add-to-list 'default-frame-alist
             '(font . "Fira Code Medium"))

  (use-package ligature
    :config
    ;; Enable all ligatures in programming modes
    (ligature-set-ligatures 'prog-mode '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
                                       ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
                                       "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
                                       "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
                                       "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
                                       "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
                                       "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
                                       "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
                                       ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
                                       "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
                                       "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
                                       "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
                                       "\\\\" "://"))
    (global-ligature-mode t))

  ;;(set-frame-parameter (selected-frame) 'alpha '(<active> . <inactive>))
   ;;(set-frame-parameter (selected-frame) 'alpha <both>)
   (set-frame-parameter (selected-frame) 'alpha 95)
   (add-to-list 'default-frame-alist '(alpha . 95))

   (defun toggle-transparency ()
   (interactive)
   (let ((alpha (frame-parameter nil 'alpha)))
     (set-frame-parameter
      nil 'alpha
      (if (eql (cond ((numberp alpha) alpha)
                     ((numberp (cdr alpha)) (cdr alpha))
                     ;; Also handle undocumented (<active> <inactive>) form.
                     ((numberp (cadr alpha)) (cadr alpha)))
               100)
          '(95) '(100 . 100)))))
 (global-set-key (kbd "C-c t") 'toggle-transparency)

  (add-hook 'org-mode-hook 'org-indent-mode)
  (setq org-directory "~/Documents/notes"
      org-agenda-files (list org-directory)
      org-default-notes-file (expand-file-name "notes.org" org-directory)
  
      ;; change the agenda priority values to numeric
      org-priority-highest 1
      org-priority-default 2
      org-priority-lowest 3

      ;; format options
      org-ellipsis " ▼ "
      org-log-done 'time
      org-journal-dir "~/Documents/journal/"
      org-journal-date-format "%B %d, %Y (%A) "
      org-journal-file-format "%Y-%m-%d.org"
      org-hide-emphasis-markers t)

  ;; source blocks settings
  (setq org-src-preserve-indentation t
      org-src-tab-acts-natively t
      org-edit-src-content-indentation 2)

  ;;needed for projects file
  (use-package projectile
    :ensure t
    :init (projectile-mode +1)
    :config
    (define-key
      projectile-mode-map
        (kbd "C-c p")
      'projectile-command-map))

  (setq inhibit-startup-message t)
  (use-package dashboard
    :init
    :ensure t
    :config
      (dashboard-setup-startup-hook)
      (setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))
      (setq dashboard-startup-banner 'official)
      (setq dashboard-set-file-icons t)
      (setq dashboard-set-navigator t)
      (setq dashboard-center-content t)
      (setq dashboard-week-agenda t)
      (setq dashboard-filter-agenda-entry 'dashboard-no-filter-agenda) ;; filter completed items

  ;; Format: "(icon title help action face prefix suffix)"
  (setq dashboard-navigator-buttons
        `(;; line1 (visit my github)
          ((,(all-the-icons-octicon "mark-github" :height 1.1 :v-adjust 0.0)
           "Github"
           "Browse github"
           (lambda (&rest _) (browse-url "https://github.com/cbraidwood"))))

          ;; line 2 (visit my website)
          ((,(all-the-icons-faicon "globe" :height 1.1 :v-adjust 0.0)
            "Website"
            "Visit charliebraidwood.com"
            (lambda (&rest _) (browse-url "https://charliebraidwood.com"))))))

      ;; configure dashboard item sections
      (add-to-list 'dashboard-items '(agenda) t)
      (setq dashboard-items '((recents  . 5) ;; when adding the other tabs back delete these brackets
            (agenda . 5)
            (projects . 5)
                  (bookmarks . 5))))

  (use-package evil
    :ensure t  ;; install if not installed
    :init      ;; tweak evil's configuration before loading it
    (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
    (setq evil-want-keybinding nil)
    (setq evil-vsplit-window-right t)
    (setq evil-split-window-below t)
    (evil-mode))
    (evil-set-undo-system 'undo-redo) ;; added for redo functionality in emacs 28
  
  (use-package evil-collection
    :ensure t
    :after evil
    :config
    (evil-collection-init))
  (setq confirm-kill-emacs #'yes-or-no-p) ;; prompt on :q and :wq so emacs doesn't close
  (defalias 'yes-or-no-p 'y-or-n-p) ;; change yes or no to y or n

  ;; bind escape to cancel all shortcuts
  (global-set-key (kbd "<escape>") 'keyboard-escape-quit)

  (setq display-time-format "%l:%M %p %b %y"
        display-time-default-load-average nil)

  ;;(setup (:pkg diminish))

      ;; You must run (all-the-icons-install-fonts) one time after
      ;; installing this package!

   ;; (setup (:pkg minions)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

  ;; set default tab char's display width to 2 spaces
  (setq-default tab-width 2) ; emacs 23.1 to 26 default to 8

  ;; set current buffer's tab char's display width to 4 spaces
  (setq tab-width 2)

(progn
  ;; make indent commands use space only (never tab character)
  (setq-default indent-tabs-mode nil)
  ;; emacs 23.1 to 26, default to t
  ;; if indent-tabs-mode is t, it means it may use tab, resulting mixed space and tab
  )

(use-package magit
  :ensure t
  :config
  (setq magit-push-always-verify nil)
  (setq git-commit-summary-max-length 50)
  :bind
  ("C-c m" . magit-status))

    (require 'display-line-numbers)

  (defcustom display-line-numbers-exempt-modes
    '(vterm-mode eshell-mode shell-mode term-mode ansi-term-mode pdf-view-mode dired-mode neotree-mode dashboard-mode)
    "Major modes on which to disable line numbers."
    :group 'display-line-numbers
    :type 'list
    :version "green")
  
  (defun display-line-numbers--turn-on ()
    "Turn on line numbers except for certain major modes.
  Exempt major modes are defined in `display-line-numbers-exempt-modes'."
    (unless (or (minibufferp)
                (member major-mode display-line-numbers-exempt-modes))
      (display-line-numbers-mode)))

  (global-display-line-numbers-mode)
    (setq display-line-numbers-type 'relative)

;; Increases Garbage Collection During Startup
(setq startup/gc-cons-threshold gc-cons-threshold)
(setq gc-cons-threshold most-positive-fixnum)
(defun startup/reset-gc () (setq gc-cons-threshold startup/gc-cons-threshold))
(add-hook 'emacs-startup-hook 'startup/reset-gc)

  (use-package all-the-icons)

(setq lsp-pyls-server-command "/home/charlie/.local/bin/pylsp")

;;(setenv "PATH" (concat (getenv "PATH") ":/home/charlie/.local/bin"))
  (use-package python-mode
  :ensure t
  :hook (python-mode . lsp-deferred)
  :custom
  ;; NOTE: Set these if Python 3 is called "python3" on your system!
  ;; (python-shell-interpreter "python3")
  ;; (dap-python-executable "python3")
  (dap-python-debugger 'debugpy)
  :config
  (require 'dap-python))

;; virtual env
(use-package pyvenv
  :config
  (pyvenv-mode 1))

(use-package company
  :ensure t
  :after lsp-mode
  :diminish (company-mode irony-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :config
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 1)
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous)
  (define-key company-active-map (kbd "SPC") #'company-abort)
  :hook
  ((java-mode c-mode c++-mode lsp-mode) . company-mode))

;; company box tweaks appearance of the completion box
(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package company-c-headers
  :defer nil
  :ensure t)

(use-package company-irony
  :defer nil
  :ensure t
  :config
  (setq company-backends '((company-c-headers
                            company-dabbrev-code
                            company-irony))))
(use-package irony
  :defer nil
  :ensure t
  :config
  :hook
  ((c++-mode c-mode) . irony-mode)
  ('irony-mode-hook) . 'irony-cdb-autosetup-compile-options)

  ;; use lsp-mode. This should be in its own section
  (use-package lsp-mode
    :hook ((lsp-mode . lsp-enable-which-key-integration)))
  
    ;; install and use language server for java
    (use-package lsp-java
      :config
      (add-hook 'java-mode-hook 'lsp))

    ;; dap mode for debugging
    (use-package dap-mode
      :after lsp-mode
      :config (dap-auto-configure-mode))

    (use-package dap-java
      :ensure nil)

    ;; yasnippet the template system
    (use-package yasnippet
      :config (yas-global-mode))
    (use-package yasnippet-snippets
      :ensure t)

(defun my-java-mode-hook ()
  (auto-fill-mode)
  (flycheck-mode)
  (git-gutter+-mode)
  (subword-mode)
  (yas-minor-mode)
  (set-fringe-style '(8 . 0))
  (define-key c-mode-base-map (kbd "C-M-j") 'tkj-insert-serial-version-uuid)
  (define-key c-mode-base-map (kbd "C-m") 'c-context-line-break)
  (define-key c-mode-base-map (kbd "S-<f7>") 'gtags-find-tag-from-here)

  ;; Fix indentation for anonymous classes
  (c-set-offset 'substatement-open 0)
  (if (assoc 'inexpr-class c-offsets-alist)
      (c-set-offset 'inexpr-class 0))

  ;; Indent arguments on the next line as indented body.
  (c-set-offset 'arglist-intro '++))
(add-hook 'java-mode-hook 'my-java-mode-hook)

(use-package vterm
  :ensure t
  :init
  (global-set-key (kbd "<s-return>") 'vterm))

  (use-package auctex
    :ensure t
    :defer t)

    ;; auto-complete
    ;;(require 'auto-complete-auctex)
    ;;(require 'ac-math)

    (setq TeX-auto-save t)
    (setq TeX-parse-self t)
    (setq-default TeX-master nil)

  ;; enable LaTeX math support
  ;; (add-hook 'LaTeX-mode-map #'LaTeX-math-mode)

  ;; enable reference management
  ;; (add-hook 'LaTeX-mode-map #'reftex-mode)

  ;; switch pdf viewer to pdf-tools
    (setq TeX-view-program-selection '((output-pdf "PDF Tools"))
      TeX-source-correlate-start-server t)

  (use-package pdf-tools
  :ensure t
  :config
  (pdf-tools-install))

;; stop creating those #auto-save# files
(setq auto-save-default nil)

(setq scroll-conservatively 101) ;; value greater than 100 gets rid of half page jumping
(setq mouse-wheel-scroll-amount '(3 ((shift) . 3))) ;; how many lines at a time
(setq mouse-wheel-progressive-speed t) ;; accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse

  (use-package neotree
  :ensure t)
  (require 'neotree)
  (global-set-key [f8] 'neotree-toggle)
  ;; set icons
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow))

  ;; fix evil bindings
  ;;  (add-hook 'neotree-mode-hook
  ;;              (lambda ()
  ;;                (define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter)
  ;;                (define-key evil-normal-state-local-map (kbd "SPC") 'neotree-quick-look)
  ;;                (define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
  ;;                (define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter)
  ;;                (define-key evil-normal-state-local-map (kbd "g") 'neotree-refresh)
  ;;                (define-key evil-normal-state-local-map (kbd "n") 'neotree-next-line)
  ;;                (define-key evil-normal-state-local-map (kbd "p") 'neotree-previous-line)
  ;;                (define-key evil-normal-state-local-map (kbd "A") 'neotree-stretch-toggle)
  ;;                (define-key evil-normal-state-local-map (kbd "H") 'neotree-hidden-file-toggle)))

(add-hook 'org-mode-hook '(lambda () (visual-line-mode 1)))

(global-set-key [(control x) (k)] 'kill-this-buffer)

;;reload emacs init.el
(global-set-key (kbd "C-c a") 'load-file)

;; save desktop sessions
(desktop-save-mode 1)

;; windmove use arrows to move windows
(when (fboundp 'windmove-default-keybindings)
(windmove-default-keybindings))

;; for terminals too
(global-set-key (kbd "C-c <left>")  'windmove-left)
  (global-set-key (kbd "C-c <right>") 'windmove-right)
  (global-set-key (kbd "C-c <up>")    'windmove-up)
  (global-set-key (kbd "C-c <down>")  'windmove-down)

;; enable bracket matching
(setq electric-pair-pairs '(
                            (?\{ . ?\})
                            (?\( . ?\))
                            (?\[ . ?\])
                            (?\" . ?\")
                            ))
(electric-pair-mode t)

;; creating window switches cursor to it
(defun split-and-follow-horizontally ()
	(interactive)
	(split-window-below)
	(balance-windows)
	(other-window 1))
 (global-set-key (kbd "C-x 2") 'split-and-follow-horizontally)

 (defun split-and-follow-vertically ()
	(interactive)
	(split-window-right)
	(balance-windows)
	(other-window 1))
 (global-set-key (kbd "C-x 3") 'split-and-follow-vertically)

(use-package which-key

  :init

  (setq which-key-side-window-location 'bottom

        which-key-sort-order #'which-key-key-order-alpha

        which-key-sort-uppercase-first nil

        which-key-add-column-padding 1

        which-key-max-display-columns nil

        which-key-min-display-lines 6

        which-key-side-window-slot -10

        which-key-side-window-max-height 0.25

        which-key-idle-delay 0.8

        which-key-max-description-length 25

        which-key-allow-imprecise-window-fit t

        which-key-separator " → " ))

(which-key-mode)

 (defun my-copy-buffer ()
  (interactive)
  (get-buffer-create "NEWBUF")
  (copy-to-buffer "NEWBUF" (point-min) (point-max))
  (switch-to-buffer "NEWBUF"))

(defun reload-init-file ()
  (interactive)
  (load-file user-init-file))

(global-set-key (kbd "C-c r") 'reload-init-file)

  (setq erc-server "irc.libera.chat"
        erc-track-shorten-start 8
        erc-autojoin-channels-alist '(("irc-libera.chat" "#emacs" "linux")))
