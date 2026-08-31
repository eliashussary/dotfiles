#!/usr/bin/env bash
# Coder execs this directly rather than sourcing it, so the shebang has to name
# an interpreter the machine actually has. The workspace image is
# codercom/enterprise-base:ubuntu, which ships bash but not zsh — a #!/bin/zsh
# here fails as "no such file or directory", pointing at the interpreter rather
# than at this file.
set -eu

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

os="linux"
case "$(uname -s)" in
    Linux*)     os="linux";;
    Darwin*)    os="mac";;
esac

if [ "$os" = "linux" ]; then
    # The image clears /var/lib/apt/lists, so installing without refreshing
    # first fails with "Unable to locate package".
    sudo apt-get update -qq
    sudo apt-get install -y --no-install-recommends zsh bat vim httpie

    # link bat
    mkdir -p ~/.local/bin
    ln -sf /usr/bin/batcat ~/.local/bin/bat
fi

# $ZSH is only ever set inside an oh-my-zsh shell, never in this one, so the
# old -z test reinstalled on every run. KEEP_ZSHRC stops the installer
# replacing the ~/.zshrc appended to below, and --unattended stops it trying to
# chsh and launch an interactive shell.
if [ ! -d "${ZSH:-$HOME/.oh-my-zsh}" ]; then
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
        "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
        "" --unattended
fi

git config --global core.editor "vim"

# append the dotfile zshrc if it doesn't already exist
ZSHRC_LINE="source $DOTFILES/.zshrc"
TARGET_ZSHRC=~/.zshrc

touch "$TARGET_ZSHRC"
grep -qxF "$ZSHRC_LINE" "$TARGET_ZSHRC" || echo "$ZSHRC_LINE" >> "$TARGET_ZSHRC"

# pi plugins: the dex workspace template installs pi AFTER this script runs, so
# we cannot `pi install` here. Expose ~/personalize instead — the template runs
# it later, once pi is on PATH (see the `personalize` script in this repo).
if [ -f "$DOTFILES/personalize" ]; then
    chmod +x "$DOTFILES/personalize"
    ln -sf "$DOTFILES/personalize" "$HOME/personalize"
fi
