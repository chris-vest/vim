-- Plugins
local Plug = vim.fn['plug#']

vim.call('plug#begin')

-- theme
Plug 'chris-vest/dracula'

-- utility
Plug 'nvim-lua/plenary.nvim'
Plug 'tpope/vim-sensible'
Plug 'moll/vim-bbye'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'tyru/open-browser-github.vim'
Plug 'tyru/open-browser.vim'

-- formatting
Plug 'godlygeek/tabular'
Plug 'ntpeters/vim-better-whitespace'
Plug 'windwp/nvim-autopairs'
Plug 'tpope/vim-surround'

-- git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'

-- tmux
Plug 'roxma/vim-tmux-clipboard'
Plug 'tmux-plugins/vim-tmux-focus-events'

-- git / vcs sign column
Plug 'mhinz/vim-signify'

-- motion
Plug 'phaazon/hop.nvim'

-- statusline
Plug 'nvim-lualine/lualine.nvim'

-- debug adapter protocol
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'leoluz/nvim-dap-go'

-- Treesitter
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})
Plug 'nvim-treesitter/nvim-treesitter-textobjects'

-- Mason
Plug('williamboman/mason.nvim', {['do'] = ':MasonUpdate'})
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'

-- CMP
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'

-- snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'

-- golang
Plug 'ray-x/go.nvim'
Plug('ray-x/guihua.lua', {['do'] = 'cd lua/fzy && make' })


vim.call('plug#end')

-- Settings
vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- Helper function for config
local fn = vim.fn
local api = vim.api
local executable = function(e)
  return fn.executable(e) > 0
end

local opts_info = vim.api.nvim_get_all_options_info()

local opt = setmetatable(
                {}, {
      __newindex = function(_, key, value)
        vim.o[key] = value
        local scope = opts_info[key].scope
        if scope == 'win' then
          vim.wo[key] = value
        elseif scope == 'buf' then
          vim.bo[key] = value
        end
      end
    }
            )

local function add(value, str, sep)
  sep = sep or ','
  str = str or ''
  value = type(value) == 'table' and table.concat(value, sep) or value
  return str ~= '' and table.concat({ value, str }, sep) or value
end

-- Mouse
vim.o.mouse = 'a'
vim.o.mousefocus = true

-- Numbers

vim.o.number = true
vim.o.relativenumber = true

-- Timings

vim.o.updatetime = 1000
vim.o.timeout = true
vim.o.timeoutlen = 500
vim.o.ttimeoutlen = 10

-- Window splitting and buffers

opt.ruler = true
vim.o.hidden = true
vim.o.encoding = 'utf-8'
vim.o.fileencoding = 'utf-8'
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.eadirection = 'hor'
vim.o.t_Co = 'xterm-256color'
-- exclude usetab as we do not want to jump to buffers in already open tabs
-- do not use split or vsplit to ensure we don't open any new windows
vim.o.switchbuf = 'useopen,uselast'
vim.o.fillchars = add {
  'vert:▕', -- alternatives │
  'fold: ',
  'eob: ', -- suppress ~ at EndOfBuffer
  'diff:─', -- alternatives: ⣿ ░
  'msgsep:‾',
  'foldopen:▾',
  'foldsep:│',
  'foldclose:▸'
}

-- Diff

-- Use in vertical diff mode, blank lines to keep sides aligned, Ignore whitespace changes
vim.o.diffopt = add(
                    {
      'vertical',
      'iwhite',
      'hiddenoff',
      'foldcolumn:0',
      'context:4',
      'algorithm:histogram',
      'indent-heuristic'
    }, vim.o.diffopt
                    )

-- Format Options

opt.formatoptions = table.concat(
                        {
      '1',
      'q', -- continue comments with gq"
      'c', -- Auto-wrap comments using textwidth
      'r', -- Continue comments when pressing Enter
      'n', -- Recognize numbered lists
      '2', -- Use indent from 2nd line of a paragraph
      't', -- autowrap lines using text width value
      'j', -- remove a comment leader when joining lines.
      -- Only break if the line was not longer than 'textwidth' when the insert
      -- started and only at a white character that has been entered during the
      -- current insert command.
      'lv'
    }
                    )

-- Folds

vim.o.foldtext = 'v:lua.folds()'
vim.o.foldopen = add(vim.o.foldopen, 'search')
vim.o.foldlevel = 99
vim.o.foldlevelstart = 10
opt.foldmethod = 'syntax'

-- Grepprg

-- Use faster grep alternatives if possible
if executable('rg') then
  vim.o.grepprg =
      [[rg --hidden --glob "!.git" --no-heading --smart-case --vimgrep --follow $*]]
  vim.o.grepformat = add('%f:%l:%c:%m', vim.o.grepformat)
elseif executable('ag') then
  vim.o.grepprg = [[ag --nogroup --nocolor --vimgrep]]
  vim.o.grepformat = add('%f:%l:%c:%m', vim.o.grepformat)
end

-- Wild and file globbing stuff in command mode

vim.o.wildcharm = api.nvim_eval([[char2nr("\<C-Z>")]]) -- FIXME: what's the correct way to do this?
vim.o.wildmenu = true
vim.o.wildmode = 'full' -- Shows a menu bar as opposed to an enormous list
vim.o.wildignorecase = true -- Ignore case when completing file names and directories
-- Binary
vim.o.wildignore = add {
  '*.aux,*.out,*.toc',
  '*.o,*.obj,*.dll,*.jar,*.pyc,*.rbc,*.class',
  '*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp',
  '*.avi,*.m4a,*.mp3,*.oga,*.ogg,*.wav,*.webm',
  '*.eot,*.otf,*.ttf,*.woff',
  '*.doc,*.pdf',
  '*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz',
  -- Cache
  '.sass-cache',
  '*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*.gem',
  -- Temp/System
  '*.*~,*~ ',
  '*.swp,.lock,.DS_Store,._*,tags.lock',
  -- golang
  'go/pkg,go/bin,go/bin-vagrant',
  -- lua
  '.luac'
}
vim.o.wildoptions = 'pum'
vim.o.pumblend = 3 -- Make popup window translucent

-- Display

opt.conceallevel = 0
opt.breakindentopt = 'sbr'
opt.linebreak = true -- lines wrap at words rather than random characters
opt.signcolumn = 'yes:1'
opt.colorcolumn = '+1' -- Set the colour column to highlight one column after the 'textwidth'
vim.o.cmdheight = 1 -- Set command line height to one lines
vim.o.showbreak = [[↪ ]] -- Options include -> '…', '↳ ', '→','↪ '
vim.g.vimsyn_embed = 'lPr' -- allow embedded syntax highlighting for lua,python and ruby

-- Indentation

opt.wrap = true
opt.wrapmargin = 2
opt.softtabstop = 2
opt.textwidth = 80
opt.shiftwidth = 2
opt.expandtab = true
opt.smarttab = true
opt.autoindent = true
opt.smartindent = true
opt.breakindent = true
vim.o.shiftround = true

-- Utilities
vim.o.joinspaces = false
vim.o.gdefault = false
vim.o.pumheight = 15
vim.o.confirm = false -- prompt when exiting with unsaved buffers
vim.o.completeopt = add { 'menuone', 'noinsert', 'noselect' }
vim.o.hlsearch = true
vim.o.autowrite = true
vim.o.autowriteall = true -- automatically :write before running commands and changing files
vim.o.clipboard = [[unnamed,unnamedplus]]
vim.o.lazyredraw = true
vim.o.laststatus = 2
vim.o.showtabline = 1
vim.o.cursorcolumn = false
vim.o.cursorline = false
vim.o.ttyfast = true
vim.o.belloff = 'all'
vim.o.termguicolors = true
vim.o.background = 'dark'
vim.o.guifont = "Monospace:h15"
vim.o.showmode = true
vim.o.showcmd = true
vim.o.backup = false
vim.o.writebackup = false
vim.o.visualbell = true
vim.o.errorbells = false

vim.o.autoread = true
vim.o.mat = 2
vim.o.backspace = add { 'indent', 'eol', 'start' }

-- BACKUP AND SWAPS

vim.o.history = 1000
vim.o.swapfile = false
vim.o.backup = false
vim.o.writebackup = false
vim.o.undodir = vim.fn.expand('~/.config/nvim/undo')
if fn.isdirectory(vim.o.undodir) == 0 then
  fn.mkdir(vim.o.undodir, 'p')
end
opt.undofile = true
vim.o.undolevels=500

-- Match and search

vim.o.showmatch = true
vim.o.magic = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.wrapscan = true -- Searches wrap around the end of the file
vim.o.scrolloff = 9
vim.o.sidescrolloff = 10
vim.o.sidescroll = 1

-- Spelling

vim.o.spellsuggest = add(12, vim.o.spellsuggest)
vim.o.spelloptions = 'camel'
vim.o.spellcapcheck = '' -- don't check for capital letters at start of sentence
vim.o.fileformats = 'unix,mac,dos'
vim.o.complete = add('kspell', vim.o.complete)

-- Mouse

vim.o.mouse = 'a'
vim.o.mousefocus = true

-- Shell
vim.o.shell = "/bin/bash"

-- Also settings but using Vimscript
vim.cmd([[
  " Settings

  " colour scheme
  colorscheme dracula

  " vimdiff scheme
  if &diff
      colorscheme dracula
  endif

  " thanks jessfraz
  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \	exe "normal! g`\"" |
        \ endif

  au FocusLost * :wa              " Set vim to save the file on focus out.

  syntax sync minlines=256
  " open help vertically
  command! -nargs=* -complete=help Help vertical belowright help <args>
  autocmd FileType help wincmd L

  " CTRL-U in insert mode deletes a lot.	Use CTRL-G u to first break undo,
  " so that you can undo CTRL-U after inserting a line break.
  inoremap <C-U> <C-G>u<C-U>

  " map leader leader q to save and close all
  nnoremap <silent> <leader><leader>q :xa<CR>
  " map leader leader w to save
  nnoremap <silent> <leader><leader>w :w<CR>

  " Remove search highlight
  nnoremap <leader><space> :nohlsearch<CR>

  " Buffer prev/next
  nnoremap <C-x> :bnext<CR>
  nnoremap <C-z> :bprev<CR>

  " Increment / decrement int
  nnoremap <A-a> <C-a>
  nnoremap <A-x> <C-x>

  " Better split switching
  map <C-j> <C-W>j
  map <C-k> <C-W>k
  map <C-h> <C-W>h
  map <C-l> <C-W>l

  " Center the screen
  nnoremap <space> zz

  " Move up and down on splitted lines (on small width screens)
  map <Up> gk
  map <Down> gj
  map k gk
  map j gj

  " Just go out in insert mode
  imap jk <ESC>l

  nnoremap <F6> :setlocal spell! spell?<CR>

  " Search mappings: These will make it so that going to the next one in a
  " search will center on the line it's found in.
  nnoremap n nzzzv
  nnoremap N Nzzzv

  "nnoremap <leader>. :lcd %:p:h<CR>
  autocmd BufEnter * silent! lcd %:p:h

  " Act like D and C
  nnoremap Y y$

  " Do not show stupid q: window
  map q: :q

  " handle fat fingers
  map :Vs :vs
  map :Sp :sp
]])


-- Plugins

-- vim-better-whitespace
vim.cmd([[
  " highlight space characters that appear before or in-between tabs
  let g:show_spaces_that_precede_tabs=1

  " auto strip whitespace except for file with extention blacklisted
  let blacklist = ['diff', 'gitcommit', 'unite', 'qf', 'help', 'markdown']
  autocmd BufWritePre * if index(blacklist, &ft) < 0 | StripWhitespace
]])


-- lualine
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'dracula',
    component_separators = { left = '', right = '|'},
    section_separators = { left = '', right = '|'},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 200,
      tabline = 500,
      winbar = 300,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {
      {
        'branch',
        icons_enabled = false
      },
      'diff',
      'diagnostics',
    },
    lualine_c = {},
    lualine_x = {'encoding', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {},
    lualine_x = {'encoding', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  tabline = {},
  winbar = {
    lualine_a = {'buffers'}
  },
  inactive_winbar = {
    lualine_a = {'buffers'}
  },
  extensions = {},
}

-- hop.nvim
require'hop'.setup()

-- keybindings
local hop = require('hop')
local directions = require('hop.hint').HintDirection
vim.keymap.set('', '<leader>f', function()
hop.hint_char2({ direction = directions.AFTER_CURSOR, current_line_only = false })
end, {remap=true})
vim.keymap.set('', '<leader>F', function()
hop.hint_char2({ direction = directions.BEFORE_CURSOR, current_line_only = false })
end, {remap=true})
vim.keymap.set('', '<leader>w', function()
hop.hint_words({ direction = directions.AFTER_CURSOR, current_line_only = false })
end, {remap=true})
vim.keymap.set('', '<leader>W', function()
hop.hint_words({ direction = directions.BEFORE_CURSOR, current_line_only = false })
end, {remap=true})

-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- tree-sitter
require'nvim-treesitter.configs'.setup {
	ensure_installed = all,
	auto_install = true,
	indent = {
		enable = true
	},
	highlight = {
		enable = true,
		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
}

-- mason.nvim

require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

-- mason-lspconfig
require("mason-lspconfig").setup {
	ensure_instsalled = { "gopls", "terraformls", "spectral" }
}

-- nvim-cmp

-- Set up nvim-cmp.
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require("luasnip")
local cmp = require("cmp")

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm ({
        behavior = cmp.ConfirmBehavior.Insert,
        select = true
    }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
      -- they way you will only jump inside the snippet region
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
    { name = 'buffer' },
    { name = 'path' },
    { name = 'nvim_lsp_signature_help' },
  })
})

-- If you want insert `(` after select function or method item
require("nvim-autopairs").setup {}
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
-- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
--  capabilities = capabilities
--}
require('lspconfig').terraformls.setup{
  on_attach = function(client)
  require'completion'.on_attach(client)
  map_keys()
  print("lsp started")
  end,
}

-- YAML and k8s completion
require('lspconfig').yamlls.setup {
    on_attach = on_attach,
    settings = {
        yaml = {
            schemas = {
              kubernetes = "*.yaml",
              ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
              ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
              ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
              ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
              ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
              ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
              ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
              ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
              ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
              ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
              ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
              ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.28.2/all.json"] = "/*.yaml",
            },
        }
    },
}
-- luasnip

require("luasnip.loaders.from_vscode").load({ include = { "go" } }) -- Load only golang snippets

-- NVIM-LSP
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- go.nvim
require('go').setup{
    goimport = 'gopls', -- if set to 'gopls' will use golsp format
    gofmt = 'gopls', -- if set to gopls will use golsp format
    max_line_len = 120,
    tag_transform = false,
    test_dir = '',
    comment_placeholder = ' ',
    dap_debug = true,
    lsp_codelens = false,
    lsp_cfg = false,
    lsp_inlay_hints = {
      enable = false,
      current_line_only = true,
    },
}
local cfg = require'go.lsp'.config() -- config() return the go.nvim gopls setup
require('lspconfig').gopls.setup(cfg)

-- guihua floating window
require('guihua.maps').setup({
    maps = {
        close_view = '<C-q>',
    }
})

-- Run gofmt + goimport on save
local format_sync_grp = vim.api.nvim_create_augroup("GoImport", {})
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
    require('go.format').goimport()
    end,
    group = format_sync_grp,
})

require("dapui").setup()
require('dap-go').setup {
  -- Additional dap configurations can be added.
  -- dap_configurations accepts a list of tables where each entry
  -- represents a dap configuration. For more details do:
  -- :help dap-configuration
  dap_configurations = {
    {
    -- Must be "go" or it will be ignored by the plugin
    type = "go",
    name = "Attach remote",
    mode = "remote",
    request = "attach",
    },
  },
  -- delve configurations
  delve = {
    -- the path to the executable dlv which will be used for debugging.
    -- by default, this is the "dlv" executable on your PATH.
    path = "dlv",
    -- time to wait for delve to initialize the debug session.
    -- default to 20 seconds
    initialize_timeout_sec = 20,
    -- a string that defines the port to start delve debugger.
    -- default to string "${port}" which instructs nvim-dap
    -- to start the process in a random available port
    port = "${port}",
    -- additional args to pass to dlv
    args = {}
  },
}
