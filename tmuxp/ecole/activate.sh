# number of core files
ulimit -c 20

# CMake does not regonize CPPFLAGS
export CPPFLAGS="-fcolor-diagnostics ${CPPFLAGS}"
export CFLAGS="${CFLAGS} ${CPPFLAGS}"
export CXXFLAGS="${CXXFLAGS} ${CPPFLAGS}"

alias cconf="cmake -B build/ -D ECOLE_DEVELOPER=ON"

function cbuild () {
	target="$1"
	other_args="${@:2}"
	command="cmake --build build/ ${target:+--target ${target}}"
	command="${command} --parallel ${other_args} -- -s"
	echo "$command"
	eval $command
}

function __configure(){
	conda activate ecole
	export cconf cbuild
}

__configure
