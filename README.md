```
$cd ~
$mkdir work
$mkdir work/github
$cd work/github
$git clone git@github.com:sukesan1984/dotfiles.git
$cd ~
$ln -s work/github/dotfiles/.vim .
$ln -s work/github/dotfiles/.vimrc .
$vim
:BundleInstall
```
