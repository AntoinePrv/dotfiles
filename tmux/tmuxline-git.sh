# Modified from promptline.vim
# https://github.com/edkolev/promptline.vim/blob/master/autoload/promptline/slices/git_status.sh

function __tmuxline_git_status {
	[[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == true ]] || return 1

	local added_symbol="●"
	local unmerged_symbol="✗"
	local modified_symbol="+"
	local clean_symbol="✔"
	local has_untracked_files_symbol="…"
	local branch_symbol=""
	local ahead_symbol="↑"
	local behind_symbol="↓"

	local branch=$(git rev-parse --abbrev-ref HEAD)
	local unmerged_count=0 modified_count=0 has_untracked_files=0 added_count=0 is_clean=""

	set -- $(git rev-list --left-right --count @{upstream}...HEAD 2>/dev/null)
	local behind_count=$1
	local ahead_count=$2

	# Added (A), Copied (C), Deleted (D), Modified (M), Renamed (R), changed (T),
	# Unmerged (U), Unknown (X), Broken (B)
	while read line; do
		case "$line" in
			M*) modified_count=$(( $modified_count + 1 )) ;;
			U*) unmerged_count=$(( $unmerged_count + 1 )) ;;
		esac
	done < <(git diff --name-status)

	while read line; do
		case "$line" in
			*) added_count=$(( $added_count + 1 )) ;;
		esac
	done < <(git diff --name-status --cached)

	if [ -n "$(git ls-files --others --exclude-standard)" ]; then
		has_untracked_files=1
	fi

	if [ $(( unmerged_count + modified_count + has_untracked_files + added_count )) -eq 0 ]; then
		is_clean=1
	fi

	printf "${branch_symbol} ${branch}"
	[[ $ahead_count -gt 0 ]] && printf " ${ahead_symbol}${ahead_count}"
	[[ $behind_count -gt 0 ]] && printf " ${behind_symbol}${behind_count}"
	[[ $modified_count -gt 0 ]] && printf " ${modified_symbol}${modified_count}"
	[[ $unmerged_count -gt 0 ]] && printf " ${unmerged_symbol}${unmerged_count}"
	[[ $added_count -gt 0 ]] && printf " ${added_symbol}${added_count}"
	[[ $has_untracked_files -gt 0 ]] && printf " ${has_untracked_files_symbol}"
	[[ $is_clean -gt 0 ]] && printf " ${clean_symbol}"
	return 0
}

__tmuxline_git_status
