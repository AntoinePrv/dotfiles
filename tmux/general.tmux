# Set default shell
set -g default-shell "${SHELL}"

# Mouse control
set -g mouse on

# Change prefix
set -g prefix C-a

# Start numbering at 1
set -g base-index 1

# Redefine bindings for window splitting and define splits to start in current directory
unbind '"'
unbind %
bind - split-window -c "#{pane_current_path}"      # Key for -
bind \\ split-window -h -c "#{pane_current_path}"  # Key for | (escaped)

# Create new window in current directory
unbind c
bind t new-window -c "#{pane_current_path}"

# Navigates windows
unbind n
unbind p
bind l      select-window -t '{next}'
bind L      select-window -t '{end}'
bind h      select-window -t '{previous}'
bind H      select-window -t '{start}'
bind BSpace select-window -t '{last}'

# Navigates sessions
unbind (
unbind )
# Need to compute index of previous/last session otherwise the order is by last accessed
# Using ``|| true`` to do nothing on edge cases.
bind j run-shell "tmux switch-client -t '$'$(($(tmux display-message -p '#{session_id}' | tr -d '$') + 1)) || true"
bind J run-shell "tmux switch-client -t '$'$(($(tmux list-sessions | wc -l) - 1))"
bind k run-shell "tmux switch-client -t '$'$(($(tmux display-message -p '#{session_id}' | tr -d '$') - 1)) || true"
bind K switch-client -t $0
# Maximize
unbind z
bind m resize-pane -Z
# Rename
# Already redefined: unbind ,
bind r command-prompt -I "#W" "rename-window -- '%%'"
# Kill the current window
unbind &
bind q kill-window

# Vim mode
setw -g mode-keys vi

# Use the forward script to select the appropriate clipboard
set -s copy-command 'clipboard copy'

# Set the mouse in Tmux selection to only select but not copy
bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X end-selection

# Setup 'v' to begin selection as in Vim
bind -T copy-mode-vi v send-keys -X begin-selection
# Setup 'y' to yank (copy) selection
bind -T copy-mode-vi y send-keys -X copy-selection

# Remove default bindings, leaving only one way to do things
unbind -T copy-mode-vi Enter
unbind -T copy-mode-vi Space
