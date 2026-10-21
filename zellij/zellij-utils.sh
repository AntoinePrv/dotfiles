#!/usr/bin/env bash

# Utilities to change zellij session according to the (fixed) order in
# which they were opened, and not by last used.

function list-session-names () {
	zellij list-sessions --short --no-formatting
}

function current-session-name () {
	echo "${ZELLIJ_SESSION_NAME}"
}

function previous-session-name () {
	list-session-names | grep -F -x -B1 "$(current-session-name)" | head -1
}

function previous-session () {
	zellij action switch-session "$(previous-session-name)"
}

function next-session-name () {
	list-session-names | grep -F -x -A1 "$(current-session-name)" | tail -1
}

function next-session () {
	zellij action switch-session "$(next-session-name)"
}

function start-session-name () {
	list-session-names | head -1
}

function start-session () {
	zellij action switch-session "$(start-session-name)"
}

function end-session-name () {
	list-session-names | tail -1
}

function end-session () {
	zellij action switch-session "$(end-session-name)"
}


"${1}" "${@:1}"
