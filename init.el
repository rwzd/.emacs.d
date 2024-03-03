;; Tips to Make Emacs Life Easy:
;; -----------------------------
;;     - Do not set environment variables inside Emacs.
;;     - Do not assume well-behaving Unix.
;;     - Keep Emacs stuff in one file, and one file only.
;;     - No updates in normal operation! Make it different from default start-up. (TODO)
;;     - Emacs Package store is not dependable; we don't know where it is, and it is cheap to donwload anyway.


;; Vanilla Dependencies
(require 'package)
(require 'subr-x)
(require 'cl-lib)

(progn

  (setq custom-file "~/.emacs_stuff/custom.el")
  (setq backup-directory-alist `(("." . "~/.emacs_stuff/backup")))
  
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
  
  (put 'narrow-to-region 'disabled nil)
  (setq find-file-visit-truename t)
  (setq python-shell-interpreter "python3")
  
  ;; Always carry a copy of the TTF file I guess.
  (add-to-list 'default-frame-alist
               '(font . "Ubuntu Mono-14")))

;; Org-Mode stuff.
(progn
  (add-hook 'org-mode-hook 'visual-line-mode)
  (setq org-startup-indented t)
  (setq org-startup-folded t)
  (global-set-key (kbd "C-c l") 'org-store-link)
  (global-set-key (kbd "C-c a") 'org-agenda)
  (global-set-key (kbd "C-c c") 'org-capture)
  (global-set-key (kbd "C-c i") 'org-id-get-create)
  (setq org-agenda-skip-scheduled-if-done t)
  (setq org-todo-keywords
	'((sequence "TODO" "WAITING" "|" "DONE" "CANCELLED")))
  (setq org-todo-keyword-faces
	'(("TODO" . (:foreground "firebrick" :background "black"))
	  ("WAITING" . (:foreground "DarkOrange2" :background "black"))
	  ("DONE" . (:foreground "black" :background "DarkGreen" :weight bold))
	  ("CANCELLED" . (:foreground "black" :background "RoyalBlue3" :weight bold))))
  (setq org-tag-persistent-alist
	'(("habit")
	  ("hazard")
	  ("hole")
	  ("journal"))))

(package-initialize)
(package-refresh-contents)
(if (not (package-installed-p 'use-package))
    (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; non-GUI Vanilla Function Calls
(progn
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (global-visual-line-mode)
  (setq inhibit-splash-screen t)
  ;; Will this work on old Emacsen? let's find out!
  (cd (getenv "HOME")))

(use-package magit)

(use-package helm
  :config
  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "C-x C-f") 'helm-find-files)
  (global-set-key (kbd "C-x b") 'helm-buffers-list))

(use-package popwin
  :config (popwin-mode 1))

; (use-package org-roam
  ; :config
  ; (add-to-list 'display-buffer-alist
               ; '("\\*org-roam\\*"
                 ; (display-buffer-in-direction)
                 ; (direction . right)
                 ; (window-width . 0.33)
                 ; (window-height . fit-window-to-buffer)))
  ; (setq org-roam-dailies-directory "daily/")
  ; (setq org-roam-dailies-capture-templates
        ; '(("d" "default" entry
           ; "* %?"
           ; :target (file+head "%<%Y-%m-%d>.org"
			      ; "#+title: %<%Y-%m-%d>\n"))))
  ; (global-set-key (kbd "C-c r") 'org-roam-buffer-toggle)
  ; (global-set-key (kbd "C-c t") 'org-roam-alias-add))


;;;(use-package auctex
 ;;; :config
 ;;; (setq TeX-auto-save t)
 ;;;(setq TeX-parse-self t)
  ;;;(setq-default TeX-master nil))

(use-package evil
  :config
  (setq evil-default-state 'emacs)
  (evil-mode 1))

;;;(use-package nim-mode
;;;  :config
;;;  ;;;(local-set-key (kbd "M->") 'nim-indent-shift-right)
;;;  ;;;(local-set-key (kbd "M-<") 'nim-indent-shift-left)
;;;  (when (string-match "/\.nimble/" (or (buffer-file-name) "")) (read-only-mode 1))
;;;  (add-hook 'nim-mode-hook 'nimsuggest-mode)
;;;  (add-hook 'nim-mode-hook 'electric-indent-local-mode))

(use-package paredit
  :pin nongnu)


; (use-package slime
  ; :config
  ; (setq inferior-lisp-program "sbcl"))

;;;(use-package rust-mode)

;;;(use-package go-mode)

;;;(use-package csharp-mode
;;;  :pin gnu)

;;;(use-package eglot-fsharp
;;;  :defer t
;;;  :ensure t)

(use-package eglot
  :pin gnu
  :config
  (setq eglot-server-programs
        '(
          (c++-mode . ("clangd"))
          (c-mode . ("clangd"))
          (python-mode . ("pyright-python-langserver" "--stdio"))
;         (nim-mode . ("nimlsp"))
;	  (rust-mode . ("rust-analyzer"))
;	  (go-mode . ("gopls"))
;	  (haskell-mode . ("haskell-language-server-wrapper" "--lsp" "--debug"))
;	  (csharp-mode . ("omnisharp" "-lsp"))
          ))
  (setq eldoc-echo-area-prefer-doc-buffer t))

;;;(use-package geiser-gauche)

(use-package haskell-mode)

(setq eldoc-echo-area-prefer-doc-buffer t)


(use-package doom-themes)

(load-theme 'doom-dark+ t)

(cond
 ((string-equal "windows-nt" system-type) ; TODO check for a blank file in home instead to see if this is my "home" pc
  (progn
    (setq org-agenda-files '("~/Documents/Roam/Timer.org"))
;    (setq org-roam-directory (file-truename "~/Documents/Roam"))
    (setq org-archive-location '("~/Documents/Roam/Done.org::"))
    (toggle-frame-fullscreen)
    (org-agenda-list)))
 (t ; Default
  (progn
    (add-to-list 'default-frame-alist
		 '(font . "Ubuntu Mono-18")))))

(when (>= emacs-major-version 26)
  ;; real auto save
  (auto-save-visited-mode 1)
  (setq auto-save-visited-interval 1))
