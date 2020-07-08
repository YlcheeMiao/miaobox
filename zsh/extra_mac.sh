# for mac OS X
alias task='pstree | grep'

alias copy='pbcopy < ' #copy to clipboard
alias paste='pbpaste > ' #paste from clipboard
alias axeln='axel -n 6 -a -U "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/600.5.17 (KHTML, like Gecko) Maxel/2.2"'
alias ml='m lock'

# ============== Folder shortcut ===============
export PROG_DIR=~/Dropbox/Portfolio
alias dn='cd ~/Downloads'
alias doc='cd ~/Documents'
alias cdd="cd $PROG_DIR"
alias cdres='cd ~/Dropbox/Research/Resume'
alias cdweb='cd ~/Dropbox/Programming/Web/jimfan.github.io'

# =============== ssh
function scfs() {
    mount_fs ~/sshfs/sc sc.stanford.edu /vision/u/jimfan/
}

function pifs() {
    mount_fs ~/sshfs/pi pi@pi.eonalabs.com /home/pi
}

# alias sshmc='sshpass jimfan@macondo-ws-2.stanford.edu'
alias sshmc='sshop'
alias sshm0='sshop -r m0'
alias sshm4='sshop -r m4'
# alias sc='ssh -X sc.stanford.edu'
alias sc='sshop -r sc'
alias sshpi='ssh -X pi@pi.eonalabs.com'
alias sshgiga1='ssh -X jarvis@giga1.eonalabs.com'

# ============= NGC
[[ -f $PROG_DIR/ngckit/alias.sh ]] && source $PROG_DIR/ngckit/alias.sh

# ============= Misc utils =============

function pkgunpack() {
    temp_dir="$1_content"
    pkgutil --expand "$1" $temp_dir
    cd $temp_dir/*.pkg
    mkdir contents
    tar xf Payload -C contents
    open contents
}

function adbobb() {
    # oculus quest upload obb folder
    adb push "$1" /sdcard/Android/obb
}

function netease_run() {
    music_path=~/Music/netease_cache
    netease $music_path --history $music_path/netease_history.json
    open $music_path
}

alias fixapp='sudo xattr -rd com.apple.quarantine'


# ============== envs ================
export GOPATH=~/Code/go
export PATH=$PATH:$GOPATH/bin
#export DISPLAY=:0

# for NGC
export LC_ALL=en_US.UTF-8

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/jimfan/anaconda/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/jimfan/anaconda/etc/profile.d/conda.sh" ]; then
        . "/Users/jimfan/anaconda/etc/profile.d/conda.sh"
    else
        export PATH="/Users/jimfan/anaconda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

if [ -f '/Users/jimfan/Code/google-cloud-sdk/path.zsh.inc' ];
    then source '/Users/jimfan/Code/google-cloud-sdk/path.zsh.inc';
fi
if [ -f '/Users/jimfan/Code/google-cloud-sdk/completion.zsh.inc' ];
    then source '/Users/jimfan/Code/google-cloud-sdk/completion.zsh.inc';
fi
