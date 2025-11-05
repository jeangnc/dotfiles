return {
  "neovim/nvim-lspconfig",
  opts = {
    -- options for vim.diagnostic.config()
    ---@type vim.diagnostic.Opts
    diagnostics = {
      underline = true,
      update_in_insert = false,
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
        -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
        -- prefix = "icons",
      },
      severity_sort = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
          [vim.diagnostic.severity.WARN] = LazyVim.config.icons.diagnostics.Warn,
          [vim.diagnostic.severity.HINT] = LazyVim.config.icons.diagnostics.Hint,
          [vim.diagnostic.severity.INFO] = LazyVim.config.icons.diagnostics.Info,
        },
      },
    },
    -- Enable this to enable the builtin LSP inlay hints on Neovim.
    -- Be aware that you also will need to properly configure your LSP server to
    -- provide the inlay hints.
    inlay_hints = {
      enabled = true,
      exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
    },
    -- Enable this to enable the builtin LSP code lenses on Neovim.
    -- Be aware that you also will need to properly configure your LSP server to
    -- provide the code lenses.
    codelens = {
      enabled = false,
    },
    -- Enable this to enable the builtin LSP folding on Neovim.
    -- Be aware that you also will need to properly configure your LSP server to
    -- provide the folds.
    folds = {
      enabled = true,
    },
    -- options for vim.lsp.buf.format
    -- `bufnr` and `filter` is handled by the LazyVim formatter,
    -- but can be also overridden when specified
    format = {
      formatting_options = nil,
      timeout_ms = nil,
    },
    -- LSP Server Settings
    -- Sets the default configuration for an LSP client (or all clients if the special name "*" is used).
    ---@alias lazyvim.lsp.Config vim.lsp.Config|{mason?:boolean, enabled?:boolean, keys?:LazyKeysLspSpec[]}
    ---@type table<string, lazyvim.lsp.Config|boolean>
    servers = {
      -- configuration for all lsp servers
      ["*"] = {
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },
        -- stylua: ignore
        keys = {
          { "<leader>cl", function() Snacks.picker.lsp_config() end, desc = "Lsp Info" },
          { "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
          { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
          { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
          { "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
          { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
          { "K", function() return vim.lsp.buf.hover() end, desc = "Hover" },
          { "gK", function() return vim.lsp.buf.signature_help() end, desc = "Signature Help", has = "signatureHelp" },
          { "<c-k>", function() return vim.lsp.buf.signature_help() end, mode = "i", desc = "Signature Help", has = "signatureHelp" },
          { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "x" }, has = "codeAction" },
          { "<leader>cc", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "x" }, has = "codeLens" },
          { "<leader>cC", vim.lsp.codelens.refresh, desc = "Refresh & Display Codelens", mode = { "n" }, has = "codeLens" },
          { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File", mode ={"n"}, has = { "workspace/didRenameFiles", "workspace/willRenameFiles" } },
          { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
          { "<leader>cA", LazyVim.lsp.action.source, desc = "Source Action", has = "codeAction" },
          { "]]", function() Snacks.words.jump(vim.v.count1) end, has = "documentHighlight",
            desc = "Next Reference", enabled = function() return Snacks.words.is_enabled() end },
          { "[[", function() Snacks.words.jump(-vim.v.count1) end, has = "documentHighlight",
            desc = "Prev Reference", enabled = function() return Snacks.words.is_enabled() end },
          { "<a-n>", function() Snacks.words.jump(vim.v.count1, true) end, has = "documentHighlight",
            desc = "Next Reference", enabled = function() return Snacks.words.is_enabled() end },
          { "<a-p>", function() Snacks.words.jump(-vim.v.count1, true) end, has = "documentHighlight",
            desc = "Prev Reference", enabled = function() return Snacks.words.is_enabled() end },
        },
      },
      stylua = { enabled = false },
      lua_ls = {
        -- mason = false, -- set to false if you don't want this server to be installed with mason
        -- Use this to add any additional keymaps
        -- for specific lsp servers
        -- ---@type LazyKeysSpec[]
        -- keys = {},
        settings = {
          Lua = {
            workspace = {
              checkThirdParty = false,
            },
            codeLens = {
              enable = true,
            },
            completion = {
              callSnippet = "Replace",
            },
            doc = {
              privateName = { "^_" },
            },
            hint = {
              enable = true,
              setType = false,
              paramType = true,
              paramName = "Disable",
              semicolon = "Disable",
              arrayIndex = "Disable",
            },
          },
        },
      },
    },
    -- you can do any additional lsp server setup here
    -- return true if you don't want this server to be setup with lspconfig
    ---@type table<string, fun(server:string, opts: vim.lsp.Config):boolean?>
    setup = {
      -- example to setup with typescript.nvim
      -- tsserver = function(_, opts)
      --   require("typescript").setup({ server = opts })
      --   return true
      -- end,
      -- Specify * to use this function as a fallback for any server
      -- ["*"] = function(server, opts) end,
    },
  },
}
