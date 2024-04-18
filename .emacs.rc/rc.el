(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
;; (add-to-list 'package-archives
;;              '("melpa-stable" . "https://stable.melpa.org/packages/") t)

;;(defvar rc/package-contents-refreshed nil)

;;(defun rc/package-refresh-contents-once ()
;;  (when (not rc/package-contents-refreshed)
;;    (setq rc/package-contents-refreshed t)
;;    (package-refresh-contents)))

;;(defvar rc/package-contents-refreshed nil)

;;metn/require to install package
(defun metn/require-one-package (package)
  (if package
      (if (not (package-installed-p package))
          (progn
            (if rc/package-contents-refreshed
                nil
              (setq rc/package-contents-refreshed t)
              (package-refresh-contents))
            (package-install package)))
    (error "Package name cannot be nil")))

(defun metn/require (&rest packages)
  (dolist (package packages)
    (metn/require-one-package package)))

(defun metn/require-theme (theme)
  (let ((theme-package (->> theme
                            (symbol-name)
                            (funcall (-flip #'concat) "-theme")
                            (intern))))
    (metn/require theme-package)
    (load-theme theme t)))

(metn/require 'dash)
(require 'dash)

(metn/require 'dash-functional)
(require 'dash-functional)
