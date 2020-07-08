ENABLE_DOCKER_COMPOSE_ALIASES=0  # 1 to enable 

# ============ Basics ============
alias vzshrc='vim ~/.zshrc'
alias vbashrc=vzshrc
# caution: zshrc may not be idempotent
alias zshrc='source ~/.zshrc'
alias bashrc=zshrc
alias valiasrc='vim ~/.alias.sh'
alias vextrarc='vim ~/.extra.sh'
alias aliasrc='source ~/.alias.sh && source ~/.extra.sh'

alias df='df -h'  # default to human readable figures
alias du='du -h'
alias grep='grep --color'                     # show differences in colour
alias egrep='egrep --color=auto'              # show differences in colour
alias fgrep='fgrep --color=auto'              # show differences in colour
# exa: replacement for ls https://the.exa.website/
alias l='exa -F'                 # classify files in colour
alias lt='exa -FT'
alias ls='exa -F'
alias ll='exa -FlbH'                              # long list
alias lla='exa -FlbHa'                              # long list
alias llt='exa -FlbHT'                              # long list
alias la='exa -Fa'                              # all but . and ..
alias ldir='exa -FDH'
alias ldira='exa -FDHa'
alias v='vim'
alias vdiff='vim -d'
alias colordiff='vim -d'
alias more='more -d'
alias catl='cat -vtn'  # show line number
alias cp='cp -rf'
alias mk=make
alias grepr='grep --ignore-case -rn '
alias findr='find . -name'
alias clr=clear
#alias task='pstree | grep'
alias task='ps -A --forest | grep' #grep a task name and its process ID
#alias g++='g++ -std=c++11'

# ====== trash can ======
# ZSH_OS_TYPE is exported in ~/.zshrc
if [ $ZSH_OS_TYPE = "mac" ]; then
    # brew install trash
    alias rm='trash -F'  # uses Finder API, that will enable "Put Back" feature
    # https://apple.stackexchange.com/questions/376916/cannot-ls-trash-in-the-terminal-in-catalina-operation-not-permitted
    # you need to give terminal app "Full Disk Access" to access ~/.Trash
    alias rmlist='printf "Listing ~/.Trash ...\n\n" && l ~/.Trash'
    alias rmres='open ~/.Trash'
#    alias _rmempty='\rm -rf ~/.Trash/*'
    alias rmempty='trash -e'
elif [ ! -z `command -v trash-put` ]; then
    alias rm='trash-put'
    alias rmlist='trash-list'
    alias rmres='trash-restore'
    alias _rmempty='trash-empty'
elif [ ! -z `command -v gomi` ]; then
    alias rm='gomi'
    alias rmlist='gomi -b'
    alias rmres='gomi -b'
    alias rmresg='gomi -B'  # --restore-by-group
    alias _rmempty='\rm -rf ~/.gomi'
else
    alias rm='rm -rf'
    alias rmlist='echo please install either `gomi` or `trash-cli`. On mac, `brew install rmtrash`.'
    alias rmres=rmlist
    alias _remempty=rmlist
fi

# if _rmempty alias is set
if [[ ! -z `alias _rmempty` ]]; then
    function rmempty() {
        # delegates to _rmempty
        read -q "ans?Do you really want to empty trash? "
        echo
        case $ans in
            [Yy]* ) _rmempty && echo trash emptied;;
            * ) echo operation cancelled;;
        esac
    }
fi

alias rrm='\rm -rf'  # use the original `rm`, disable any alias
alias rmtemp='rm -f *~ .*~ .*.swp'

alias ...='../..'
alias ....='../../..'

# ================= Git =================
#alias gs='git status -uno'
alias gm='git commit'
alias gmm='git commit -m'
alias gmf='git commit -a' #skip the staging and commit directly
alias gmmf='git commit -a -m' #skip the staging step
alias gam='git commit --amend'
alias gdiff='git diff --color'
alias gdfc='git diff --color --cached'
alias ggrep='git grep'
alias grmc='grm -r --cached' # remove without deleting
alias logmore='git log --color --graph'
alias logdiff='git log -p --color --graph'
alias logorigin='git log -p --color --graph origin..'
alias logstat='git log --stat --summary --color'
#alias log='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias log='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset"'
alias gl=log
alias gsave='git format-patch --stdout origin > '
alias gmv='git mv'
#alias grm='git rm -f'
alias pusho='git push origin master'
alias pushfo='git push -f origin master'
alias push='git push origin'
alias pushf='git push -f origin'
alias pull='git pull'
alias pullo='git pull origin'
alias pullu='git pull upstream master'
alias fetch='git fetch'
alias fetcho='git fetch origin'
alias grem='git remote'
#alias gb='git branch'
#alias gc='git checkout'
#alias gmg='git merge'
#alias gst='git stash'
#alias grev='git revert'
#alias gres='git reset'
#alias gundo='git reset --soft HEAD^'
#alias greshh='git reset --hard HEAD'
alias gbis='git bisect'
alias gbisg='git bisect good'
alias gbisb='git bisect bad'


# ============ Tmux =============
export TMUX=''
alias tnew='tmux new -s'
alias tls='tmux ls'

function ta() {
    if [[ $# -eq 0 ]]; then
        cmd='tmux a'
    else
        cmd="tmux a -t $1"
    fi
    echo $cmd
    eval $cmd
}

function tkill() {
    if [[ $# -eq 0 ]]; then
        cmd='tmux kill-session'
    else
        cmd="tmux kill-session -t $1"
    fi
    echo $cmd
    eval $cmd
}

# ============ Docker =============
alias dim='docker image'
alias dimp='docker image prune'
alias dims='docker images'
alias drmi='docker rmi'
alias drm='docker rm'
alias dco='docker container'
alias dcop='docker container prune'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dpsp='docker container prune'
alias drun='docker run --gpus all'
alias druni='docker run -it --gpus all'
alias dexec='docker exec --gpus all'
alias dstart='docker start '
alias dstarti='docker start -i '
alias dhis='docker history'
alias dpull='docker pull'
alias dpush='docker push'
alias dstop='docker stop'
alias dkill='docker kill'
function dbash {
    docker run -it --rm --gpus all $1 bash
}
function dzsh {
    docker run -it --rm --gpus all $1 zsh
}

# ====== docker-compose 
if [ $ENABLE_DOCKER_COMPOSE_ALIASES = "1" ]; then
    alias dc='docker-compose'
    alias dcexec='docker-compose exec'
    function dczsh {
        docker-compose exec $1 zsh
    }
    alias dcz=dczsh
    function dcbash {
        docker-compose exec $1 bash
    }
    alias dcps='docker-compose ps'
    alias dcpau='docker-compose pause'
    alias dcpause='docker-compose pause'
    alias dcunp='docker-compose unpause'
    alias dcstart='docker-compose start'
    alias dcstop='docker-compose start'
    alias dcres='docker-compose restart'
    alias dclog='docker-compose logs'
    alias dcev='docker-compose events'
    alias dcrm='docker-compose rm'
    alias dct='docker-compose top'
    alias dctop='docker-compose top'
fi

# new docker build enhancement in latest Docker
export DOCKER_BUILDKIT=1

# =============== SSH =================
alias autossh='autossh -M 0 -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3"'
# port forwarding: (ID, local_port, remote_port)
#function portge() {
#    autossh -N -L localhost:$2:localhost:$3 $( get_sge $1 )
#}

alias sshstart='sudo service ssh start'
alias sshstop='sudo service ssh stop'
alias sshrestart='sudo service ssh --full-restart'

# =============== Network =================
# use rsync as a drop-in replacement for builtin cp
# add --progress if you want to see more verbose
alias rsyncp='rsync -raz --ignore-existing --info=progress2 --human-readable'
alias axeln='axel -n 16'

function getip() {
    ifconfig en0 | perl -n -e 'if (m/inet ([\d\.]+)/g) { print $1 }'
    echo
}

# ============== Python and ML ===============
alias py=ipython
alias act='conda activate'
alias deact='conda deactivate'
alias nvi='nvidia-smi'
alias jup='jupyter lab'
alias jupn='jupyter notebook'
alias tb='tensorboard --port 6006 --logdir'
function killgpus() {
    nvidia-smi | grep 'python' | awk '{ print $3 }' | xargs -n1 kill -9
}
function pipupload() {
    rm -rf dist/
    python setup.py sdist bdist_wheel
    twine upload dist/*
}
function md2rst() {
    pandoc --from=markdown --to=rst --output=$2 $1
}
function rst2md() {
    pandoc --from=rst --to=markdown --output=$2 $1
}

# ============== GCloud ===============
alias gsutilcp='gsutil -m cp -r'
alias gcinit='gcloud compute config-ssh'
alias gci='gcloud compute instances'
alias gcattach='gcloud compute instances attach-disk'
alias gcdetach='gcloud compute instances detach-disk'
alias gcls='gcloud compute instances list'
alias gssh='gcloud compute ssh'
alias gscp='gcloud compute scp --recurse'

# ============== Misc ===============
function showcolor() {
    for i in {0..255}; do print -Pn "%K{$i} %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%8)):#7}:+$'\n'}; done
}
