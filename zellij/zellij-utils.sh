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

# Git segments for zjstatus command widgets, each printing nothing when empty
# so that the widget, symbol and separator included, is hidden.

function git-branch () {
	local branch
	branch="$(git branch --show-current 2> /dev/null)" || return 0
	[[ -z "${branch}" ]] && branch="$(git rev-parse --short HEAD)"
	echo "${branch}"
}

function git-state () {
	local git_dir
	git_dir="$(git rev-parse --git-dir 2> /dev/null)" || return 0
	if [[ -d "${git_dir}/rebase-merge" ]]; then
		echo "REBASING $(< "${git_dir}/rebase-merge/msgnum")/$(< "${git_dir}/rebase-merge/end")"
	elif [[ -d "${git_dir}/rebase-apply" ]]; then
		echo "REBASING $(< "${git_dir}/rebase-apply/next")/$(< "${git_dir}/rebase-apply/last")"
	elif [[ -f "${git_dir}/MERGE_HEAD" ]]; then
		echo "MERGING"
	elif [[ -f "${git_dir}/CHERRY_PICK_HEAD" ]]; then
		echo "CHERRY-PICKING"
	elif [[ -f "${git_dir}/REVERT_HEAD" ]]; then
		echo "REVERTING"
	elif [[ -f "${git_dir}/BISECT_LOG" ]]; then
		echo "BISECTING"
	fi
}

function git-status () {
	local status
	status="$(git status --porcelain=v2 2> /dev/null)" || return 0

	local conflicted=0 deleted=0 renamed=0 modified=0 typechanged=0 staged=0 untracked=0
	local line x y
	while IFS= read -r line; do
		case "${line}" in
			'u '*) conflicted=$((conflicted + 1)) ;;
			'? '*) untracked=$((untracked + 1)) ;;
			[12]' '*)
				x="${line:2:1}"
				y="${line:3:1}"
				[[ "${x}" != '.' ]] && staged=$((staged + 1))
				[[ "${x}" == 'R' ]] && renamed=$((renamed + 1))
				[[ "${x}" == 'D' || "${y}" == 'D' ]] && deleted=$((deleted + 1))
				[[ "${y}" == 'M' ]] && modified=$((modified + 1))
				[[ "${x}" == 'T' || "${y}" == 'T' ]] && typechanged=$((typechanged + 1))
				;;
		esac
	done <<< "${status}"

	local changes=()
	((conflicted)) && changes+=("✘${conflicted}")
	((deleted)) && changes+=("-${deleted}")
	((renamed)) && changes+=("»${renamed}")
	((modified)) && changes+=("~${modified}")
	((typechanged)) && changes+=("T${typechanged}")
	((staged)) && changes+=("●${staged}")
	((untracked)) && changes+=("…")
	((${#changes[@]})) && echo "${changes[*]}"
}

function git-stashes () {
	local stashes
	stashes="$(git rev-list --walk-reflogs --count refs/stash 2> /dev/null)" || return 0
	echo "${stashes}"
}

function git-ahead-behind () {
	local counts behind ahead
	counts="$(git rev-list --left-right --count '@{upstream}...HEAD' 2> /dev/null)" || return 0
	read -r behind ahead <<< "${counts}"
	if ((ahead && behind)); then
		echo "${ahead} ${behind}"
	elif ((ahead)); then
		echo "${ahead}"
	elif ((behind)); then
		echo "${behind}"
	else
		echo "󰄭"
	fi
}

function gh-pr () {
	local counts pass fail pending
	counts="$(gh pr view --json state,statusCheckRollup --jq '
		select(.state == "OPEN")
		| [.statusCheckRollup[]
			| (if .__typename == "StatusContext" then .state
				elif .status != "COMPLETED" then "PENDING"
				else .conclusion end) as $s
			| if ($s == "SUCCESS" or $s == "NEUTRAL" or $s == "SKIPPED") then "pass"
				elif ($s == "PENDING" or $s == "EXPECTED") then "pending"
				else "fail" end]
		| "\(map(select(. == "pass")) | length) \(map(select(. == "fail")) | length) \(map(select(. == "pending")) | length)"
	' 2> /dev/null)" || return 0
	[[ -z "${counts}" ]] && return 0
	read -r pass fail pending <<< "${counts}"

	local checks=("")
	if ((fail || pending)); then
		((pass)) && checks+=("✔${pass}")
		((fail)) && checks+=("✘${fail}")
		((pending)) && checks+=("●${pending}")
	elif ((pass)); then
		checks+=("󰄭")
	fi
	echo "${checks[*]}"
}

function pixi-envs () {
	pixi info --json 2> /dev/null | jq --raw-output '.environments_info | map(.name) | join("|")'
}


"${1}" "${@:2}"
