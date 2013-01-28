#usage: title short_tab_title looooooooooooooooooooooggggggg_windows_title
#http://www.faqs.org/docs/Linux-mini/Xterm-Title.html#ss3.1
#Fully support screen, iterm, and probably most modern xterm and rxvt
#Limited support for Apple Terminal (Terminal can't set window or tab separately)
function title {
  # AC My modifications
  # #echo "My term: $TERM ; title: $1"
  # if [[ "$TERM" == screen* ]]; then 
  #   print -Pn "\ek$1\e\\" #set screen hardstatus, usually truncated at 20 chars
  #   print -Pn "\e]1;$2\a" # window title
  # elif [[ ($TERM == xterm*) ]] || [[ ($TERM == "xterm-color") ]] || [[ ($TERM == "rxvt") ]] || [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
  #   print -Pn "\e]2;$2\a" #set window name
  #   print -Pn "\e]1;$1\a" #set icon (=tab) name (will override window name on broken terminal)

  if [[ "$DISABLE_AUTO_TITLE" == "true" ]] || [[ "$EMACS" == *term* ]]; then
    return
  fi
  if [[ "$TERM" == screen* ]]; then
    print -Pn "\ek$1:q\e\\" #set screen hardstatus, usually truncated at 20 chars
  elif [[ "$TERM" == xterm* ]] || [[ $TERM == rxvt* ]] || [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
    print -Pn "\e]2;$2:q\a" #set window name
    print -Pn "\e]1;$1:q\a" #set icon (=tab) name (will override window name on broken terminal)
  fi
}

ZSH_THEME_TERM_TAB_TITLE_IDLE="%15<..<%~%<<" #15 char left truncated PWD
ZSH_THEME_TERM_TITLE_IDLE="%n@%m: %~"
 # local SHORT_PWD="%8<..<%~%<<" #15 char left truncated PWD

function ac_precmd {
  local SHORT_PWD=`basename $PWD`
  
  if [[ -z "$TERM_TOPIC" ]]; then
	  local what="$SHORT_PWD"
  else
	  local what="$TERM_TOPIC"
  fi

  if [[ "$TERM" == screen* ]]; then 
    title "$what" "$MY_TERM_TITLE:$what"
  elif [[ ($TERM == xterm*) ]]; then
    title "$MY_TERM_TITLE:$what" "$MY_TERM_TITLE:$what"
  fi
    
}

function topic {
    export TERM_TOPIC="$1"
}

function ac_preexec {
    emulate -L zsh
    setopt extended_glob
    local CMD=${1[(wr)^(*=*|sudo|ssh|-*)]} #cmd name only, or if this is sudo or ssh, the next cmd
    local SHORT_PWD=`basename $PWD`

  if [[ -z "$TERM_TOPIC" ]]; then
	  local what="$SHORT_PWD"
  else
	  local what="$TERM_TOPIC"
  fi


    if [[ "$TERM" == screen* ]]; then 
        title "$what:$CMD" "$MY_TERM_TITLE:$what:$CMD"
    elif [[ ($TERM == xterm*) ]]; then
        title "$MY_TERM_TITLE:$what:$CMD" "$MY_TERM_TITLE:$what:$CMD"
    fi
}

#Appears when you have the prompt
function omz_termsupport_precmd {
  title $ZSH_THEME_TERM_TAB_TITLE_IDLE $ZSH_THEME_TERM_TITLE_IDLE
}

#Appears at the beginning of (and during) of command execution
function omz_termsupport_preexec {
  emulate -L zsh
  setopt extended_glob
  local CMD=${1[(wr)^(*=*|sudo|ssh|rake|-*)]} #cmd name only, or if this is sudo or ssh, the next cmd
  title "$CMD" "%100>...>${2:gs/%/%%}%<<"
}

autoload -U add-zsh-hook
# add-zsh-hook precmd  omz_termsupport_precmd
# add-zsh-hook preexec omz_termsupport_preexec
# add-zsh-hook precmd  ac_precmd
# add-zsh-hook preexec ac_preexec
