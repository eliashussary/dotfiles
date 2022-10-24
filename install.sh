
# install oh-my-zsh
if [ -z $ZSH ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

os="linux"
case $(uname -s) in
    Linux*)     os="linux";;
    Darwin*)    os="mac";;
esac

if [ $os = "linux" ]; then
    # install packages
    sudo apt install -y bat vim httpie
    
    # link bat
    mkdir -p ~/.local/bin
    ln -sf /usr/bin/batcat ~/.local/bin/bat
fi


git config --global core.editor "vim"

# append the dotfile zshrc if it doesn't already exist
ZSHRC_LINE="source ~/dotfiles/.zshrc"
TARGET_ZSHRC=~/.zshrc

grep -qxF "$ZSHRC_LINE" $TARGET_ZSHRC || echo "$ZSHRC_LINE" >> $TARGET_ZSHRC

curl https://get.volta.sh | bash
volta install node
