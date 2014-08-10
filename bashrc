# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u\[\033[00m\]@\[\033[01;32m\]\h \[\033[00m\]\l \[\033[01;34m\]\j\n\[\033[01;33m\]\w\[\033[00m\]\n\#\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h \l \j\n\w\n\#\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\n\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# add external programs
PATH="/usr/local/texlive/2012/bin/i386-linux:$PATH";
PATH="/usr/local/MATLAB/R2012a/bin:$PATH";
PATH="/usr/local/comsol43/bin:$PATH";
PATH="/usr/local/physim/bin:$PATH";
PATH="/usr/local/java/jdk/bin:$PATH";
PATH="/usr/local/java/jdk/jre/bin:$PATH";
PATH="/usr/local/cuda/bin:$PATH";
PATH="/usr/lib/nvidia-current/bin:$PATH";
export PATH;
MANPATH="/usr/local/java/jdk/man:$MANPATH";
export MANPATH;
PKG_CONFIG_PATH="/usr/local/physim/lib/pkgconfig:$PKG_CONFIG_PATH"
export PKG_CONFIG_PATH;
LDFLAGS="-L/usr/local/physim/lib $LDFLAGS";
LDFLAGS="-L/usr/local/cuda/lib $LDFLAGS";
LDFLAGS="-L/usr/local/cuda/extras/CUPTI/lib $LDFLAGS";
LDFLAGS="-L/usr/local/java/jogamp/jar/lib $LDFLAGS";
LDFLAGS="-L/usr/lib/nvidia-current $LDFLAGS";
CPPFLAGS="-I/usr/local/physim/include $CPPFLAGS";
CPPFLAGS="-I/usr/local/java/jdk/include $CPPFLAGS"
CPPFLAGS="-I/usr/local/java/jdk/include/linux $CPPFLAGS"
CPPFLAGS="-I/usr/local/cuda/include $CPPFLAGS"
CPPFLAGS="-I/usr/local/cuda/extras/CUPTI/include $CPPFLAGS"
CPPFLAGS="-I/usr/local/cuda/extras/Debugger/include $CPPFLAGS"
export LDFLAGS;
export CPPFLAGS;
LD_LIBRARY_PATH="/usr/local/physim/lib:$LD_LIBRARY_PATH";
LD_LIBRARY_PATH="/usr/local/cuda/lib:$LD_LIBRARY_PATH";
LD_LIBRARY_PATH="/usr/local/cuda/extras/CUPTI/lib:$LD_LIBRARY_PATH";
LD_LIBRARY_PATH="/usr/local/java/jogamp/jar/lib:$LD_LIBRARY_PATH";
LD_LIBRARY_PATH="/usr/lib/nvidia-current:$LD_LIBRARY_PATH";
export LD_LIBRARY_PATH;
CLASSPATH="/usr/local/java/jdk/lib:/usr/local/java/jdk/jre/lib:$CLASSPATH";
CLASSPATH="/usr/local/java/jogamp/jar/jogl-all.jar:$CLASSPATH";
CLASSPATH="/usr/local/java/jogamp/jar/joal.jar:$CLASSPATH";
CLASSPATH="/usr/local/java/jogamp/jar/jocl.jar:$CLASSPATH";
CLASSPATH="/usr/local/java/jogamp/jar/gluegen.jar:$CLASSPATH";
CLASSPATH="/usr/local/java/jogamp/jar/gluegen-rt.jar:$CLASSPATH";
export CLASSPATH;
if [ -d '/media/c0307d83-cbe2-433a-a5fd-cf4f04546e3c' ]; then
  export ANDROID_HOME="/media/c0307d83-cbe2-433a-a5fd-cf4f04546e3c/android-sdk-linux";
  export PATH="$ANDROID_HOME/tools:$ANDROID_HOME/build-tools:$ANDROID_HOME/platform-tools:$PATH";
fi

