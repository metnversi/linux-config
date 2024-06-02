- This repository saves my configurations for the Debian-based distro, including Vim, Emacs, Bash, i3, and Tmux.
- I also copied some (or many) references from my coding idol, [rexim/dotfiles](https://github.com/rexim/dotfiles). You can learn a lot from Rexim by subscribing to his channels: [tsoding]( https://www.twitch.tv/tsoding) on Twitch and [tsoding-daily]( https://www.youtube.com/@TsodingDaily/featured) on YouTube.
- While Rexim might not find it difficult to remove unnecessary whitespace and refresh packages on every Emacs startup, I do. That's why I unbound his special keybindings and added my own custom variables for colors, layout, styles, and some functions.

## How to Customize:
### Emacs
- Pay attention to the `.emacs.rc` or `.emacs.d` file (depending on your setup). This is where you define package refresh and installation behavior.
- Next, check the `.emacs` file. This is where you define package installation, functions, and custom key bindings.
```bash
(add-to-list 'load-path "~/.emacs.local/")
(load "~/.emacs.rc")
(load "~/.emacs.d/misc-rc.el") 
(load "~/.emacs.d/org-mode-rc.el") 
```
### Vim
- Refer to the Vim documentation or use Rexim's sample configuration as a starting point (although I prefer my own setup).

## Deployment
- It's recommended to have some basic understanding of Emacs and Linux before deploying this configuration.
- Improved Deployment Script (assuming the script is named `deploy.sh`):
```Bash
git clone https://github.com/metnversi/linux-config.git
cd linux-config
```
- Uncomment those line in `.emacs.rc/rc.el`:
```Bash
;; (add-to-list 'package-archives
;;              '("melpa-stable" . "https://stable.melpa.org/packages/") t)

;;(defvar rc/package-contents-refreshed nil)

;;(defun rc/package-refresh-contents-once ()
;;  (when (not rc/package-contents-refreshed)
;;    (setq rc/package-contents-refreshed t)
;;    (package-refresh-contents)))

;;(defvar rc/package-contents-refreshed nil)
```
- Exit all editor. run:
```Bash
sudo ./deploy.sh
./deploy.sh
```
after done installed all package for emacs, you can comment them out again to avoid refrshing package each time start up.

