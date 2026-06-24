-- Set options
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.scrolloff = 10
vim.opt.autoindent = true
vim.opt.smartcase = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showcmd = true
vim.opt.cursorline = true
vim.opt.wildmenu = true
vim.opt.showmatch = true
vim.opt.hlsearch = true
vim.opt.encoding = "utf-8"
vim.g.mapleader = " "
vim.opt.mouse = "a"
vim.opt.background = "dark"

-- Plugin manager setup using Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	"arcticicestudio/nord-vim",
	"nvim-lua/plenary.nvim",
	{ "nvim-telescope/telescope.nvim", branch = "0.1.x" },
	"nvim-tree/nvim-web-devicons",
	"folke/flash.nvim",
	"lukas-reineke/indent-blankline.nvim",
	"preservim/nerdtree",
	"ThePrimeagen/vim-be-good",
	"vim-airline/vim-airline",
	"Konstruktionist/vim-fish",
	"folke/which-key.nvim",
	"rust-lang/rust.vim",
	{ "echasnovski/mini.ai", version = false }, -- extend a/i visual selection (e.g. vai(i( )
	{ "echasnovski/mini.surround", version = false }, -- surround text objects with sa, sd, sh, sr etc.
	{ "echasnovski/mini.move", version = false }, -- move lines with Alt-hjkl
	"JoosepAlviste/nvim-ts-context-commentstring", -- pick the right commentstring for the current context
})

require("mini.ai").setup()
require("mini.surround").setup()
require("mini.move").setup()

-- Enable syntax highlighting and file type plugins
vim.cmd([[syntax enable]])
vim.cmd([[filetype plugin indent on]])

-- Set colorscheme
vim.cmd([[colorscheme nord]])

-- Set compatibility options
vim.opt.compatible = false
if vim.fn.has("termguicolors") == 1 then
	vim.opt.termguicolors = true
end

-- Key mappings
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Unbind space in normal/visual mode to make leader work
map("n", "<Space>", "<Nop>", opts)
map("v", "<Space>", "<Nop>", opts)

-- NERDTree mappings
map("n", "<leader>nF", ":NERDTreeFocus<CR>", opts)
map("n", "<leader>nt", ":NERDTree<CR>", opts)
map("n", "<leader>nn", ":NERDTreeToggle<CR>", opts)
map("n", "<leader>nf", ":NERDTreeFind<CR>", opts)

-- Telescope mappings
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)

-- Persistent Undo settings (portable across macOS / Linux / Windows)
local state = vim.fn.stdpath("state")
for _, sub in ipairs({ "swapfiles", "backupfiles", "undofiles" }) do
	vim.fn.mkdir(state .. "/" .. sub, "p")
end
vim.opt.dir = state .. "/swapfiles"
vim.opt.backup = true
vim.opt.backupdir = state .. "/backupfiles"
vim.opt.undofile = true
vim.opt.undodir = state .. "/undofiles"

-- Better clipboard experience
vim.opt.clipboard = "unnamedplus"

-- Flash.nvim setup
require("plugins.flash")

-- vscode specific settings
if vim.g.vscode then
	-- terminal
	map("n", "<leader>t", '<cmd>lua require("vscode").action("workbench.action.terminal.toggleTerminal")<CR>', opts)

	-- navigation
	map("n", "<leader>/", '<cmd>lua require("vscode").action("workbench.action.findInFiles")<CR>', opts)
	map("n", "<leader>ff", '<cmd>lua require("vscode").action("editor.action.startFindReplaceAction")<CR>', opts)
	map("v", "<leader>ff", '<cmd>lua require("vscode").action("editor.action.startFindReplaceAction")<CR>', opts)
	map("n", "<leader>fa", '<cmd>lua require("vscode").action("workbench.action.findInFiles")<CR>', opts)
	map("v", "<leader>fa", '<cmd>lua require("vscode").action("workbench.action.findInFiles")<CR>', opts)
	map("n", "<leader>fo", '<cmd>lua require("vscode").action("workbench.action.files.openFile")<CR>', opts)
	
	map("n", "<C-o>", '<cmd>lua require("vscode").action("workbench.action.navigateBack")<CR>', opts)
	map("n", "<C-i>", '<cmd>lua require("vscode").action("workbench.action.navigateForward")<CR>', opts)
	map("v", "<C-o>", '<cmd>lua require("vscode").action("workbench.action.navigateBack")<CR>', opts)
	map("v", "<C-i>", '<cmd>lua require("vscode").action("workbench.action.navigateForward")<CR>', opts)

  --undo-redo-fix
  map("n","u","<Cmd>call VSCodeNotify('undo')<CR>", opts)
  map("n","<C-r>","<Cmd>call VSCodeNotify('redo')<CR>", opts) 

	-- code
	map("n", "<leader>aa", '<cmd>lua require("vscode").action("inlineChat.startWithCurrentLine")<CR>', opts)
	map("n", "<leader>qf", '<cmd>lua require("vscode").action("editor.action.quickFix")<CR>', opts)
	map("n", "<leader>cf", '<cmd>lua require("vscode").action("editor.action.formatDocument")<CR>', opts)

	-- smart select - expand / shrink with ctrl+j / ctrl+k
	map("n", "<C-j>", '<cmd>lua require("vscode").action("editor.action.smartSelect.expand")<CR>', opts)
	map("v", "<C-j>", '<cmd>lua require("vscode").action("editor.action.smartSelect.expand")<CR>', opts)
	map("n", "<C-k>", '<cmd>lua require("vscode").action("editor.action.smartSelect.shrink")<CR>', opts)
	map("v", "<C-k>", '<cmd>lua require("vscode").action("editor.action.smartSelect.shrink")<CR>', opts)

	-- close tab with ctrl+w_w
	map("n", "<C-w>w", '<cmd>lua require("vscode").action("workbench.action.closeActiveEditor")<CR>', opts)
end
