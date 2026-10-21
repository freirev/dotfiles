# -----------------
#  Exports & Paths
# -----------------
export EDITOR=vim
export VISUAL=vim
export TEXMFHOME="$HOME/.local/share/texmf"
export PATH="$HOME/.local/bin:$PATH"

# -----------------
#  General Settings
# -----------------
unsetopt BEEP
unsetopt AUTO_CD
stty -ixon 2>/dev/null

# Home, End, and Delete across terminal emulators and SSH
bindkey '^[[H'  beginning-of-line
bindkey '^[OH'  beginning-of-line
bindkey '^[[F'  end-of-line
bindkey '^[OF'  end-of-line
bindkey '^[[3~' delete-char

# Ctrl + Left / Right for word navigation
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# History configuration (required for predictive text across sessions)
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Prefix history search
autoload -U up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# -----------------
#  Completion & Wildmenu
# -----------------
zmodload -i zsh/complist
autoload -Uz compinit && compinit -C

# Enable interactive arrow-key wildmenu & case-insensitive matching
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
bindkey -M menuselect '^M' .accept-line

# -----------------
#  Prompt & Plugins
# -----------------
git_custom_status() {
  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null) || return
  local dirty=""
  [[ -n $(git status --porcelain 2>/dev/null) ]] && dirty="%F{#e06c75}*"
  echo "${dirty}%F{green}[${branch}]%f"
}
setopt PROMPT_SUBST
PROMPT='$(git_custom_status)%F{cyan}[%F{#e5c07b}%m%F{cyan}:%~]%f$ '

# Load zsh-autosuggestions
if [ -f "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
  bindkey '^ ' autosuggest-accept
fi

# -----------------
#  Aliases
# -----------------
alias ll='ls -alh --color=auto'
alias la='ls -A --color=auto'

# Use gvim in terminal mode only if installed (falls back to standard vim on SSH)
if command -v gvim >/dev/null 2>&1; then
  alias vim='gvim -v'
fi

# -----------------
#  Local Overrides
# -----------------
# Untracked file for machine-specific secrets or cluster module loads
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
