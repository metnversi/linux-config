if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
CASE_SENSITIVE="true"
ENABLE_CORRECTION="true"

# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time
# zstyle ':omz:update' frequency 13
# HYPHEN_INSENSITIVE="true"
# DISABLE_MAGIC_FUNCTIONS="true"
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# COMPLETION_WAITING_DOTS="true"

# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="dd.mm.yyyy"

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

export LANG=en_US.UTF-8
if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='mvim'
 fi

# export ARCHFLAGS="-arch $(uname -m)
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh

# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias ll='ls -lrta'
alias cc='google-chrome-stable &'
alias vim='nvim'
alias ff='firefox &'
alias bb='librewolf &'
alias cf='fortune | cowsay'

PATH=/home/anna/.nimble/bin:/home/anna/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/usr/bin:/usr/bin:/snap/bin:/usr/sbin:/home/anna/.local/bin:/usr/local/go/bin
PATH="$PATH:/opt/nvim-linux64/bin"
. "$HOME/.cargo/env"
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
source $ZSH/oh-my-zsh.sh

# Move welcome.sh after oh-my-zsh.sh to avoid initialization issues
/home/anna/welcome.sh
fortune | cowsay

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform
#eval "$(starship init zsh)"
