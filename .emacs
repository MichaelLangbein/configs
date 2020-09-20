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
;; -------------------- 2. Packages ---------------------
;; ------------------------------------------------------

(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-material t)
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
  (define-key projectile-mode-map (kbd "C-x p") 'projectile-command-map)
  (projectile-mode +1))

(use-package dashboard
  :ensure t
  :after (projectile all-the-icons)
  :init
  (progn
    (setq dashboard-items '((recents . 5)
			    (projects . 5)))
    (setq dashboard-set-file-icons t)
    ;; (setq dashboard-startup-banner "")
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
  (("C-c n" . mc/mark-next-like-this)
   ("C-c p" . mc/mark-previous-like-this)))

;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
(setq lsp-keymap-prefix "s-l")

(use-package lsp-mode
    :ensure t
    :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
           ;; (XXX-mode . lsp)
	    (rjsx-mode . lsp) ;; npm i -g javascript-typescript-langserver
            (lsp-mode . lsp-enable-which-key-integration))
    :commands lsp)

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


;; ;; flycheck checks syntax on the fly. supports a ton of languages. for js/ts, requires `npm install -g eslint` or `jshint`
;; (use-package flycheck
;;   :ensure t
;;   :init
;;   (global-flycheck-mode))

(use-package rjsx-mode
  :ensure t
   :mode "\\.[jt]s\\'")

;; ;; requires `npm install -g typescript`
;; (defun setup-tide-mode ()
;;   'setup function for tide'
;;   (interactive)
;;   (tide-setup)
;;   (flycheck-mode +1)
;;   (setq flycheck-check-syntax-automatically '(save mode-enabled))
;;   (tide-hl-identifier-mode +1)  ;; highlights all occurrences of hovered variable
;;   (company-mode +1))

;; (use-package tide
;;   :ensure t
;;   :after (rjsx-mode company flycheck)
;;   :hook
;;   (rjsx-mode . setup-tide-mode)
;;   (before-save-hook . tide-format-before-save)
;;   (typescript-mode-hook . #'setup-tide-mode))

;; requires `npm install -g prettier`
(use-package prettier-js
  :ensure t
  :after (rjsx-mode)
  :hook (rjsx-mode . prettier-js-mode))


;; ------------------------------------------------------
;; -------------------- 3. Others -----------------------
;; ------------------------------------------------------

(tool-bar-mode -1)

(scroll-bar-mode -1)

(setq visible-bell 1)

(global-display-line-numbers-mode)

(global-hl-line-mode 1)

(show-paren-mode 1)

;; ido: a better file-explorer-bar. a popular alternative would be helm.
(setq ido-everywhere t)
(setq ido-enable-flex-matching t)
(ido-mode t)


;; ------------------------------------------------------
;; -------------------- 4. TODOs ------------------------
;; ------------------------------------------------------

;; multicorsor (sugestion: mc)
;; spell-checking (sugestion: flyspell)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (lsp-treemacs lsp-ui lsp-mode zenburn-theme xref-js2 which-key use-package treemacs tide tern spaceline smartparens rjsx-mode projectile prettier-js js2-refactor golden-ratio doom-themes doom-modeline dashboard company centaur-tabs))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
