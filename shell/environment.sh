# Prints one KEY=VALUE per line for all isolated tool-storage env vars.
# Args: <cache> <config> <data>
function tool_storage_env_pairs () {
	local cache="$1"
	local config="$2"
	local data="$3"
	cat <<-EOF
		CONDA_ENVS_DIRS=${data}/conda/envs
		CONDA_PKGS_DIRS=${cache}/conda/pkgs
		CONDA_BLD_PATH=${cache}/conda/build
		PIXI_HOME=${data}/pixi
		PIXI_CACHE_DIR=${cache}/pixi
		RATTLER_CACHE_DIR=${cache}/rattler
		MAMBA_ROOT_PREFIX=${data}/mamba
		PYTHONPYCACHEPREFIX=${cache}/cpython
		WORKON_HOME=${data}/pipenv/venvs
		PIP_CACHE_DIR=${cache}/pip
		IPYTHONDIR=${config}/ipython
		JUPYTERLAB_SETTINGS_DIR=${data}/jupyter
		JUPYTERLAB_WORKSPACES_DIR=${data}/jupyter/lab/workspaces
		CCACHE_DIR=${cache}/ccache
		SCCACHE_DIR=${cache}/sccache
		MYPY_CACHE_DIR=${cache}/mypy
		RUFF_CACHE_DIR=${cache}/ruff
		CONAN_USER_HOME=${cache}/conan
		GNUPGHOME=${data}/gnupg
		TASK_TEMP_DIR=${cache}/taskfile
		RUSTUP_HOME=${data}/rustup
		CARGO_HOME=${data}/cargo
		NPM_CONFIG_CACHE=${cache}/npm
		PLAYWRIGHT_BROWSERS_PATH=${data}/playwright
	EOF
}

function export_tool_storage_env () {
	local pair
	while IFS= read -r pair; do
		[ -n "$pair" ] && export "$pair"
	done < <(tool_storage_env_pairs "$1" "$2" "$3")
}

function adjust_path () {
	# Add path for executable if not aleard there
	for x in "/usr/local/bin" "/usr/local/sbin" "${HOME}/.local/bin"; do
		case ":$PATH:" in
			*":$x:"*) : ;; # already there
			*) export PATH="$x:$PATH";;
		esac
	done
	# Homebrew
	if [ -d "/opt/homebrew/bin" ]; then
		export PATH="/opt/homebrew/bin:${PATH}"
	fi
	# Other tools
	export PATH="${CARGO_HOME}/bin:${PATH}"
	export PATH="${PIXI_HOME}/bin:${PATH}"
}

# Add zsh functions (used im completion)
function adjust_fpath () {
	if type -P brew &> /dev/null; then
		FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
	fi
	FPATH="${USER_ZSH_COMPLETION_DIR}:${FPATH}"
}
