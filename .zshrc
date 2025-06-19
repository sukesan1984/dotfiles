# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/kosuketakami/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/kosuketakami/google-cloud-sdk/path.zsh.inc'; fi
source ~/.zsh_profile

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
alias vim='nvim'
alias vi='nvim'
alias ls='lsd'
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
if [ $SHLVL = 1 ]; then
  tmux
fi
echo .zshrc

source ~/work/github/zsh-python-prompt/zshrc.zsh
RPROMPT+=$ZSH_PYTHON_PROMPT
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt share_history
eval "$(direnv hook zsh)"

if [ -n "${commands[fzf-share]}" ]; then
  source "$(fzf-share)/key-bindings.zsh"
  source "$(fzf-share)/completion.zsh"
fi
