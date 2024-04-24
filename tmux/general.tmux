# Set default terminal
set -g default-terminal "${TERM}"

# Fallback to another session when killing a session
set-option -g detach-on-destroy off

# Activate underline colors
set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'

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

# Navigates windows
unbind n
unbind p
bind l      select-window -t '{next}'
bind L      select-window -t '{end}'
bind h      select-window -t '{previous}'
bind H      select-window -t '{start}'
bind BSpace select-window -t '{last}'

# Create new window in current directory
unbind c
bind t new-window -c "#{pane_current_path}"
bind n new-session -c "#{pane_current_path}"

# Navigates sessions
unbind (
unbind )
bind k run-shell "${HOME}/.config/tmux/tmux-utils.sh previous-session"
bind K run-shell "${HOME}/.config/tmux/tmux-utils.sh start-session"
bind j run-shell "${HOME}/.config/tmux/tmux-utils.sh next-session"
bind J run-shell "${HOME}/.config/tmux/tmux-utils.sh end-session"

# Maximize
unbind z
bind m resize-pane -Z
# Rename
# Already redefined: unbind ,
bind r command-prompt -I "#W" "rename-window -- '%%'"
bind R command-prompt -I "#S" "rename-session -- '%%'"
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
