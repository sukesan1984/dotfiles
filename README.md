```
$cd ~
$mkdir work
$mkdir work/github
$cd work/github
$git clone git@github.com:sukesan1984/dotfiles.git
$cd dotfiles.git
$git submodule init
$git submodule update
$cd ~
$ln -s work/github/dotfiles/.vim .
$ln -s work/github/dotfiles/.vimrc .
$ln -s work/github/dotfiles/.fzf.zsh .
$touch ~/.vimrc.local
$vim
:BundleInstall

```
