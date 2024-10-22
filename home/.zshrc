# Exports
export HOMESHICK_DIR="$HOME/.homesick/repos/homeshick"
export ZSH="$HOME/.oh-my-zsh"
export PATH="$PATH:/opt/homebrew/bin:$HOME/.homesick/repos/dotfiles/scripts:$HOME/.homesick/repos/emoji-cli"
export FZF_DEFAULT_OPTS="--ansi --height='80%' --preview-window='right:60%'"

source "$HOMESHICK_DIR/homeshick.sh"


# ohmyzsh config stuff
#
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="avit"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(forgit zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Filename search and code preview

alias fcode="FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git' fzf --preview='bat --color=always {}'"

# Gitmoji search and clipboard copy
alias fmoji="gitmoji -l | fzf | cut -d ' ' -f3"

git-c-moji() {
  git commit -m "$(fmoji)" -e "$@"
}

alias gtree="git log --graph --decorate --oneline --all"

# FZF setup
eval "$(fzf --zsh)"

# FZF history
#
# fh() {
#   pushln $(([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac --exact | gsed -r 's/ *[0-9]*\*? *//' | gsed -r 's/\\/\\\\/g')
#   zle reset-prompt
#   zle get-line
# }
# 
# zle -N __fzf_history fh
# 
# bindkey "\C-r" __fzf_history

# NPM bump version

alias bump-major='npm version major --no-git-tag-version'
alias bump-minor='npm version minor --no-git-tag-version'
alias bump-patch='npm version patch --no-git-tag-version' 

# AWS CLI
complete -C '/opt/homebrew/bin/aws_completer' aws

# Docker stuff

container-shell () {
  docker exec -it $(docker ps | tail -n +2 | fzf | cut -w -f1) /bin/sh
}

container-logs () {
  docker container logs $(docker ps | tail -n +2 | fzf | cut -w -f1) "$@"
}

docker-image-rm () {
  docker image ls | tail -n +2 | fzf --multi | cut -w -f 1,2 | while read image tag; do
    docker image rm $image:$tag
  done
}

docker-clean-up () {
  docker-image-rm
  docker system prune
  docker volume prune
}

# MISC

if [ /usr/local/bin/kubectl ]; then source <(kubectl completion zsh); fi

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# MOTD

icalBuddy -f -n -nc -sd -eep notes,attendees eventsToday | tail -n +3
task list

## API quotes: curl -s https://favqs.com/api/qotd | jq '"\(.quote.body) - \(.quote.author)"'
alias random-quote='fortune | cowsay -f $(ls $(readlink -f $(brew --prefix cowsay))/share/cows | grep "\.cow" | grep -v "head-in" | sort -R | head -1) | lolcat'
random-quote
