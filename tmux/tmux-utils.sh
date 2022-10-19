#!/usr/bin/env bash

# Utilities to change tmux session according to the (fixed) order in
# which they were opened, and not by last used.

function list-session-ids () {
	tmux list-sessions -F '#{session_id}' | tr -d '$' | sort -t ' ' -k 1 -g
}

function current-session-id () {
	tmux display-message -p '#{session_id}' | tr -d '$'
}

function previous-session-id () {
	list-session-ids | grep -B1 '^'"$(current-session-id)"'$' | head -1
}

function previous-session () {
	tmux switch-client -t '$'"$(previous-session-id)"
}

function next-session-id () {
	list-session-ids | grep -A1 '^'"$(current-session-id)"'$' | tail -1
}

function next-session () {
	tmux switch-client -t '$'"$(next-session-id)"
}

function start-session-id () {
	list-session-ids | head -1
}

function start-session () {
	tmux switch-client -t '$'"$(start-session-id)"
}

function end-session-id () {
	list-session-ids | tail -1
}

function end-session () {
	tmux switch-client -t '$'"$(end-session-id)"
}


"${1}" "${@:1}"
