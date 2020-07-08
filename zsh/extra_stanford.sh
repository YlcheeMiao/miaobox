# for stanford cluster only

alias cdd=''
alias rtx='conda activate rtx'
alias mi='conda activate mi'
# Run kinit and then reauth on RTX WS2, otherwise you'll get permission denied after a while
alias reauth='/afs/cs/software/bin/reauth'
alias sc='ssh sc'

# folder shortcut
HOME_SC=/vision/u/jimfan  # macondo-ws-2 is on /afs
alias cdc="cd $HOME_SC/code"
alias cdd="cd $HOME_SC/code/kitten"
alias cde="cd $HOME_SC/code/enlight"
alias cdi="cd $HOME_SC/code/iGibson"
alias cdm="cd $HOME_SC/model"

# dc wrapper (for docker-compose) from embrio repo
alias dcps='dc ps'
alias dcl='dc l'
alias dcp='dc pause'
alias dcr='dc resume'
alias dcx='dc sh'
alias dcup='dc up'
alias dcd='dc down'
alias dct='dc top'


# ============= added by Anaconda3 2018.12 installer
# BUG WARNING: https://github.com/ContinuumIO/anaconda-issues/issues/10173#issuecomment-441386441
# you need to use ~/vision instead of /sailhome/jimfan/vision to avoid a slow 10-second startup!
# >>> conda init >>>
__conda_setup="$('/vision/u/jimfan/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/vision/u/jimfan/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/vision/u/jimfan/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/vision/u/jimfan/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/vision2/u/jimfan/install/google-cloud-sdk/path.zsh.inc' ];
    then source '/vision2/u/jimfan/install/google-cloud-sdk/path.zsh.inc';
fi

# The next line enables shell command completion for gcloud.
if [ -f '/vision2/u/jimfan/install/google-cloud-sdk/completion.zsh.inc' ];
    then source '/vision2/u/jimfan/install/google-cloud-sdk/completion.zsh.inc';
fi

export PATH=/usr/local/cuda-10.1/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-10.1/lib64:~/.mujoco/mujoco200/bin:/usr/lib/nvidia-418:$LD_LIBRARY_PATH



# ======= TEMPORARY =======
# activate mi
conda activate mi
# to work with Deepmind reverb
export LD_LIBRARY_PATH=/vision2/u/jimfan/anaconda3/envs/mi/lib:$LD_LIBRARY_PATH
