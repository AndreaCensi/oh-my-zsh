#usage: title short_tab_title looooooooooooooooooooooggggggg_windows_title
#http://www.faqs.org/docs/Linux-mini/Xterm-Title.html#ss3.1
#Fully support screen, iterm, and probably most modern xterm and rxvt
#Limited support for Apple Terminal (Terminal can't set window or tab separately)
function title {
  #echo "My term: $TERM ; title: $1"
  if [[ "$TERM" == screen* ]]; then 
    print -Pn "\ek$1\e\\" #set screen hardstatus, usually truncated at 20 chars
    
    # NOT SURE what these do if anything
    # Works only remotely
    print -Pn "\e]1;|$1\a"
  elif [[ ($TERM == xterm*) ]] || [[ ($TERM == "xterm-color") ]] || [[ ($TERM == "rxvt") ]] || [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
    print -Pn "\e]2;$2\a" #set window name
    print -Pn "\e]1;$1\a" #set icon (=tab) name (will override window name on broken terminal)
  fi
  
   # print -Pn "\e]1;$2\a"
   # print -Pn "\e]1;$1\a"
}

ZSH_THEME_TERM_TAB_TITLE_IDLE="%15<..<%~%<<" #15 char left truncated PWD
ZSH_THEME_TERM_TITLE_IDLE="%n@%m: %~"
 # local SHORT_PWD="%8<..<%~%<<" #15 char left truncated PWD

function precmd {
  local SHORT_PWD=`basename $PWD`
  
  if [[ "$TERM" == screen* ]]; then 
    title "$TERM_TOPIC$SHORT_PWD"
  elif [[ ($TERM == xterm*) ]]; then
    title "$MY_TERM_TITLE:$SHORT_PWD" "$MY_TERM_TITLE:$SHORT_PWD"
  fi
    
}

function topic {
    export TERM_TOPIC="$1|"
}

function preexec {
    emulate -L zsh
    setopt extended_glob
    local CMD=${1[(wr)^(*=*|sudo|ssh|-*)]} #cmd name only, or if this is sudo or ssh, the next cmd

    local SHORT_PWD=`basename $PWD`

    if [[ "$TERM" == screen* ]]; then 
        title "$TERM_TOPIC$SHORT_PWD:$CMD" "$TERM_TOPIC$SHORT_PWD:$CMD"
    elif [[ ($TERM == xterm*) ]]; then
        title "$MY_TERM_TITLE:$SHORT_PWD:$CMD" "$MY_TERM_TITLE:$SHORT_PWD:$CMD"
    fi

}
