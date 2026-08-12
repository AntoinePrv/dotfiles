# call_safe <isolation_dir> <cmd...>
# Runs <cmd...> under safehouse with XDG and developer-tool env vars
# redirected into <isolation_dir>. Env overrides live only inside the
# subshell, so the parent shell is untouched.
function call_safe() {
    local dir="$1"
    shift

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
            tool_env_pass+=(--env-pass "${key}")
        done < <(tool_storage_env_pairs \
            "${XDG_CACHE_HOME}" "${XDG_CONFIG_HOME}" "${XDG_DATA_HOME}")

        safehouse \
            --add-dirs="${XDG_CONFIG_HOME}" --env-pass XDG_CONFIG_HOME \
            --add-dirs="${XDG_DATA_HOME}" --env-pass XDG_DATA_HOME \
            --add-dirs="${XDG_CACHE_HOME}" --env-pass XDG_CACHE_HOME \
            --add-dirs="${XDG_STATE_HOME}" --env-pass XDG_STATE_HOME \
            --add-dirs-ro="${WORKSPACE_DIR}" \
            --env-pass EDITOR \
            "${tool_env_pass[@]}" \
            "$@"
    )
}
