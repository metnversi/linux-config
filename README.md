- This repos saving for my debian-base distro configure: vim, emacs, bash, i3, tmux.
- Also copied some (many) ref from my idol, [rexim/dotfiles](https://github.com/rexim/dotfiles). Give him 1 sub on twitch  [tsoding](https://www.twitch.tv/tsoding) or youtube [tsoding-daily](https://www.youtube.com/@TsodingDaily/featured), you will find many thing to learn on him! 
- Delete stupid white space and refresh package each time start emacs. Maybe Rexim dont think thats hard to use, but I do.
- I unbinded all his spec key, also adding some my custom variable (color, layout, styles, some function...)
## How to custom:
### emacs
- Notice the `.emacs.rc/rc.el`. Its where you define package refresh and installing behavior
- Next check `.emacs`: here is where you define package installing,  function and custom key binding.
```bash
(add-to-list 'load-path "~/.emacs.local/")
(load "~/.emacs.rc/rc.el")
(load "~/.emacs.rc/misc-rc.el")
(load "~/.emacs.rc/org-mode-rc.el")
```
### vim
- Just check vim documentation or rexim sample one. I dont using his.
## Deploy 
- Make sure you have some knowledge about Emacs and Linux first before decide to deployin. 
```bash
git clone http://github.com/metnversi/linux-config.git
cd linux-config
sudo ./deploy.sh
./deploy.sh
```
## License
No licence. Because I steal code and combine them. Feel free with those public code because I steal public code tho haha.
