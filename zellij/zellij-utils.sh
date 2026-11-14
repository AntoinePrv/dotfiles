#!/bin/sh

# Utilities to change zellij session according to the (fixed) order in
# which they were opened, and not by last used.

list_session_names () {
	zellij list-sessions --short --no-formatting
}

current_session_name () {
	echo "${ZELLIJ_SESSION_NAME}"
}

previous_session_name () {
	list_session_names | grep -F -x -B1 "$(current_session_name)" | head -1
}

previous_session () {
	zellij action switch-session "$(previous_session_name)"
}

next_session_name () {
	list_session_names | grep -F -x -A1 "$(current_session_name)" | tail -1
}

next_session () {
	zellij action switch-session "$(next_session_name)"
}

start_session_name () {
	list_session_names | head -1
}

start_session () {
	zellij action switch-session "$(start_session_name)"
}

end_session_name () {
	list_session_names | tail -1
}

end_session () {
	zellij action switch-session "$(end_session_name)"
}

# Git segments for zjstatus command widgets, each printing nothing when empty
# so that the widget, symbol and separator included, is hidden.

git_branch () (
	branch="$(git branch --show-current 2> /dev/null)" || return 0
	[ -z "${branch}" ] && branch="$(git rev-parse --short HEAD)"
	echo "${branch}"
)

git_state () (
	git_dir="$(git rev-parse --git-dir 2> /dev/null)" || return 0
	if [ -d "${git_dir}/rebase-merge" ]; then
		echo "REBASING $(cat "${git_dir}/rebase-merge/msgnum")/$(cat "${git_dir}/rebase-merge/end")"
	elif [ -d "${git_dir}/rebase-apply" ]; then
		echo "REBASING $(cat "${git_dir}/rebase-apply/next")/$(cat "${git_dir}/rebase-apply/last")"
	elif [ -f "${git_dir}/MERGE_HEAD" ]; then
		echo "MERGING"
	elif [ -f "${git_dir}/CHERRY_PICK_HEAD" ]; then
		echo "CHERRY-PICKING"
	elif [ -f "${git_dir}/REVERT_HEAD" ]; then
		echo "REVERTING"
	elif [ -f "${git_dir}/BISECT_LOG" ]; then
		echo "BISECTING"
	fi
)

git_status () {
	git status --porcelain=v2 2> /dev/null | awk '
		/^u / { conflicted++ }
		/^\? / { untracked++ }
		/^[12] / {
			x = substr($2, 1, 1)
			y = substr($2, 2, 1)
			if (x != ".") staged++
			if (x == "R") renamed++
			if (x == "D" || y == "D") deleted++
			if (y == "M") modified++
			if (x == "T" || y == "T") typechanged++
		}
		END {
			if (conflicted) out = out " ✘" conflicted
			if (deleted) out = out " -" deleted
			if (renamed) out = out " »" renamed
			if (modified) out = out " ~" modified
			if (typechanged) out = out " T" typechanged
			if (staged) out = out " ●" staged
			if (untracked) out = out " …"
			if (out != "") print substr(out, 2)
		}
	'
}

git_stashes () (
	stashes="$(git rev-list --walk-reflogs --count refs/stash 2> /dev/null)" || return 0
	echo "${stashes}"
)

git_ahead_behind () (
	counts="$(git rev-list --left-right --count '@{upstream}...HEAD' 2> /dev/null)" || return 0
	behind="${counts%%[[:space:]]*}"
	ahead="${counts##*[[:space:]]}"
	if [ "${ahead}" -gt 0 ] && [ "${behind}" -gt 0 ]; then
		echo "${ahead} ${behind}"
	elif [ "${ahead}" -gt 0 ]; then
		echo "${ahead}"
	elif [ "${behind}" -gt 0 ]; then
		echo "${behind}"
	else
		echo "󰄭"
	fi
)

git_all () (
	sep=" "
	for arg in "${@}"; do
		case "${arg}" in
			--sep=*) sep="${arg#--sep=}" ;;
		esac
	done
	git rev-parse --git-dir > /dev/null 2>&1 || return 0
	stashes="$(git_stashes)"
	branch="$(git_branch)"
	out=""
	for segment in \
		"$(git_status)" \
		"${stashes:+ ${stashes}}" \
		"$(git_ahead_behind)" \
		"$(git_state)" \
		"${branch:+ ${branch}}"
	do
		[ -z "${segment}" ] && continue
		out="${out:+${out} ${sep} }${segment}"
	done
	echo "${out}"
)

gh_pr () {
	gh pr view --json number,state,statusCheckRollup --jq '
		select(.state == "OPEN")
		| .number as $number
		| [.statusCheckRollup[]
			| (if .__typename == "StatusContext" then .state
				elif .status != "COMPLETED" then "PENDING"
				else .conclusion end) as $s
			| if ($s == "SUCCESS" or $s == "NEUTRAL" or $s == "SKIPPED") then "pass"
				elif ($s == "PENDING" or $s == "EXPECTED") then "pending"
				else "fail" end]
		| (map(select(. == "pass")) | length) as $pass
		| (map(select(. == "fail")) | length) as $fail
		| (map(select(. == "pending")) | length) as $pending
		| [if $pass > 0 then "✔\($pass)" else empty end,
		   if $fail > 0 then "✘\($fail)" else empty end,
		   if $pending > 0 then "●\($pending)" else empty end]
		| ["#\($number)"] + .
		| [""] + . | join(" ")
	' 2> /dev/null
}

pixi_envs () {
	pixi info --json 2> /dev/null | jq --raw-output '.environments_info | map(.name) | if length > 5 then .[:4] + ["…"] + .[-1:] else . end | join("|")'
}


# Hyphenated names are kept as the CLI because function names must be valid
# identifiers in POSIX sh.
command="$(echo "${1}" | tr '-' '_')"
shift
"${command}" "${@}"
