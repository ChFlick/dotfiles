" ~/.vimrc — minimal config for plain vim (Neovim uses ~/.config/nvim/init.lua)
" Edited via the `ev` alias.

set nocompatible
set expandtab
set smarttab
set shiftwidth=2
set tabstop=2
set softtabstop=2
set autoindent
set smartcase
set number
set relativenumber
set showcmd
set cursorline
set wildmenu
set showmatch
set hlsearch
set incsearch
set encoding=utf-8
set mouse=a
set background=dark
set clipboard=unnamedplus

let mapleader = " "

syntax enable
filetype plugin indent on

if (has("termguicolors"))
  set termguicolors
endif

" Persistent undo / backups under ~/.vim
set undofile
set undodir=~/.vim/undofiles
set backup
set backupdir=~/.vim/backupfiles
set dir=~/.vim/swapfiles
for s:d in ['undofiles', 'backupfiles', 'swapfiles']
  if !isdirectory(expand('~/.vim/' . s:d))
    call mkdir(expand('~/.vim/' . s:d), 'p')
  endif
endfor
