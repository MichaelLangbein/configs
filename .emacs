;; ------------------------------------------------------
;; -------------------- 1. Setup ------------------------
;; ------------------------------------------------------

;; Setting up `package`
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/") t)
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

(use-package zenburn-theme
  :ensure t  ;; ensure causes packages to be installed if not present.
  :config (load-theme 'zenburn t))

(use-package spaceline
  :ensure t)

(use-package spaceline-config
  :ensure spaceline
  :config
    (spaceline-emacs-theme))


;; javascript setup
(use-package js2-mode
  :config
    (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
    ;; on js2 load, also load imenu
    (add-hook 'js2-mode-hook #'js2-imenu-extras-mode))

(use-package js2-refactor
  :ensure js2-mode
  :config
    ;; on js2 load, also load js2-refactor
    (add-hook 'js2-mode-hook #'js2-refactor-mode)
    (js2r-add-keybindings-with-prefix "C-c C-r")
    (define-key js2-mode-map (kbd "C-k") #'js2r-kill))

(use-package xref-js2
  :ensure js2-mode
  :config
    (add-hook 'js2-mode-hook (lambda () (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)))
    ;; js-mode binds M-., which conflicts with this package. unbinding.
    (define-key js-mode-map (kbd "M-.") nil))


;; ------------------------------------------------------
;; -------------------- 3. Others -----------------------
;; ------------------------------------------------------

(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq visible-bell 1)
(global-display-line-numbers-mode)
;; (speedbar 1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (all-the-icons xref-js2 js2-refactor zenburn-theme use-package spaceline js2-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
