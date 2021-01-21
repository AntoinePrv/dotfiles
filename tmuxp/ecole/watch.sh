#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace  # Debugging

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"
__root="$(cd "$(dirname "${__dir}")" && pwd)"


function __yellow () {
	local YELLOW="\033[1;33m"
	local NC="\033[0m"
	printf "${YELLOW}$*${NC}"
}


function __center () {
	local TITLE="$*"
	local WIDTH=$(tput cols)
	local OFFSET=$((($WIDTH-${#TITLE})/2))
	printf "%${OFFSET}s"; printf "$TITLE"
}


function __title () {
	local TITLE="$* - $(date +'%a %H:%M:%S')"
	local TITLE_LINE="$(printf %${#TITLE}s | sed 's/ /─/g')"
	__yellow "$(__center '┌──'${TITLE_LINE}'──┐')\n"
	__yellow "$(__center '│  '${TITLE}'  │')\n"
	__yellow "$(__center '└──'${TITLE_LINE}'──┘')\n\n"
}


cancel_and_run() {
	local command_pid=0

	while read; do
		if [ ${command_pid:-0} -gt 0 ]; then
			# Loop until process is effectively killed (synchronous)
			while pkill -P $command_pid 2>/dev/null; do sleep 0.5 ; done
		fi

		( $@ ) &
		local command_pid=$!
	done
}

function __build () {
	clear && __title Build && cmake --build build/ --parallel -- -s
}

function __watch_build () {
	fswatch -o CMakeLists.txt libecole/ python/ | cancel_and_run __build
}

function __doc () {
	clear && __title Generate Doc && cmake --build build/ --target ecole-sphinx -- -s
}

function __watch_doc () {
	fswatch -o CMakeLists.txt docs/ libecole/ python/ | cancel_and_run __doc
}

function __tests () {
	clear && __title Tests && ./build/libecole/tests/test-libecole
}

function __watch_tests () {
	fswatch -o build/libecole/tests/test-libecole | cancel_and_run __tests
}

function __pytest () {
	(
		clear && __title PyTest && \
		./build/venv/bin/python -u -m pytest --no-slow -o cache_dir="${XDG_CACHE_HOME}/pytest/ecole" python/
	)
}

function __watch_pytest () {
	WATCH_PATHS="build/venv python/tests python/**/*.py"
	fswatch --exclude '.*\.pyc' -o -r ${WATCH_PATHS} --latency=1 | cancel_and_run __pytest
}

function __main() {
	"__watch_${1}"
}

__main $@
