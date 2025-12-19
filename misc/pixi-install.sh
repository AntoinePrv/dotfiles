pixi global install --environment devutils \
  ast-grep \
  bat \
  curl \
  fd-find \
  fzf \
  gh \
  git \
  git-lfs \
  htop \
  jq \
  mosh \
  nvim'>=0.11' \
  ripgrep \
  starship \
  tmux!=3.6 \
  tmuxp \
  tree \
  watch \
  watchexec \
  wget \

pixi global install --environment datascience \
  jupyter \
  pandas \
  polars \
  pyarrow \
  python \
  seaborn \

pixi global install --environment conda-forge \
  conda-smithy \
  rattler-build \
  conda-recipe-manager \
  rattler-sandbox \
