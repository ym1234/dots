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

(use-package helm
  :config
  (helm-autoresize-mode t)
  (setq helm-autoresize-max-height 30)
  (setq helm-display-header-line nil)
  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
  (helm-mode t))

