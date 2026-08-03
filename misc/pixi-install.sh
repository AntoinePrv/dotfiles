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
  jujutsu \
  mosh \
  nvim'>=0.12' \
  ripgrep \
  starship \
  tmux!=3.6 \
  tmuxp \
  tree \
  tree-sitter-cli \
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
  micromamba=2.4 \
