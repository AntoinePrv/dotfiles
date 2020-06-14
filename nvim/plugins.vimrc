" Automatic install
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
	silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')
	" General
	Plug 'tpope/vim-sensible'
	Plug 'scrooloose/nerdcommenter'
	Plug 'tpope/vim-fugitive'
	Plug 'tpope/vim-obsession'
	Plug 'dhruvasagar/vim-prosession'
	Plug 'tmux-plugins/vim-tmux-focus-events'
	Plug 'junegunn/fzf', { 'do': './install --bin' }

	" Colors themes
	Plug 'sickill/vim-monokai'
	Plug 'junegunn/seoul256.vim'
	Plug 'morhetz/gruvbox'
	Plug 'chriskempson/base16-vim'

	" Visual
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'airblade/vim-gitgutter'
	Plug 'ryanoasis/vim-devicons'
	Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
	Plug 'ap/vim-css-color'

	" Completion and and syntax
	Plug 'sheerun/vim-polyglot'
	Plug 'dense-analysis/ale'
	Plug 'ncm2/float-preview.nvim'

	" Tmux panes navigation
	Plug 'christoomey/vim-tmux-navigator'

	" Plugins for outside of vim
	Plug 'edkolev/tmuxline.vim'
	Plug 'edkolev/promptline.vim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()
