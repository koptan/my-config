-- Koptan neovim config | 2023

local vim = vim
local execute = vim.api.nvim_command
local fn = vim.fn
local api = vim.api

-- Key Mapping
-- Function to make Mapping easer 
local key_mapper = function(mode, key, result)
  vim.api.nvim_set_keymap(
    mode,
    key,
    result,
    {noremap = true, silent = true}
  )
end

-- Mapping leader to Space
vim.g.mapleader = ' '

-- No arrow, force your self to use hjkl
key_mapper('', '<up>', '<nop>')
key_mapper('', '<down>', '<nop>')
key_mapper('', '<left>', '<nop>')
key_mapper('', '<right>', '<nop>')

-- Fixing system clipboard
  vim.cmd([[
  " " Copy to clipboard
  vnoremap  <leader>y  "+y
  nnoremap  <leader>Y  "+yg_
  nnoremap  <leader>y  "+y
  nnoremap  <leader>yy  "+yy
  " " Paste from clipboard
  nnoremap <leader>p "+p
  nnoremap <leader>P "+P
  vnoremap <leader>p "+p
  vnoremap <leader>P "+P
  ]])

-- Nvim Tree
key_mapper("n", "<leader>nt", ":NvimTreeToggle<CR>")

-- Window navigation
key_mapper("n", "<C-j>", "<C-w>j<C-w>")
key_mapper("n", "<C-h>", "<C-w>h<C-w>")
key_mapper("n", "<C-k>", "<C-w>k<C-w>")
key_mapper("n", "<C-l>", "<C-w>l<C-w>")

--FTrem
key_mapper('n', 't', '<CMD>lua require("FTerm").toggle()<CR>')
key_mapper('t', '<leader><Esc>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')

-- Trouble
key_mapper("n", "<leader>xx", "<cmd>TroubleToggle<cr>")
key_mapper("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>")
key_mapper("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>")
key_mapper("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>")
key_mapper("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>")
key_mapper("n", "gR", "<cmd>TroubleToggle lsp_references<cr>")

-- Telescope
local builtin = require('telescope.builtin')
key_mapper("n", "<leader>ff", "<CMD>lua require('telescope.builtin').find_files()<CR>")
key_mapper("n", "<leader>fg", "<CMD>lua require('telescope.builtin').live_grep()<CR>")
key_mapper("n", "<leader>fb", "<CMD>lua require('telescope.builtin').buffers()<CR>")
key_mapper("n", "<leader>fh", "<CMD>lua require('telescope.builtin').help_tags()<CR>")
key_mapper("n", "<leader>fi", "<CMD>lua require('telescope.builtin').lsp_implementations()<CR>")
-- Hop
key_mapper("n", "HH", ":HopLineStart<cr>")
key_mapper("n", "HF", ":HopPattern<cr>")
key_mapper("n", "HL", ":HopWordCurrentLine<cr>")
-- markdown-preview
--key_mapper("n", "PP", "<Plug>MarkdownPreview>")

key_mapper('i', '<F2>', '<cmd>lua require("renamer").rename()<cr>' )
key_mapper('n', '<leader>rn', '<cmd>lua require("renamer").rename()<cr>')
key_mapper('v', '<leader>rn', '<cmd>lua require("renamer").rename()<cr>')


-- Fix common typos
vim.cmd([[
      cnoreabbrev W! w!
      cnoreabbrev W1 w!
      cnoreabbrev w1 w!
      cnoreabbrev Q! q!
      cnoreabbrev Q1 q!
      cnoreabbrev q1 q!
      cnoreabbrev Qa! qa!
      cnoreabbrev Qall! qall!
      cnoreabbrev Wa wa
      cnoreabbrev Wq wq
      cnoreabbrev wQ wq
      cnoreabbrev WQ wq
      cnoreabbrev wq1 wq!
      cnoreabbrev Wq1 wq!
      cnoreabbrev wQ1 wq!
      cnoreabbrev WQ1 wq!
      cnoreabbrev W w
      cnoreabbrev Q q
      cnoreabbrev Qa qa
      cnoreabbrev Qall qall
]])

-- I like my cmd+s for saving files. In insert mode!
-- The terminal (or iterm) does not have support for anything related to
-- Command key
-- Hence need to hack stuff -
-- https://stackoverflow.com/questions/33060569/mapping-command-s-to-w-in-vim
api.nvim_set_keymap("i", "<C-s>", "<Esc>:w<CR>i", {noremap = true})
api.nvim_set_keymap("n", "<C-s>", ":w<CR>", {noremap = true})

-- Plugins setup 
-- Mason 
require("mason").setup()


 -- Treesitter Textobject
require'nvim-treesitter.configs'.setup {
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        -- You can optionally set descriptions to the mappings (used in the desc parameter of
        -- nvim_buf_set_keymap) which plugins like which-key display
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
      },
      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V', -- linewise
        ['@class.outer'] = '<c-v>', -- blockwise
      },
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true of false
      include_surrounding_whitespace = true,
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["ff"] = "@function.outer",
        ["cc"] = { query = "@class.outer", desc = "Next class start" },
      },
      goto_next_end = {
        ["nf"] = "@function.outer",
        ["nc"] = "@class.outer",
      },
      goto_previous_start = {
        ["pf"] = "@function.outer",
        ["pc"] = "@class.outer",
      },
      goto_previous_end = {
        ["pF"] = "@function.outer",
        ["pC"] = "@class.outer",
      },
    },
    lsp_interop = {
      enable = true,
      border = 'double',
      floating_preview_opts = {},
      peek_definition_code = {
        ["<leader>df"] = "@function.outer",
        ["<leader>dF"] = "@class.outer",
      },
    },
  },
}

-- Toolbar 
-- require('lualine').setup()
require'lualine'.setup{
	sections = {
		lualine_c = {
			'lsp_progress'
		}
	},
    options = {
        theme = "material"
        -- ... the rest of your lualine config
    }
}

--Trouble 
require("trouble").setup {
    position = "right"
}

-- Hop
require 'hop'.setup {
    keys = 'etovxqpdygfblzhckisuran',
    jump_on_sole_occurrence = false,
}

-- Auto Complete 
-- Completion
-- Better completion
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force user to select one from the menu
vim.opt.completeopt = { 'menuone', 'noselect', 'noinsert' }

local cmp = require'cmp'
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
      ['<S-Tab>'] = cmp.mapping.select_prev_item(),
      ['<Tab>'] = cmp.mapping.select_next_item(),
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp', keyword_length = 1, priority = 1 },
      { name = 'luasnip' }, -- For luasnip users.
      { name = 'path' }, 
    }, {
      { name = 'buffer' },
    })
})

--Nvm Tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require("nvim-tree").setup{
    view = {
        width = 50,
    },
    update_focused_file = {
        enable = true,
    },
}


-- FTerm
require 'FTerm'.setup({
      border     = 'double',
      -- cmd = os.getenv('SHELL'),
      cmd        = 'fish',
      blend      = 0,
      dimensions = {
          height = 0.9,
          width = 0.9,
      },
})


-- LSP Config
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require'lspconfig'
local on_attach = function(client, bufnr)

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)


  -- Enable inlay hints auto update and set them for all the buffers
  ---rt.inlay_hints.set()

  -- Get signatures (and _only_ signatures) when in argument lists.
  require "lsp_signature".on_attach({
    doc_lines = 0,
    handler_opts = {
      border = "double"
    },
  })
  -- Treesitter 
 require('nvim-treesitter.configs').setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "lua", "rust", "lua","typescript","javascript","tsx","java"},

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  incremental_selection = {
    enable = true,
    keymaps = {
        init_selection = "<CR>",
		node_incremental = "<CR>",
		scope_incremental = "<Tab>",
		node_decremental = "<S-Tab>",  
    },
  },
  indent = {
    enable = true
  }
}
end

-- Rust
local format_sync_grp = vim.api.nvim_create_augroup("Format", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    vim.lsp.buf.format({ timeout_ms = 200 })
  end,
  group = format_sync_grp,
})

local rt = require("rust-tools")
rt.setup{
  tools = {
    autoSetHints = true,
      --hover_with_actions = true,
      inlay_hints = {
        auto = true,
        show_parameter_hints = false,
        parameter_hints_prefix = "",
        other_hints_prefix = "",
      },
  },

  server = {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      -- to enable rust-analyzer settings visit:
      -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
      ["rust-analyzer"] = {
         -- HACK: https://github.com/simrat39/rust-tools.nvim/issues/300
        inlayHints = { locationLinks = false },
        -- enable clippy on save
        checkOnSave = {
            command = "clippy"
        },
        cargo = {
          allFeatures = true,
       },
      }
    }
  }
}
--Typescript and Javascript
require('lspconfig').tsserver.setup {}


--Java 

local java_cmds = vim.api.nvim_create_augroup('java_cmds', {clear = true})
local cache_vars = {}

local root_files = {
  '.git',
  'mvnw',
  'gradlew',
  'pom.xml',
  'build.gradle',
}

local features = {
  -- change this to `true` to enable codelens
  codelens = false,

  -- change this to `true` if you have `nvim-dap`,
  -- `java-test` and `java-debug-adapter` installed
  debugger = false,
}

local function get_jdtls_paths()
  if cache_vars.paths then
    return cache_vars.paths
  end

  local path = {}

  path.data_dir = vim.fn.stdpath('cache') .. '/nvim-jdtls'

  local jdtls_install = require('mason-registry')
    .get_package('jdtls')
    :get_install_path()

  path.java_agent = jdtls_install .. '/lombok.jar'
  path.launcher_jar = vim.fn.glob(jdtls_install .. '/plugins/org.eclipse.equinox.launcher_*.jar')

  if vim.fn.has('mac') == 1 then
    path.platform_config = jdtls_install .. '/config_mac'
  elseif vim.fn.has('unix') == 1 then
    path.platform_config = jdtls_install .. '/config_linux'
  elseif vim.fn.has('win32') == 1 then
    path.platform_config = jdtls_install .. '/config_win'
  end

  path.bundles = {}

  ---
  -- Include java-test bundle if present
  ---
  local java_test_path = require('mason-registry')
    .get_package('java-test')
    :get_install_path()

  local java_test_bundle = vim.split(
    vim.fn.glob(java_test_path .. '/extension/server/*.jar'),
    '\n'
  )

  if java_test_bundle[1] ~= '' then
    vim.list_extend(path.bundles, java_test_bundle)
  end

  ---
  -- Include java-debug-adapter bundle if present
  ---
  local java_debug_path = require('mason-registry')
    .get_package('java-debug-adapter')
    :get_install_path()

  local java_debug_bundle = vim.split(
    vim.fn.glob(java_debug_path .. '/extension/server/com.microsoft.java.debug.plugin-*.jar'),
    '\n'
  )

  if java_debug_bundle[1] ~= '' then
    vim.list_extend(path.bundles, java_debug_bundle)
  end

  ---
  -- Useful if you're starting jdtls with a Java version that's 
  -- different from the one the project uses.
  ---
  path.runtimes = {
    -- Note: the field `name` must be a valid `ExecutionEnvironment`,
    -- you can find the list here: 
    -- https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    --
    -- This example assume you are using sdkman: https://sdkman.io
    -- {
    --   name = 'JavaSE-17',
    --   path = vim.fn.expand('~/.sdkman/candidates/java/17.0.6-tem'),
    -- },
    -- {
    --   name = 'JavaSE-18',
    --   path = vim.fn.expand('~/.sdkman/candidates/java/18.0.2-amzn'),
    -- },
  }

  cache_vars.paths = path

  return path
end

local function enable_codelens(bufnr)
  pcall(vim.lsp.codelens.refresh)

  vim.api.nvim_create_autocmd('BufWritePost', {
    buffer = bufnr,
    group = java_cmds,
    desc = 'refresh codelens',
    callback = function()
      pcall(vim.lsp.codelens.refresh)
    end,
  })
end

local function enable_debugger(bufnr)
  require('jdtls').setup_dap({hotcodereplace = 'auto'})
  require('jdtls.dap').setup_dap_main_class_configs()

  local opts = {buffer = bufnr}
  vim.keymap.set('n', '<leader>df', "<cmd>lua require('jdtls').test_class()<cr>", opts)
  vim.keymap.set('n', '<leader>dn', "<cmd>lua require('jdtls').test_nearest_method()<cr>", opts)
end

local function jdtls_on_attach(client, bufnr)
  on_attach(client,bufnr)
  if features.debugger then
    enable_debugger(bufnr)
  end

  if features.codelens then
    enable_codelens(bufnr)
  end

  -- The following mappings are based on the suggested usage of nvim-jdtls
  -- https://github.com/mfussenegger/nvim-jdtls#usage
  
  local opts = {buffer = bufnr}
  vim.keymap.set('n', '<A-o>', "<cmd>lua require('jdtls').organize_imports()<cr>", opts)
  vim.keymap.set('n', 'crv', "<cmd>lua require('jdtls').extract_variable()<cr>", opts)
  vim.keymap.set('x', 'crv', "<esc><cmd>lua require('jdtls').extract_variable(true)<cr>", opts)
  vim.keymap.set('n', 'crc', "<cmd>lua require('jdtls').extract_constant()<cr>", opts)
  vim.keymap.set('x', 'crc', "<esc><cmd>lua require('jdtls').extract_constant(true)<cr>", opts)
  vim.keymap.set('x', 'crm', "<esc><Cmd>lua require('jdtls').extract_method(true)<cr>", opts)
end

local function jdtls_setup(event)
  local jdtls = require('jdtls')

  local path = get_jdtls_paths()
  local data_dir = path.data_dir .. '/' ..  vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

  if cache_vars.capabilities == nil then
    jdtls.extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

    local ok_cmp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
    cache_vars.capabilities = vim.tbl_deep_extend(
      'force',
      vim.lsp.protocol.make_client_capabilities(),
      ok_cmp and cmp_lsp.default_capabilities() or {}
    )
  end

  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  local cmd = {
    -- 💀
    'java',

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-javaagent:' .. path.java_agent,
    '-Xms1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    
    -- 💀
    '-jar',
    path.launcher_jar,

    -- 💀
    '-configuration',
    path.platform_config,

    -- 💀
    '-data',
    data_dir,
  }

  local lsp_settings = {
    java = {
      -- jdt = {
      --   ls = {
      --     vmargs = "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m"
      --   }
      -- },
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = 'interactive',
        runtimes = path.runtimes,
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      -- inlayHints = {
      --   parameterNames = {
      --     enabled = 'all' -- literals, all, none
      --   }
      -- },
      format = {
        enabled = true,
        -- settings = {
        --   profile = 'asdf'
        -- },
      }
    },
    signatureHelp = {
      enabled = true,
    },
    completion = {
      favoriteStaticMembers = {
        'org.hamcrest.MatcherAssert.assertThat',
        'org.hamcrest.Matchers.*',
        'org.hamcrest.CoreMatchers.*',
        'org.junit.jupiter.api.Assertions.*',
        'java.util.Objects.requireNonNull',
        'java.util.Objects.requireNonNullElse',
        'org.mockito.Mockito.*',
      },
    },
    contentProvider = {
      preferred = 'fernflower',
    },
    extendedClientCapabilities = jdtls.extendedClientCapabilities,
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      }
    },
    codeGeneration = {
      toString = {
        template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
      },
      useBlocks = true,
    },
  }

  -- This starts a new client & server,
  -- or attaches to an existing client & server depending on the `root_dir`.
  jdtls.start_or_attach({
    cmd = cmd,
    settings = lsp_settings,
    on_attach = jdtls_on_attach,
    capabilities = cache_vars.capabilities,
    root_dir = jdtls.setup.find_root(root_files),
    flags = {
      allow_incremental_sync = true,
    },
    init_options = {
      bundles = path.bundles,
    },
  })
end

vim.api.nvim_create_autocmd('FileType', {
  group = java_cmds,
  pattern = {'java'},
  desc = 'Setup jdtls',
  callback = jdtls_setup,
})

-- LSP lines 
require("lsp_lines").setup()

-- Indent Blackline
require("indent_blankline").setup()

-- Comment 
require('Comment').setup()


-- have a fixed column for the diagnostics to appear in
-- this removes the jitter when warnings/errors flow in
vim.wo.signcolumn = "yes"


-- Theme 
require('kanagawa').setup({
    keywordStyle = { italic = true, bold = true },
})
vim.cmd("colorscheme kanagawa")

-- UI
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.mouse = "a"

-- Disable virtual_text since it's redundant due to lsp_lines.
vim.diagnostic.config({
  virtual_text = false,
})

--rename
require('renamer').setup() 
------------------------------------------------------------------------------------------------------------------
-- Bootstraping NeoVim
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end


-- Installing Plugings 
local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use "williamboman/mason.nvim"
  use 'nvim-treesitter/nvim-treesitter'
  --Theme
  use 'rebelot/kanagawa.nvim'
  use 'nvim-tree/nvim-web-devicons'
  use 'folke/lsp-colors.nvim'
  --Toolbar 
  use {'nvim-lualine/lualine.nvim',requires = { 'kyazdani42/nvim-web-devicons', opt = true }}
  use 'arkav/lualine-lsp-progress'
  -- LSP 
  use 'neovim/nvim-lspconfig'
  use "https://git.sr.ht/~whynothugo/lsp_lines.nvim"
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use 'pangloss/vim-javascript'
  use 'mxw/vim-jsx'
  use 'sbdchd/neoformat'
  use 'mfussenegger/nvim-jdtls' -- java
  -- Tree 
  use 'nvim-tree/nvim-tree.lua'
  use 'simrat39/rust-tools.nvim'
  -- Debugging
  use 'nvim-lua/plenary.nvim'
  use 'mfussenegger/nvim-dap'
  -- Terminal
  use 'numToStr/FTerm.nvim'
  -- Telescope
  use {
   'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  -- Indent 
  use "lukas-reineke/indent-blankline.nvim"
  -- Comment
  use 'numToStr/Comment.nvim'
  use {'phaazon/hop.nvim',branch = 'v2'}
  -- Autocompletion
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'saadparwaiz1/cmp_luasnip'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-nvim-lua'
  use 'ray-x/lsp_signature.nvim'
  -- Snippets
  use 'L3MON4D3/LuaSnip'
  use 'rafamadriz/friendly-snippets'
  -- Error 
  use {"folke/trouble.nvim",requires = "kyazdani42/nvim-web-devicons" }
  -- markdown
  -- use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, }) 
  -- rename
  use {
   'filipdutescu/renamer.nvim',
    branch = 'master',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
