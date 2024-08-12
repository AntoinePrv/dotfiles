set -g message-command-style "fg=colour21,bg=colour19"
set -g pane-active-border-style "fg=colour2"
set -g message-style "fg=colour21,bg=colour19"
set -g pane-border-style "fg=colour19"

set -g status "on"
set -g status-justify "centre"
set -g status-style "none,bg=colour0"

setw -g window-status-activity-style "none,fg=colour2,bg=colour18"
setw -g window-status-separator ""
setw -g window-status-style "none,fg=colour7,bg=colour0"
setw -g window-status-format "#[default,fg=color18]#[fg=colour7,bg=colour18] #I #W #[default,fg=color18]"
setw -g window-status-current-format "#[default,fg=color19]#[fg=colour16,bg=colour19]  #I #W #(printf \"#F\" | tr -d \"*\" | tr \"Z\" \"󰘖\") #[default,fg=color19]"

set -g status-left-style "none"
set -g status-left "#(STARSHIP_CONFIG=$HOME/.config/tmux/starship.toml starship prompt)"

set -g status-right-style "none"
set -g status-right '#(STARSHIP_CONFIG=$HOME/.config/tmux/starship.toml starship prompt --right --path="$(tmux showenv __TMUX#{pane_id}_PWD | cut -d= -f2)")'
