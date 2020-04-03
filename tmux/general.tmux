# Mouse control
set -g mouse on

# Change prefix
set -g prefix C-a

# Split screen
bind _ split-window
bind | split-window -h

# Vim mode
setw -g mode-keys vi

# Fix and customize Tmux copy operations
# Explaination in the following post
# https://www.freecodecamp.org/news/tmux-in-practice-integration-with-system-clipboard-bcd72c62ff7b/

# Set the mouse in Tmux selection to only select but not copy
bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X end-selection

# Setup 'v' to begin selection as in Vim
bind-key -T copy-mode-vi v send-keys -X begin-selection
# Setup 'y' to yank (copy) selection and fix MacOs namespace
bind-key -T copy-mode-vi y send-keys -X copy-pipe "reattach-to-user-namespace pbcopy"

# Remove default bindings, leaving only one way to do things
unbind -T copy-mode-vi Enter
unbind -T copy-mode-vi Space
