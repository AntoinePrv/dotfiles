" Automatic install
let s:vim_plug_url = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
let s:vim_plug_file = stdpath("data") . "/site/autoload/plug.vim"

if empty(glob(s:vim_plug_file))
	silent execute "!curl -fLo " . s:vim_plug_file " --create-dirs " . s:vim_plug_url
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


" Plugins will be downloaded under the specified directory.
call plug#begin(stdpath("data") . "/plugged")
	" General
	Plug 'scrooloose/nerdcommenter'
	Plug 'tpope/vim-sensible'
	Plug 'tpope/vim-fugitive'
	Plug 'tpope/vim-obsession'
	Plug 'stefandtw/quickfix-reflector.vim'
	Plug 'junegunn/fzf', { 'tag': '0.27.0', 'do': { -> fzf#install() } }

	" Colors themes
	Plug 'chriskempson/base16-vim'

	" Visual
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'airblade/vim-gitgutter'
	Plug 'ryanoasis/vim-devicons'
	Plug 'ap/vim-css-color'
	" Move to this one
	" Plug 'norcalli/nvim-colorizer.lua'

	" Completion and and syntax
	Plug 'sheerun/vim-polyglot'
	Plug 'rbberger/vim-singularity-syntax'
	Plug 'octol/vim-cpp-enhanced-highlight'
	Plug 'dense-analysis/ale', { 'tag': 'v3.1.0' }
	Plug 'ncm2/float-preview.nvim'

	" Tmux integration
	Plug 'christoomey/vim-tmux-navigator'
	Plug 'tmux-plugins/vim-tmux-focus-events'

	" Plugins for outside of vim
	Plug 'edkolev/tmuxline.vim'
	Plug 'edkolev/promptline.vim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()
