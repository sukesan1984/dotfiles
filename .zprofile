export MANPATH=${HOME}/work/man/minilibx/man3:
alias vim='nvim'
alias vi='nvim'
if [ $SHLVL = 1 ]; then
  tmux
fi
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

export PATH="/usr/local/Cellar/rbenv/1.2.0/bin:$PATH"
