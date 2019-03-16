# General
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'

# Vim tmux pane navigation
set -g @plugin 'christoomey/vim-tmux-navigator'


# Auto install tmux plugin manager
if "test ! -d ~/.tmux/plugins/tpm" \
   "run 'git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins'"

# Initialize tmux plugin manager
# Press prefix + I to fetch the plugin.
# Press prefix + alt + u to remove the plugin.
# Press prefix + U to updates plugin.
run -b '~/.tmux/plugins/tpm/tpm'
