syntax enable " Enable syntax processing
filetype plugin indent on
set expandtab		" tabs are spaces
set smarttab
set shiftwidth=2
set tabstop=2		" number of visual spaces per tab
set softtabstop=2   " number of spaces in tab when editing
set autoindent
set smartcase
set number			" show linenumbers
set showcmd			" show last command in bottom bar
set cursorline		" show current line highlighted
set wildmenu		" visual autocomplete for command menu
set showmatch		" highlight matching braces
set hlsearch		" highlight search results
set encoding=utf-8

set mouse=a " enable mouse

set background=dark 

call plug#begin()

" Nord Theme
Plug 'arcticicestudio/nord-vim'

" Telescope :Telescope picker
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Indent guidelines
Plug 'lukas-reineke/indent-blankline.nvim'

" Nerdtree
Plug 'preservim/nerdtree'

" Status line
Plug 'vim-airline/vim-airline'

" Fish support
Plug 'Konstruktionist/vim-fish'

call plug#end()

" Color theme
colorscheme nord

set nocompatible
if (has("termguicolors"))
  set termguicolors
endif

" Keymappings
"
" NERDTree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" Persistent Undo
set dir=~/.vim/swapfiles
set backup
set backupdir=~/.vim/backupfiles
set undofile
set undodir=~/.vim/undofiles

" Better clipboard experience
set clipboard=unnamedplus
