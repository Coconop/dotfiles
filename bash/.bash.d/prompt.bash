#!/bin/bash

#
# Set the prompt #
#

# Select git info displayed, see /usr/share/git/completion/git-prompt.sh for more
export GIT_PS1_SHOWDIRTYSTATE=1           # '*'=unstaged, '+'=staged
export GIT_PS1_SHOWSTASHSTATE=1           # '$'=stashed
export GIT_PS1_SHOWUNTRACKEDFILES=1       # '%'=untracked
export GIT_PS1_SHOWUPSTREAM="verbose"     # 'u='=no difference, 'u+1'=ahead by 1 commit
export GIT_PS1_STATESEPARATOR=''          # No space between branch and index status
export GIT_PS1_DESCRIBE_STYLE="describe"  # detached HEAD style:
#  contains      relative to newer annotated tag (v1.6.3.2~35)
#  branch        relative to newer tag or branch (master~4)
#  describe      relative to older annotated tag (v1.6.3.1-13-gdd42c2f)
#  default       exactly eatching tag

# Check if we support colours
__colour_enabled() {
    local -i colors=$(tput colors 2>/dev/null)
    [[ $? -eq 0 ]] && [[ $colors -gt 2 ]]
}
unset __colourise_prompt && __colour_enabled && __colourise_prompt=1

__set_bash_prompt()
{
    local exit="$?" # Save the exit status of the last command

    if [[ $__colourise_prompt ]]; then
        export GIT_PS1_SHOWCOLORHINTS=1

        # Wrap the colour codes between \[ and \], so that
        # bash counts the correct number of characters for line wrapping:
        #TODO check https://unix.stackexchange.com/a/447520
        # Classic colors            Bold Text
        local Red='\[\e[0;31m\]'; local BRed='\[\e[1;31m\]'
        local Gre='\[\e[0;32m\]'; local BGre='\[\e[1;32m\]'
        local Yel='\[\e[0;33m\]'; local BYel='\[\e[1;33m\]'
        local Blu='\[\e[0;34m\]'; local BBlu='\[\e[1;34m\]'
        local Mag='\[\e[0;35m\]'; local BMag='\[\e[1;35m\]'
        local Cya='\[\e[0;36m\]'; local BCya='\[\e[1;36m\]'
        local Whi='\[\e[0;37m\]'; local BWhi='\[\e[1;37m\]'
        local HRed='\[\e[0;91m\]'; local BRed='\[\e[1;91m\]'
        local HGre='\[\e[0;92m\]'; local BGre='\[\e[1;92m\]'
        local HYel='\[\e[0;93m\]'; local BYel='\[\e[1;93m\]'
        local HBlu='\[\e[0;94m\]'; local BBlu='\[\e[1;94m\]'
        local HMag='\[\e[0;95m\]'; local BMag='\[\e[1;95m\]'
        local HCya='\[\e[0;96m\]'; local BCya='\[\e[1;96m\]'
        local HWhi='\[\e[0;97m\]'; local BWhi='\[\e[1;97m\]'

        local None='\[\e[0m\]' # Return to default colour
    else
        unset GIT_PS1_SHOWCOLORHINTS

        local Red=''; local BRed=''
        local Gre=''; local BGre=''
        local Yel=''; local BYel=''
        local Blu=''; local BBlu=''
        local Mag=''; local BMag=''
        local Cya=''; local BCya=''
        local Whi=''; local BWhi=''
        local None=''
    fi

    local clr=""

    if [[ ${EUID} == 0 ]]; then
        is_root="${HRed}#${None}"
        clr=${Red}
    else
        clr=${HCya}
    fi

    # Visual last status code
    if [[ $exit -eq 0 ]]; then
        status="${Gre}•${None}"
    else
        status="${Red}•${None}"
    fi

    # Detect virtual env
    if [[ -n "$VIRTUAL_ENV" ]];
    then
        local ven_ps1="${HYel}($(basename $VIRTUAL_ENV))${HCya}"
    else
        local ven_ps1="-"
    fi

    # Detect AWS CLI
    if [[ -n "$AWS_PROFILE" ]];
    then
        local aws_ps1="${HYel}[${AWS_PROFILE}/${AWS_REGION}]${HCya}"
    else
        local aws_ps1=""
    fi

    # Detect SSH session
    if [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
        local ssh_ps1="${Yel}󰒍${clr}"
    else
        local ssh_ps1="${Gre}󰌢${clr}"
    fi

    local time="\t"
    local cur_dir="\w"
    local usr="\u${ssh_ps1}\h"
    local is_root="\$"

    local PreGitPS1="${clr}[${usr}][${aws_ps1}${HBlu}${time}${clr}]${ven_ps1}[${Whi}${cur_dir}${clr}]("

    local PostGitPS1="${clr}) ${status}\r\n"
    PostGitPS1+="${clr}└─${is_root}${None} "

    __git_ps1 "$PreGitPS1" "$PostGitPS1" '%s'

    # echo '$PS1='"$PS1" # debug
}

# This tells bash to reinterpret PS1 after every command, Which we
# need because __git_ps1 will return different text and colors
PROMPT_COMMAND=__set_bash_prompt

# Append each command to history, clear current session and reloads history
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
