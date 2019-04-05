;;; faster emacs startup time

(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6)

(defvar startup/file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(defun startup/revert-file-name-handler-alist ()
  (setq file-name-handler-alist startup/file-name-handler-alist))
(defun startup/reset-gc ()
  (setq gc-cons-threshold 16777216
	gc-cons-percentage 0.1))

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)

(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(setq-default
 backup-inhibited t
 inhibit-startup-message t
 auto-save-default nil
 create-lockfiles nil
 make-backup-files nil
 ring-bell-function 'ignore)

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(setq-default use-package-always-ensure t)

(defconst custom-file "/dev/zero")

(set-frame-font "curie" nil t)

(use-package evil
  :config
  (evil-mode t)
  (setq evil-cross-lines t))

;; (use-package helm
;;   :config
;;   (helm-autoresize-mode t)
;;   (setq helm-autoresize-max-height 30)
;;   (setq helm-display-header-line nil)
;;   (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
;;   (helm-mode t))

(use-package haskell-mode)
(require 'haskell-interactive-mode)
(require 'haskell-process)

(setq haskell-process-type 'cabal-repl)
(setq haskell-process-log t)

(custom-set-variables
 '(haskell-interactive-types-for-show-ambiguous nil))

(add-hook 'haskell-mode-hook 'haskell-indent-mode)
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)
(add-hook 'haskell-mode-hook 'haskell-doc-mode)
(add-hook 'haskell-mode-hook 'hindent-mode)

(custom-set-variables
 '(haskell-process-suggest-remove-import-lines t)
 '(haskell-process-auto-import-loaded-modules t)
 '(haskell-process-log t)
 '(haskell-process-type 'cabal-repl))
(eval-after-load 'haskell-mode
  '(progn
     (define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-or-reload)
     (define-key haskell-mode-map (kbd "C-c C-z") 'haskell-interactive-switch)
     (define-key haskell-mode-map (kbd "C-c C-n C-t") 'haskell-process-do-type)
     (define-key haskell-mode-map (kbd "C-c C-n C-i") 'haskell-process-do-info)
     (define-key haskell-mode-map (kbd "C-c C-n C-c") 'haskell-process-cabal-build)
     (define-key haskell-mode-map (kbd "C-c C-n c") 'haskell-process-cabal)))
(eval-after-load 'haskell-cabal
  '(progn
     (define-key haskell-cabal-mode-map (kbd "C-c C-z") 'haskell-interactive-switch)
     (define-key haskell-cabal-mode-map (kbd "C-c C-k") 'haskell-interactive-mode-clear)
     (define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
     (define-key haskell-cabal-mode-map (kbd "C-c c") 'haskell-process-cabal)))

(use-package dante
  :ensure t
  :after haskell-mode
  :commands 'dante-mode
  :init
  (add-hook 'haskell-mode-hook 'dante-mode)
  (add-hook 'haskell-mode-hook 'flycheck-mode))

(load-theme 'hybrid-material t)
(mapc
  (lambda (face)
	(set-face-attribute face nil :weight 'normal))
  (face-list))

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))
(use-package flycheck-haskell)
(custom-set-variables
  '(haskell-process-type 'cabal-repl))

(setq-default indent-tabs-mode t)
(setq-default tab-width 4)
(defvaralias 'c-basic-offset 'tab-width)
(add-hook 'flycheck-mode-hook #'flycheck-haskell-setup)

(use-package ivy
  :ensure t
  :config
  (ivy-mode t))

(use-package company)
(use-package lsp-mode
  :commands lsp)

(use-package lsp-ui :commands lsp-ui-mode)
(use-package company-lsp :commands company-lsp)

(use-package rust-mode)
(use-package go-mode)
