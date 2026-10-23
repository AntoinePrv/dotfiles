# OSC 133 semantic prompt marks, used by terminals and multiplexers (Zellij, Ghostty...)
# to navigate prompts and select command outputs.
# Must be sourced after the prompt is defined (e.g. starship init).

function __semantic_prompt_precmd() {
    local -r exit_status="$?"
    # No command ran before the first prompt.
    if [ -n "${__semantic_prompt_ran}" ]; then
        printf '\e]133;D;%s\a' "${exit_status}"
    fi
    __semantic_prompt_ran=1
    printf '\e]133;A\a'
}

if [ -n "${BASH_VERSION}" ]; then
    if [[ ! "${PROMPT_COMMAND}" == *__semantic_prompt_precmd* ]]; then
        # First so that it reads the command exit status.
        PROMPT_COMMAND="__semantic_prompt_precmd;${PROMPT_COMMAND}"
        PS1="${PS1}\[\e]133;B\a\]"
        PS0="${PS0}\e]133;C\a"
    fi
elif [ -n "${ZSH_VERSION}" ]; then
    function __semantic_prompt_preexec() {
        printf '\e]133;C\a'
    }
    precmd_functions=(__semantic_prompt_precmd "${precmd_functions[@]}")
    preexec_functions+=(__semantic_prompt_preexec)
    typeset -U precmd_functions preexec_functions
    if [[ "${PROMPT}" != *133\;B* ]]; then
        PROMPT="${PROMPT}%{"$'\e]133;B\a'"%}"
    fi
fi
