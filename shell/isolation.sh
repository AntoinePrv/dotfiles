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

# call_safe <isolation_dir> <cmd...>
# Runs <cmd...> under safehouse with XDG and developer-tool env vars
# redirected into <isolation_dir>. Env overrides live only inside the
# subshell, so the parent shell is untouched.
function call_safe () {
	local dir="$1"; shift

	# Changing env vars in a subshell
	(
		export XDG_CONFIG_HOME="${dir}/config"
		export XDG_CACHE_HOME="${dir}/cache"
		export XDG_DATA_HOME="${dir}/data"
		export XDG_STATE_HOME="${dir}/state"
		mkdir -p "${XDG_CONFIG_HOME}"
		mkdir -p "${XDG_CACHE_HOME}"
		mkdir -p "${XDG_DATA_HOME}"
		mkdir -p "${XDG_STATE_HOME}"

		local tool_env_pass=()
		local pair key
		while IFS= read -r pair; do
			[ -z "$pair" ] && continue
			export "$pair"
			key="${pair%%=*}"
			tool_env_pass+=( --env-pass "${key}" )
		done < <(tool_storage_env_pairs \
			"${XDG_CACHE_HOME}" "${XDG_CONFIG_HOME}" "${XDG_DATA_HOME}")

		safehouse \
			--add-dirs="${XDG_CONFIG_HOME}" --env-pass XDG_CONFIG_HOME \
			--add-dirs="${XDG_DATA_HOME}"   --env-pass XDG_DATA_HOME \
			--add-dirs="${XDG_CACHE_HOME}"  --env-pass XDG_CACHE_HOME \
			--add-dirs="${XDG_STATE_HOME}"  --env-pass XDG_STATE_HOME \
			--add-dirs-ro="${WORKSPACE_DIR}" \
			--env-pass EDITOR \
			"${tool_env_pass[@]}" \
			"$@"
	)
}
