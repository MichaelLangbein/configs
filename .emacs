;; ------------------------------------------------------
;; -------------------- 1. Setup ------------------------
;; ------------------------------------------------------

;; Setting up `package`
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Setting up the `use-package` macro
;; This is a wrapper around `require`.
;; All commands after the :config keyword are being executed after require was successful.
(unless
    (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))


;; ------------------------------------------------------
;; -------------------- 2. JS utils --------------------
;; ------------------------------------------------------

(defun npm-list (name)
  (shell-command-to-string
   (concat "npm list -g " name)))

(defun npm-module-installed (name)
  "checks if a given npm-module is globally installed"
  (interactive)
  (not (string-match-p "empty" (npm-list name))))

(defun check-npm-requirements ()
  (dolist (x '("prettier" "typescript-language-server"))
    (if (not (npm-modle-installed x))
	(message (concat "WARNING: npm-module not installed globally: " x)))))

(defun create-new-ts-project (path name)
  "creates a new ts-project and moves emacs-projectile into the dir"
  (interactive "sPath to new project: \nsName of new project: ")
  (progn
    (shell-command (concat "cd " path
                           " && mkdir " name " && cd " name
                           " && git init"
                           " && npm init -y"
                           " && npm install --save-dev typescript jest ts-jest"
                           " && mkdir src"
                           " && touch src/index.ts"
                           " && npx tsx --init"
                           " && npx ts-jest config:init"))
    (find-file (concat path "/" name "/src/index.ts"))))

;; ------------------------------------------------------
;; -------------------- 3. Packages ---------------------
;; ------------------------------------------------------

;; making sure that prettier and lsp can find all those npm packages
(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-nord-light t)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (doom-themes-visual-bell-config)
  (setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
  (doom-themes-treemacs-config))

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode))

;; requires you to also manually install all the ttf files in the github-repo.
(use-package all-the-icons
  :ensure t)

;; projectile searches for a .git dir and treats everything from there as a project.
;; makes file-jumping easier by restricting choices to only within the current project.
(use-package projectile
  :ensure t
  :config
  (define-key projectile-mode-map (kbd "C-x C-p") 'projectile-command-map)
  (projectile-mode +1))

(use-package dashboard
  :ensure t
  :after (projectile all-the-icons)
  :init
  (progn
    (setq dashboard-items '((recents . 5)
			    (projects . 5)))
    (setq dashboard-set-file-icons t)
    (setq dashboard-startup-banner "~/banner.png") ;; 'logo)
    )
  :config
  (dashboard-setup-startup-hook))

(use-package treemacs
  :ensure t)

(use-package centaur-tabs
  :ensure t
  :config
  (setq centaur-tabs-set-bar 'over
	centaur-tabs-set-icons t
	centaur-tabs-grey-out-icons 'buffer
	centaur-tabs-set-modified-marker t
	centaur-tabs-modifier-marker ".")
  (centaur-tabs-mode t))

;; company-mode: a autocomplete-dropdown. on its own only searches within current file.
(use-package company
  :ensure t
  :config
  (setq company-minimum-prefix-length 1
	company-idle-delay 0.0) ;; default is 0.2
  :init
  (add-hook 'after-init-hook 'global-company-mode))

(use-package multiple-cursors
  :ensure t
  :bind
  (("C-x n" . mc/mark-next-like-this)
   ("C-x p" . mc/mark-previous-like-this)))


;; lsp performance
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb
(setq lsp-completion-provider :capf)
(setq lsp-idle-delay 0.500)
;; @todo: (setq lsp-file-watch-ignored ...someregex...)

(use-package lsp-mode
    :ensure t
    :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
           ;; (XXX-mode . lsp)
	    (rjsx-mode . lsp)
            (lsp-mode . lsp-enable-which-key-integration))
    :config
    (setq lsp-clients-typescript-server "typescript-language-server"
	  lsp-clients-typescript-server-args '("--stdio")
	  lsp-keymap-prefix "C-c l")
    ;; (global-set-key (kbd "=") =)
    :commands lsp)

;; lsp-mode for ts needs the following glal packages:
;; npm install -g --save typescript typescript-language-serverx

(use-package lsp-ui
  :ensure t
  :after (lsp-mode)
  :commands lsp-ui-mode)

(use-package lsp-treemacs
  :ensure t
  :after (lsp-mode)
  :commands lsp-treemacs-errors-list)

;; suggests completions for entered key-combos
(use-package which-key
  :ensure t
  :config (which-key-mode))

(use-package rjsx-mode
  :ensure t
   :mode "\\.[jt]s\\'")

;; requires `npm install -g prettier`
(use-package prettier-js
  :ensure t
  :after (rjsx-mode)
  :hook (rjsx-mode . prettier-js-mode))


;; ------------------------------------------------------
;; -------------------- 4. Others -----------------------
;; ------------------------------------------------------

(set-face-attribute 'default nil :height 109)

(tool-bar-mode -1)

(menu-bar-mode -1)

(scroll-bar-mode -1)

(setq visible-bell 1)

(global-display-line-numbers-mode)

(global-hl-line-mode 1)

(show-paren-mode 1)

;; ido: a better file-explorer-bar. a popular alternative would be helm, another ivy.
(setq ido-everywhere t)
(setq ido-enable-flex-matching t)
(ido-mode t)


;; ------------------------------------------------------
;; -------------------- 5. Keybindings ------------------
;; ------------------------------------------------------

(global-set-key (kbd "C-x f") 'treemacs)

(defun toggle-terminal ()
  (interactive)
  (if (eq major-mode 'shell-mode)
      (delete-window)
      (shell)))

(global-set-key (kbd "C-x t") 'toggle-terminal)

;; ------------------------------------------------------
;; -------------------- 6. TODOs ------------------------
;; ------------------------------------------------------

;; spell-checking (sugestion: flyspell)
