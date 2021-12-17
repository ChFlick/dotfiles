syntax enable		" enable syntax processing
set tabstop=2		" number of visual spaces per tab
set softtabstop=2   " number of spaces in tab when editing
set expandtab		" tabs are space
set number			" show linenumbers
set showcmd			" show last command in bottom bar
set cursorline		" show current line highlighted
set wildmenu		" visual autocomplete for command menu
set showmatch		" highlight matching braces
set hlsearch		" highlight search results
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

call plug#end()

colorscheme nord

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
