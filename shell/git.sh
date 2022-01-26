alias g='git'

rebase(){
    source="$1"
    target="$2"
    
    if [ -z "$1" ]
    then
        echo -e "please provide source branch\n"
        echo "grebase SOURCE [target]"
        return 2
    fi
    
    if [ -z "$2" ]
    then
        target=$(git branch --show-current)
    fi
    
    git checkout "$source" && \
    git pull && \
    git checkout "$target" && \
    git rebase "$source"
}