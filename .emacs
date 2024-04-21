;; Initialize the package system if it's not already done
(unless 
(bound-and-true-p package--initialized)   
  (package-initialize))

(add-to-list 'load-path "~/.emacs.local/")
(load "~/.emacs.rc/rc.el")
(load "~/.emacs.rc/misc-rc.el")
(load "~/.emacs.rc/org-mode-rc.el")

;; word font, required pre-installed in your system.
;; here is Iosevka font, size 10
(defun rc/get-default-font ()
  (cond 
    ((eq system-type 'gnu/linux) "Iosevka-10")))

(add-to-list 'default-frame-alist `(font . ,(rc/get-default-font)))
;;remove welcome screen and menu bar
(setq inhibit-startup-screen t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode 0)
(column-number-mode 1)
(show-paren-mode 1)

(metn/require-theme 'gruber-darker)
(setq package-install-upgrade-built-in t)

;; set font size, 
;; enable emacs clipboard same system clipboard
(setq x-select-enable-clipboard t)
(setq x-select-enable-primary t)
(setq save-interprogram-paste-before-kill t)
(setq yank-pop-change-selection t)

;;auto save
(setq auto-save-default nil)
(auto-save-visited-mode 1)
(setq auto-save-visited-interval 0) ;;interval to save file: no

;;auto saving before leave
(add-hook 'kill-emacs-hook
          (lambda ()
            (save-some-buffers t)))

;; Enable ido mode
(metn/require 'smex 'ido-completing-read+)
(require 'ido-completing-read+)
(ido-mode 1)
(ido-everywhere 1)
(ido-ubiquitous-mode 1)

;;line number green
(setq-default display-line-numbers 'visual)
(setq-default display-line-numbers-widen t)

;;you can set it relative number here or in the custom variable in the bottom
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

;; assembly mode
;;(require 'basm-mode)
;;(require 'fasm-mode)
;;(add-to-list 'auto-mode-alist '("\\.asm\\'" . fasm-mode))
;;(require 'porth-mode)
;;(require 'noq-mode)
;;(require 'jai-mode)
;;(require 'simpc-mode)
;;(add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))

;; Enable electric pair mode
(electric-pair-mode 1)
(add-hook 'prog-mode-hook #'hs-minor-mode)

;; in emacs version older, use-package will be resulted as an error. Comment this out may help.
(use-package avy
    :ensure t
    :bind ("M-g" . avy-goto-line))

;;; Packages that don't require configuration
(metn/require
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

(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

(defun jump-relative (line)
    "Jump to a line relative to the current line."
    (interactive "nLine offset: ")
    (forward-line line))
(global-set-key (kbd "C-c j") 'jump-relative)

(global-set-key (kbd "<f5>") '(lambda () (interactive) (revert-buffer nil t t)))

;; change font size
;; (set-face-attribute 'default nil :height 120)
;; Increase font size
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
;;key to refresh emacs
(global-set-key (kbd "<f5>") '(lambda () (interactive) (revert-buffer nil t t)))


;;move whole line up and down
(defun move-line-up ()
  "Move up the current line."
  (interactive)
  (transpose-lines 1)
  (forward-line -2)
  (indent-according-to-mode))

(defun move-line-down ()
  "Move down the current line."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1)
  (indent-according-to-mode))
;; ALT + up/down  to move a whole line up and down like visual Studio code :)
(global-set-key (kbd "M-<up>") 'move-line-up)
(global-set-key (kbd "M-<down>") 'move-line-down)

(metn/require 'company)
(add-hook 'after-init-hook 'global-company-mode)

;; Add company-c-headers to company-backends
(add-to-list 'company-backends 'company-c-headers)
;; Specify the system headers path for company-c-headers
(add-to-list 'company-c-headers-path-system "/usr/include/c++/12/")
(add-to-list 'company-c-headers-path-system "/usr/include/x86_64-linux-gnu/c++/12")
;; Specify the project headers path for company-c-headers
(add-to-list 'company-c-headers-path-user "/path/to/your/project/headers/")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(company-statistics yasnippet-snippets yaml-mode windresize use-package typescript-mode tuareg toml-mode sml-mode smex scala-mode rust-mode rfc-mode racket-mode qml-mode purescript-mode php-mode paredit org-cliplink nix-mode nim-mode nginx-mode multiple-cursors magit lua-mode lsp-mode kotlin-mode jinja2-mode ido-completing-read+ hindent helm haskell-mode gruber-darker-theme graphviz-dot-mode go-mode glsl-mode evil embark elpy dracula-theme dockerfile-mode dash-functional d-mode csharp-mode corfu company-c-headers cmake-mode clojure-mode cape avy ag 0x0)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
