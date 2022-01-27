for file in ~/dotfiles/shell/.*;
do
    source $file
done

if [ ! -z $SPIN ]; then
    PROMPT="$(hostname) $PROMPT"
    git config --add oh-my-zsh.hide-status 1
    git config --add oh-my-zsh.hide-dirty 1
fi