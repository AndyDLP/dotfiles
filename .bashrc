#!/bin/bash


export TMOUT=
export TIMEOUT=

if [[ $- == *i* ]]; then # in interactive session
	set -o vi
	# source ~/.local/share/blesh/ble.sh --attach=none
	bind 'set keyseq-timeout 1'
	stty time 0
fi

source ~/.bash_aliases

export FZF_DEFAULT_COMMAND='rg --files'
export FZF_DEFAULT_OPTS='-m --height 50% --border --reverse'
export EDITOR=nvim
export VISUAL=nvim
export ANSIBLE_NOCOWS=1

export HISTCONTROL="ignorespace:erasedups"
export HISTFILESIZE=-1
export HISTSIZE=-1
export HISTFILE=~/.bash_eternal_history
export TERM=xterm-256color
export MANPAGER="nvim +Man!"

t() {
	if tmux has-session -t default 2>/dev/null; then
		tmux attach-session -t default
	else
		# Create the new session. This implicitly creates the first window (e.g., default:1 if base-index is 1).
		tmux new-session -d -s default

		# Rename the first window that was just created by 'new-session' to 'shell'.
		# This assumes your base-index is 1, which is implied by the error.
		tmux rename-window -t default:1 'infra'
		tmux send-keys -t default:1 "cd ~/git/infra" C-m

		tmux new-window -d -t default:2 -n 'infra2'
		tmux send-keys -t default:2 "export INFRA=2" C-m
		tmux send-keys -t default:2 "source ~/.bash_aliases" C-m
		tmux send-keys -t default:2 "cdi" C-m

		tmux new-window -d -t default:3 -n 'infra3'
		tmux send-keys -t default:3 "export INFRA=3" C-m
		tmux send-keys -t default:3 "source ~/.bash_aliases" C-m
		tmux send-keys -t default:3 "cdi" C-m

		tmux new-window -d -t default:4 -n 'tools'
		tmux split-window -v -t default:4
		tmux split-window -h -t default:4
		tmux send-keys -t default:4.1 "workon infra311 && rpr" C-m # Pane 1 (top-left)
		tmux send-keys -t default:4.2 "og" C-m                     # Pane 2 (bottom-left)
		# tmux send-keys -t default:4.3 "ob" C-m                     # Pane 3 (bottom-right)
		tmux select-pane -t default:4.1

		tmux new-window -d -t default:5 -n 'notes'
		tmux send-keys -t default:5 "ob" C-m

		tmux new-window -d -t default:6 -n 'shell'
		tmux send-keys -t default:6 "cd ~/" C-m

		tmux attach-session -t default
	fi
}

gr() {
	git fetch --all
	git reset --hard "origin/$(git rev-parse --abbrev-ref HEAD)"
}

gdc() {
	git diff -B -M -C "$1^..$1"
}

kocdl() {
	cd "$HOME"
	kubectl ocd login "$*"
	cd -
}
kocdb() {
	cd "$(git rev-parse --show-toplevel)" || return
	cd "$(readlink -f ./)" || return
	k ocd build
}
gca() {
	local prevdir
	prevdir="$(pwd)"
	local IFS=' '
	cd "$(git rev-parse --show-toplevel)" && git add . && git commit -m "$*"
	cd "${prevdir}" || return
}

gch() {
	local branch_name
	local IFS=' '
	branch_name=$(git branch --sort=-committerdate | fzf --query="$1" | tr -d "[:space:]")
	if [ -z "$branch_name" ]; then
		echo "No branch selected."
		return
	fi
	git checkout "$branch_name"
}
function repeat() {
	local seconds=$1
	shift
	local command="$@"

	if [[ -z "$seconds" || -z "$command" ]]; then
		echo "Usage: repeat <seconds> <command>"
		return
	fi

	if [[ ! "$seconds" =~ ^[0-9]+$ ]]; then
		echo "Seconds must be a positive integer"
		return
	fi

	while true; do
		echo "Running: $command"
		eval $command
		sleep $seconds
	done
}

nb() {
	local branch_name
	local IFS=' '
	branch_name=$(echo "$1" | tr ' ' '_')
	git checkout -b "adlp/$branch_name-$(date +%s)"

	if [ "$#" -gt 1 ]; then
		gca ${*:2}
	else
		gca "$1"
	fi
}
vgc() {
	local prevdir
	prevdir="$(pwd)"
	cdr
	vi $(git status --porcelain=1 | grep -E '^(\s+[AM]|\?)' | awk '{print $2}')
	cd "${prevdir}" || return
}
s() {
	server="$1"
	if [ "$#" -gt 1 ]; then
		run_this="${*:2};"
	else
		run_this=""
	fi
	ssh -t -oStrictHostKeyChecking=no -q -A -K -l adelapole "$server" "$run_this bash -i -o vi"
}
sr() {
	server="$1"
	if [ "$#" -gt 1 ]; then
		run_this="${*:2};"
	else
		run_this="bash -l -i -o vi"
	fi
	ssh -t -oStrictHostKeyChecking=no -q -A -K -l root "$server" "$run_this"
}

rfv() {
	RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
	INITIAL_QUERY="${*:-}"
	: | fzf --ansi --disabled --query "$INITIAL_QUERY" \
		--bind "start:reload:$RG_PREFIX {q}" \
		--bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
		--delimiter : \
		--preview 'bat --color=always --highlight-line {2} {1}' \
		--preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
		--bind 'enter:become(vim {1} +{2})'
}

fe() {
	IFS=$'\n' files=($(fzf --query="$1" --exit-0))
	[[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}
fif() {
	if [ ! "$#" -gt 0 ]; then
		echo "Need a string to search for!"
		return 1
	fi
	rg --ignore-case --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}
fife() {
	if [ ! "$#" -gt 0 ]; then
		echo "Need a string to search for!"
		return 1
	fi
	IFS=$'\n' files=($(rg --multiline --ignore-case --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"))
	# open the files in vim
	[[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

fh() {
	# search history in ~/.bash_eternal_history and ~/.history/* files
	# and set as command line
	if [ ! "$#" -gt 0 ]; then
		echo "Need a string to search for!"
		return 1
	fi
	rg -uuu --ignore-case "$1" ~/.history/* | fzf
}

eval "$(starship init bash)"
function save_all_history() {
	history -a
}
starship_precmd_user_func="save_all_history"
start_ssh_agent

ke() {
	# Get current context and namespace as defaults
	local namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}')
	local context=$(kubectl config current-context)
	local pod_search=""

	# Set default namespace to 'default' if not set
	if [ -z "$namespace" ]; then
		namespace="default"
	fi

	# Check if fzf is installed
	if ! command -v fzf >/dev/null 2>&1; then
		echo "Error: fzf is not installed. Please install it first."
		return 1
	fi

	# Parse flags
	while getopts "n:c:" opt; do
		case $opt in
		n) namespace="$OPTARG" ;;
		c) context="$OPTARG" ;;
		\?)
			echo "Invalid option: -$OPTARG" >&2
			return 1
			;;
		esac
	done

	# Shift to remaining arguments after flags
	shift $((OPTIND - 1))

	# Get pod search term from remaining argument
	pod_search=$1

	if [ -z "$pod_search" ]; then
		echo "Error: Pod search term is required"
		echo "Usage: k-exec [-n namespace] [-c context] pod-search-term"
		return 1
	fi

	# Get matching pods
	echo "Searching for pods matching: $pod_search in context: $context, namespace: $namespace"
	matching_pods=$(kubectl --context "$context" -n "$namespace" get pods | grep "$pod_search" || true)

	if [ -z "$matching_pods" ]; then
		echo "No pods found matching: $pod_search"
		return 1
	fi

	# Display all matching pods
	echo "Found matching pods:"
	echo "$matching_pods"

	# Count number of matching pods
	pod_count=$(echo "$matching_pods" | wc -l)

	# If only one pod, use it directly
	if [ "$pod_count" -eq 1 ]; then
		selected_pod=$(echo "$matching_pods" | awk '{print $1}')
	else
		# Use fzf to select from multiple pods
		echo -e "\nMultiple pods found. Please select one:"
		selected_pod=$(echo "$matching_pods" | fzf --height 40% | awk '{print $1}')
	fi

	# Check if a pod was selected
	if [ -z "$selected_pod" ]; then
		echo "No pod selected"
		return 1
	fi

	# Get container names for the selected pod
	containers=$(kubectl --context "$context" -n "$namespace" get pod "$selected_pod" -o jsonpath='{.spec.containers[*].name}')
	container_count=$(echo "$containers" | wc -w)

	# If only one container, use it directly
	if [ "$container_count" -eq 1 ]; then
		selected_container="$containers"
	else
		# Use fzf to select from multiple containers
		echo -e "\nMultiple containers found. Please select one:"
		selected_container=$(echo "$containers" | tr ' ' '\n' | fzf --height 40%)
	fi

	# Check if a container was selected
	if [ -z "$selected_container" ]; then
		echo "No container selected"
		return 1
	fi

	echo -e "\nConnecting to pod: $selected_pod, container: $selected_container"
	kubectl --context "$context" exec -it -n "$namespace" "$selected_pod" -c "$selected_container" -- /bin/sh
}

# List tmux sessions if we are in an interactive shell
if [[ $- == *i* ]]; then
	if command -v tmux >/dev/null 2>&1; then
		if [[ -z "$TMUX" ]]; then
			tmux list-sessions
		fi
	fi
fi
