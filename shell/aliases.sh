if [[ "$OSTYPE" == "darwin"* ]]; then
    alias ls='ls -hG'
    alias ll='ls -lhG'
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    alias ls='ls -h --color=auto'
    alias ll='ls -lh --color=auto'
fi
alias cpy="clipboard copy"
alias pst="clipboard paste"
alias grep='grep --color=auto'
type bat &> /dev/null && alias cat='bat'
type nvim &> /dev/null && alias vim='nvim'
function git-tree() {
    local dir="."
    if [[ -d "$1" ]]; then
        dir="$1"
        shift
    fi
    (
        cd "${dir}" || return
        if type git &> /dev/null && git rev-parse --is-inside-work-tree &> /dev/null; then
            git ls-files --cached --others --exclude-standard | tree --fromfile "$@"
        else
            tree "$@"
        fi
    )
}
alias gtree='git-tree'

alias tinty='tinty -d "${USER_TINTED_THEMING_DIR}" -c "${XDG_CONFIG_HOME}/misc/tinty.toml"'

function docker-shell() {
    docker run \
        --interactive --tty --rm \
        --workdir "/workspace/$(basename ${PWD})" \
        --mount "type=bind,source=${PWD},target=/workspace/$(basename ${PWD})" \
        --volume /var/run/docker.sock:/var/run/docker.sock \
        "$@"
}

safe() {
    # TODO how to set elsewhere for vim
    # TODO nvimd wants XDG_DATA_HOME/nvim mutable
    export XDG_STATE_HOME="${HOME}/.local/state"

    safehouse \
        --add-dirs-ro="${XDG_CONFIG_HOME}" \
        --env-pass "XDG_CONFIG_HOME" \
        --add-dirs-ro="${XDG_DATA_HOME}" \
        --env-pass "XDG_DATA_HOME" \
        --add-dirs-ro="${XDG_CACHE_HOME}" \
        --env-pass "XDG_CACHE_HOME" \
        --add-dirs-ro="${WORKSPACE_DIR}" \
        --add-dirs="${XDG_STATE_HOME}" \
        --env-pass "XDG_STATE_HOME" \
        --env-pass "SCCACHE_DIR" \
        --env-pass "EDITOR" \
        "$@"
}

claude() {
    brew upgrade claude-code@latest

    CLAUDE_CODE_TMPDIR="$(mktemp -d)"
    (
        export CLAUDE_CODE_TMPDIR
        call_safe "${XDG_CACHE_HOME}/claude" \
            --add-dirs "${CLAUDE_CODE_TMPDIR}" \
            --env-pass "CLAUDE_CODE_TMPDIR" \
            claude --dangerously-skip-permissions "$@"
    )

    rm -rf "${CLAUDE_CODE_TMPDIR}"
}
