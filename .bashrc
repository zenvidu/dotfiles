# ==========================================================================
#
#	██████╗ ███████╗ ██████╗  █████╗ ███████╗██╗   ██╗███████╗
#	██╔══██╗██╔════╝██╔════╝ ██╔══██╗██╔════╝██║   ██║██╔════╝
#	██████╔╝█████╗  ██║  ███╗███████║███████╗██║   ██║███████╗
#	██╔═══╝ ██╔══╝  ██║   ██║██╔══██║╚════██║██║   ██║╚════██║
#	██║     ███████╗╚██████╔╝██║  ██║███████║╚██████╔╝███████║
#	╚═╝     ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚══════╝
#
# ==========================================================================

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# --- Blesh (Bash Line Editor) Setup ---
#Only load if the file exists and shell is interactive
if [[ -f /usr/share/blesh/ble.sh && $- == *i* ]]; then
  source -- "/usr/share/blesh/ble.sh" --attach=none
fi

# if [ -f fastfetch ]; then
# 	fastfetch
# fi

# --- Bash Completion ---
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# --- History Settings ---
HISTCONTROL=ignoreboth
shopt -s histappend
shopt -s checkwinsize
HISTSIZE=1000
HISTFILESIZE=2000
HISTTIMEFORMAT="%F %T "

# --- Environment Variables ---
export EDITOR="nvim"
export VISUAL="nvim"
export SUDO_EDITOR="nvim"

#######################################################################
# Aliases

# Safe sourcing: only load if file exists
[ -f ~/.alitemp ] && source ~/.alitemp

# Alias's to modified commands
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias mkdir='mkdir -p'
alias vi='nvim'
alias rsync='rsync -avhP'
alias s='yay -Ss'
alias sl='pacman -Ss'
alias install='sudo pacman -S --needed'
alias instally='yay -S --needed'
alias upgrade='sudo pacman -Syu'
alias upgradey='yay -Syu'
alias uplist='pacman -Qu'
alias remove='sudo pacman -Rns'
alias removey='yay -Rns'
alias purge='sudo pacman -Rn'
alias dpkgs='sudo pacman -Swu'
alias cpkgs='sudo pacman -Sc'
alias cat='bat --style=-numbers'
alias t='tree'

# Git
gcom() {
  git commit -m "$1"
}

lazyg() {
  git add .
  git commit -m "$1"
  git push
}

alias gpush='git push'

# Change directory aliases
alias ..='cd ..'
alias ...='cd ../..'
alias home='cd ~'
alias root='cd /'

# Search command line history
#alias h="history | grep "

# Mount .iso files
alias isomount='sudo mount -o loop'

# Start v2ray connection
alias startv2ray='sudo systemctl start v2raya.service'
alias stopv2ray='sudo systemctl stop v2raya.service'

# Start windows file sharing
alias smbstart='sudo systemctl start smbd.service nmbd.service'
alias smbstop='sudo systemctl stop smbd.service nmbd.service'
alias smbstats='sudo systemctl status smbd.service nmbd.service'

# Alias's for modified directory listing commands
alias l='eza -ll --color=always --group-directories-first'
alias ls='eza -al --header --icons --group-directories-first'

# IP address lookup aliase
alias myip="ip -f inet address | grep inet | grep -v 'lo$' | cut -d ' ' -f 6,13 && curl ifconfig.me && echo ' external ip'"

# Alias's for archives
#alias zp='7z a -t7z -mx=9'
#alias uz='7z x'
#alias ut='tar -xvf'

# Unixporn
alias ff='fastfetch'
alias ascii='ascii-image-converter'
alias fact='fortune | cowsay -f snowman | lolcat'

# Uncategorized aliases
alias diskhealth='sudo gsmartcontrol'
alias sysinfo='inxi -b'
alias x='exit'

#######################################################################
# Special Functions

# Automatically do an ls after each cd
cd() {
  z "$@" && l
}
# FIX: Use 'builtin cd' to prevent recursion with zoxide
# cd() {
#   builtin cd "$@" && l
# }

# Make a directory and cd into it
mkdirc() {
  mkdir "$@" && cd "${@: -1}"
}

# Copy file with a progress bar
cpp() {
  rsync "${1}" "${2}"
}

# Goes up a specified number of directories  (i.e. up 4)
up() {
  local d=""
  limit=$1
  for ((i = 1; i <= limit; i++)); do
    d=$d/..
  done
  d=$(echo $d | sed 's/^\///')
  if [ -z "$d" ]; then
    d=..
  fi
  cd "$d"
}

# Change the current working directory when exiting Yazi
y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd <"$tmp"
  if [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
    clear
    l
  fi
  rm -f -- "$tmp"
}

# Beautiful man pages
mann() {
  man "$1" | bat -l man --style=-numbers
}

# Search command line history
h() {
  history | grep -i -- "$@"
}

# Extract any archive file
un() {
  local archive="$1"
  local dest="${2:-.}"

  if [[ -z "$archive" ]]; then
    echo "Usage: un <archive> [destination]"
    return 1
  fi

  if [[ ! -f "$archive" ]]; then
    echo "Error: '$archive' does not exist."
    return 1
  fi

  mkdir -p "$dest" || return 1

  case "${archive,,}" in
  *.tar | *.tar.gz | *.tgz | *.tar.bz2 | *.tbz2 | *.tar.xz | *.txz | *.tar.zst | *.tzst)
    tar -xf "$archive" -C "$dest"
    ;;
  *.zip | *.7z)
    7z x -o"$dest" "$archive"
    ;;
  *.rar)
    unrar x "$archive" "$dest/"
    ;;
  *.gz)
    (
      cd "$dest" &&
        gunzip -c "$OLDPWD/$archive" >"${archive##*/}"
    )
    ;;
  *.bz2)
    (
      cd "$dest" &&
        bunzip2 -c "$OLDPWD/$archive" >"${archive##*/%.bz2}"
    )
    ;;
  *.xz)
    (
      cd "$dest" &&
        xz -dc "$OLDPWD/$archive" >"${archive##*/%.xz}"
    )
    ;;
  *)
    echo "Unsupported archive format: $archive"
    return 1
    ;;
  esac
}

# Android device as a microphone
# Usage: micdroid <local-ip>:<device-adb-port>
micdroid() {
  local ip_port="$1"
  adb connect "$ip_port" && audiosource -s "$ip_port" run || echo "Connection failed"
}

#######################################################################

# set variable identifying the chroot you work in (used in the prompt below)
# Note: This is mostly legacy; Starship usually handles the prompt visuals.
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# Initialize Tools
eval "$(starship init bash)"
eval "$(zoxide init --cmd z bash)"

# Attach Blesh at the very end
[[ ! ${BLE_VERSION-} ]] || ble-attach
