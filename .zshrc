# Located from this file rather than a fixed ~/src path: Coder clones the
# dotfiles to ~/.config/coderv2/dotfiles, where the old absolute path matched
# nothing and the loop silently sourced no files.
# (.N) keeps the glob to regular files and expands to nothing when there are
# none, instead of erroring on an unmatched pattern.
for file in ${0:A:h}/shell/.*(.N); do
    source $file
done
