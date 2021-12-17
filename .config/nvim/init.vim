set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

call plug#begin()

" Nord Theme
Plug 'shaunsingh/nord.nvim'

" Telescope :Telescope picker
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Indent guidelines
Plug 'lukas-reineke/indent-blankline.nvim'

" Nerdtree
Plug 'preservim/nerdtree'

call plug#end()

colorscheme nord
