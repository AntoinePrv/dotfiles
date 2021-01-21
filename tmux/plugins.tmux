#TODO can we use ${...-} syntax for variables?
# https://stackoverflow.com/questions/61138510/get-absolut-path-to-tmux-conf-in-tmux-configuration-file
if-shell 'test -n "${XDG_DATA_HOME+x}"' 'set-environment -g TMUX_PLUGIN_MANAGER_PATH "${XDG_DATA_HOME}/tmux"'
if-shell 'test ! -n "${XDG_DATA_HOME+x}"' 'set-environment -g TMUX_PLUGIN_MANAGER_PATH "${HOME}/.local/share/tmux"'

# General
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'

# Vim tmux pane navigation
set -g @plugin 'christoomey/vim-tmux-navigator'


# Auto install tmux plugin manager
# TODO Adaot path for XDG_DATA_HOME
if "test ! -d ~/.tmux/plugins/tpm" \
   "run 'git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins'"

# Initialize tmux plugin manager
# Press prefix + I to fetch the plugin.
# Press prefix + alt + u to remove the plugin.
# Press prefix + U to updates plugin.
run -b '~/.tmux/plugins/tpm/tpm'
