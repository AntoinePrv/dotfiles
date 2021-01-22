# Set the plugin manager path to ${XDG_DATA_HOME}/tmux/plugins"
run 'tmux set-environment -g TMUX_PLUGIN_MANAGER_PATH "${XDG_DATA_HOME-${HOME}/.local/share}/tmux/plugins"'


# General plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'

# Vim tmux pane navigation
set -g @plugin 'christoomey/vim-tmux-navigator'


# Auto install tmux plugin manager in "${XDG_DATA_HOME}/tmux/tpm" and install plugins.
# TODO install using zsh plugin manager
run '\
TPM_PATH="${XDG_DATA_HOME-${HOME}/.local/share}/tmux/" && \
TPM_VERSION=3.0.0 && \
[ ! -d  "${TPM_PATH}/tpm" ] && \
mkdir -p "${TPM_PATH}" && \
cd "${TPM_PATH}" && \
wget --output-document tpm.tar.gz "https://github.com/tmux-plugins/tpm/archive/v${TPM_VERSION}.tar.gz" && \
tar -xzf tpm.tar.gz && \
mv "tpm-${TPM_VERSION}" tpm && \
rm tpm.tar.gz && \
./tpm/bin/install_plugins'

# Initialize tmux plugin manager
# Press prefix + I to fetch the plugin.
# Press prefix + alt + u to remove the plugin.
# Press prefix + U to updates plugin.
run -b '${XDG_DATA_HOME-${HOME}/.local/share}/tmux/plugins/tmp/tmp'
