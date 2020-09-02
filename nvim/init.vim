" Automatic install
let s:vim_plug_url = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
let s:vim_plug_file = stdpath("data") . "/site/autoload/plug.vim"

if empty(glob(s:vim_plug_file))
	silent execute "!curl -fLo " . s:vim_plug_load_file " --create-dirs " . s:vim_plug_url
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


" Plugins will be downloaded under the specified directory.
call plug#begin(stdpath("data") . "/plugged")
	" General
	Plug 'tpope/vim-sensible'
	Plug 'scrooloose/nerdcommenter'
	Plug 'tpope/vim-fugitive'
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
	Plug 'dense-analysis/ale', { 'tag': 'v2.7.0' }
	Plug 'ncm2/float-preview.nvim'

	" Tmux panes navigation
	Plug 'christoomey/vim-tmux-navigator'

	" Plugins for outside of vim
	Plug 'edkolev/tmuxline.vim'
	Plug 'edkolev/promptline.vim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()
