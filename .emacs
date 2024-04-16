;;(require 'package)
;;(add-to-list 'package-archives
;;                         '("melpa" . "https://melpa.org/packages/") t)

;; Initialize the package system if it's not already done
(unless (bound-and-true-p package--initialized) 
  (setq package-enable-at-startup nil) 
  (package-initialize))

(add-to-list 'load-path "~/.emacs.local/")

(load "~/.emacs.rc/rc.el")

(load "~/.emacs.rc/misc-rc.el")
(load "~/.emacs.rc/org-mode-rc.el")
(load "~/.emacs.rc/autocommit-rc.el")


(defun rc/get-default-font ()
  (cond 
    ((eq system-type 'gnu/linux) "Iosevka-20")))

(add-to-list 'default-frame-alist `(font . ,(rc/get-default-font)))
;;remove welcome screen and menu bar
(setq inhibit-startup-screen t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode 0)
(column-number-mode 1)
(show-paren-mode 1)

(rc/require-theme 'gruber-darker)

;;set font size
(set-face-attribute 'default nil :height 140)
(setq x-select-enable-clipboard t)
(setq x-select-enable-primary t)
(setq save-interprogram-paste-before-kill t)
(setq yank-pop-change-selection t)


;;auto save
(setq auto-save-default nil)
(auto-save-visited-mode 1)
(setq auto-save-visited-interval nil) ;;interval to save file
;;auto saveing before leave
(add-hook 'kill-emacs-hook
          (lambda ()
            (save-some-buffers t)))

;; Enable ido mode
(rc/require 'smex 'ido-completing-read+)
(require 'ido-completing-read+)
(ido-mode 1)
(ido-everywhere 1)
(ido-ubiquitous-mode 1)

;;line number green
(setq-default display-line-numbers 'visual)
(setq-default display-line-numbers-widen t)
(setq display-line-numbers-type 'relative)
(set-face-attribute 'line-number-current-line nil
                    :foreground "green")
;;; c-mode
(setq-default c-basic-offset 4
              c-default-style '((java-mode . "java")
                                (awk-mode . "awk")
                                (other . "bsd")))

(add-hook 'c-mode-hook (lambda ()
                         (interactive)
                         (c-toggle-comment-style -1)))
;;; Emacs lisp
(add-hook 'emacs-lisp-mode-hook
          '(lambda ()
             (local-set-key (kbd "C-c C-j")
                            (quote eval-print-last-sexp))))
(add-to-list 'auto-mode-alist '("Cask" . emacs-lisp-mode))


(require 'basm-mode)

(require 'fasm-mode)
(add-to-list 'auto-mode-alist '("\\.asm\\'" . fasm-mode))

(require 'porth-mode)

(require 'noq-mode)

(require 'jai-mode)

(require 'simpc-mode)
(add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))

;;; Whitespace mode
(defun rc/set-up-whitespace-handling ()
  (interactive)
  (whitespace-mode 1)
  (add-to-list 'write-file-functions 'delete-trailing-whitespace))

(add-hook 'tuareg-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'c++-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'c-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'simpc-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'emacs-lisp-mode 'rc/set-up-whitespace-handling)
(add-hook 'java-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'lua-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'rust-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'scala-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'markdown-mode-hook 'rc/set-up-whitespace-handling)
;;(add-hook 'haskell-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'python-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'erlang-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'asm-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'fasm-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'go-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'nim-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'yaml-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'porth-mode-hook 'rc/set-up-whitespace-handling)


;; Install and configure helm, for auto suggest finding file.
;;; helm
(rc/require 'helm 'helm-cmd-t 'helm-git-grep 'helm-ls-git)
(setq helm-ff-transformer-show-only-basename nil)
(global-set-key (kbd "C-c h t") 'helm-cmd-t)
(global-set-key (kbd "C-c h g g") 'helm-git-grep)
(global-set-key (kbd "C-c h g l") 'helm-ls-git-ls)
(global-set-key (kbd "C-c h f") 'helm-find)
(global-set-key (kbd "C-c h a") 'helm-org-agenda-files-headings)
(global-set-key (kbd "C-c h r") 'helm-recentf)


;; Enable electric pair mode
(electric-pair-mode 1)
;; Bind C-= to zoom in
(global-set-key (kbd "C-=") 'text-scale-increase)

;; Bind C-- to zoom out
(global-set-key (kbd "C--") 'text-scale-decrease)

(add-hook 'prog-mode-hook #'hs-minor-mode)

               
;; Install and configure company-mode for auto-completion
;;; Company
(rc/require 'company)
(require 'company)

(global-company-mode)

(add-hook 'tuareg-mode-hook
          (lambda ()
            (interactive)
            (company-mode 0)))

(use-package avy
    :ensure t
    :bind ("M-g" . avy-goto-line))


;;; Packages that don't require configuration
(rc/require
 'scala-mode
 'd-mode
 'yaml-mode
 'glsl-mode
 'tuareg
 'lua-mode
 'less-css-mode
 'graphviz-dot-mode
 'clojure-mode
 'cmake-mode
 'rust-mode
 'csharp-mode
 'nim-mode
 'jinja2-mode
 'markdown-mode
 'purescript-mode
 'nix-mode
 'dockerfile-mode
 'love-minor-mode
 'toml-mode
 'nginx-mode
 'kotlin-mode
 'go-mode
 'php-mode
 'racket-mode
 'qml-mode
 'ag
 'hindent
 'elpy
 'typescript-mode
 'rfc-mode
 'sml-mode
 )

(load "~/.emacs.shadow/shadow-rc.el" t)

(defun astyle-buffer (&optional justify)
  (interactive)
  (let ((saved-line-number (line-number-at-pos)))
    (shell-command-on-region
     (point-min)
     (point-max)
     "astyle --style=kr"
     nil
     t)
    (goto-line saved-line-number)))

(add-hook 'simpc-mode-hook
          (lambda ()
            (interactive)
            (setq-local fill-paragraph-function 'astyle-buffer)))

(require 'compile)


(defun jump-relative (line)
    "Jump to a line relative to the current line."
    (interactive "nLine offset: ")
    (forward-line line))
(global-set-key (kbd "C-c j") 'jump-relative)

(global-set-key (kbd "<f5>") '(lambda () (interactive) (revert-buffer nil t t)))

;; change font size
;; Increase font size
(global-set-key (kbd "C-+") 'text-scale-increase)

;; Decrease font size
(global-set-key (kbd "C--") 'text-scale-decrease)

;; Set default font size
(set-face-attribute 'default nil :height 100)


custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(display-line-numbers-type (quote relative))
 '(org-agenda-dim-blocked-tasks nil)
 '(org-agenda-exporter-settings (quote ((org-agenda-tag-filter-preset (list "+personal")))))
 '(org-cliplink-transport-implementation (quote url-el))
 '(org-enforce-todo-dependencies nil)
 '(org-modules
   (quote
    (org-bbdb org-bibtex org-docview org-gnus org-habit org-info org-irc org-mhe org-rmail org-w3m)))
 '(org-refile-use-outline-path (quote file))
 '(package-selected-packages
   (quote
    (rainbow-mode proof-general elpy hindent ag qml-mode racket-mode php-mode go-mode kotlin-mode nginx-mode toml-mode love-minor-mode dockerfile-mode nix-mode purescript-mode markdown-mode jinja2-mode nim-mode csharp-mode rust-mode cmake-mode clojure-mode graphviz-dot-mode lua-mode tuareg glsl-mode yaml-mode d-mode scala-mode move-text nasm-mode editorconfig tide company powershell js2-mode yasnippet helm-ls-git helm-git-grep helm-cmd-t helm multiple-cursors magit haskell-mode paredit ido-completing-read+ smex gruber-darker-theme org-cliplink dash-functional dash)))
 '(safe-local-variable-values
   (quote
    ((eval progn
           (auto-revert-mode 1)
           (rc/autopull-changes)
           (add-hook
            (quote after-save-hook)
            (quote rc/autocommit-changes)
            nil
            (quote make-it-local))))))
 '(whitespace-style
   (quote
    (face tabs spaces trailing space-before-tab newline indentation empty space-after-tab space-mark tab-mark))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
