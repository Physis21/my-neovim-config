return {
  "neovim/nvim-lspconfig",
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    { "mason-org/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
    -- mason-lspconfig:
    -- - Bridges the gap between LSP config names (e.g. "lua_ls") and actual Mason package names (e.g. "lua-language-server").
    -- - Used here only to allow specifying language servers by their LSP name (like "lua_ls") in `ensure_installed`.
    -- - It does not auto-configure servers — we use vim.lsp.config() + vim.lsp.enable() explicitly for full control.
    "mason-org/mason-lspconfig.nvim",
    -- mason-tool-installer:
    -- - Installs LSPs, linters, formatters, etc. by their Mason package name.
    -- - We use it to ensure all desired tools are present.
    -- - The `ensure_installed` list works with mason-lspconfig to resolve LSP names like "lua_ls".
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- Useful status updates for LSP.
    {
      "j-hui/fidget.nvim",
      opts = {
        notification = {
          window = {
            winblend = 0, -- Background color opacity in the notification window
          },
        },
      },
    },
    -- [CHANGED] nvim-cmp capabilities are now set via vim.lsp.config('*', ...) instead of
    -- being passed per-server. cmp-nvim-lsp is still needed to generate those capabilities.
    --
    -- This is a small plugin whose only job is to advertise extra LSP client capabilities
    -- that a completion engine (nvim-cmp, via hrsh7th/nvim-cmp) can take advantage of.
    -- e.g snippet support, or richer completion item resolution, that Neovim's built-in
    -- vim.lsp.protocol.make_client_capabilities() doesn't declare by default.
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local is_windows = require("core.os").is_windows

    -- [CHANGED] Set capabilities globally for all servers using the wildcard config.
    -- This replaces the old per-server `cfg.capabilities = vim.tbl_deep_extend(...)` loop.
    -- nvim-cmp capabilities are merged here once, so every server inherits them automatically.
    vim.lsp.config("*", {
      capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), require("cmp_nvim_lsp").default_capabilities()),
    })

    --  This function gets run when an LSP attaches to a particular buffer.
    --    That is to say, every time a new file is opened that is associated with
    --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
    --    function will be executed to configure the current buffer
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
      callback = function(event)
        -- Create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local map = function(keys, func, desc, mode)
          mode = mode or "n"
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end
        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-t>.
        map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
        -- Find references for the word under your cursor.
        map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
        -- Rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
            end,
          })
        end
        -- The following code creates a keymap to toggle inlay hints in your
        -- code, if the language server you are using supports them
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map("<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
          end, "[T]oggle Inlay [H]ints")
        end
      end,
    })

    -- Diagnostic Config
    -- See :help vim.diagnostic.Opts
    vim.diagnostic.config({
      severity_sort = true,
      -- [CHANGED] `border` is now set via the global `vim.o.winborder` option in Neovim 0.12,
      -- but passing it here still works and is more explicit/local. Keeping it here is fine.
      float = { border = "rounded", source = "if_many" },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = "󰅚 ",
          [vim.diagnostic.severity.WARN] = "󰀪 ",
          [vim.diagnostic.severity.INFO] = "󰋽 ",
          [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
      } or {},
      virtual_text = {
        source = "if_many",
        spacing = 2,
        format = function(diagnostic)
          local diagnostic_message = {
            [vim.diagnostic.severity.ERROR] = diagnostic.message,
            [vim.diagnostic.severity.WARN] = diagnostic.message,
            [vim.diagnostic.severity.INFO] = diagnostic.message,
            [vim.diagnostic.severity.HINT] = diagnostic.message,
          }
          return diagnostic_message[diagnostic.severity]
        end,
      },
    })

    -- Enable the following language servers
    --
    -- Add any additional override configuration in the following tables. Available keys are:
    -- - cmd (table): Override the default command used to start the server
    -- - filetypes (table): Override the default list of associated filetypes for the server
    -- - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
    -- - settings (table): Override the default settings passed when initializing the server.
    -- - root_markers (table): Files/dirs that identify the project root. Server won't attach without one.
    local servers = {
      -- gdscript = {
      --   filetypes = { "gd", "gdscript", "gdscript3" },
      --   -- root_markers = {}
      -- },
      tinymist = {},
      csharp_ls = {},
      jdtls = {},
      rust_analyzer = {},
      bashls = {},
      clangd = {}, -- c & c++
      -- ts_ls = {},
      vtsls = {},
      ruff = {},
      -- At the moment I am using pyright as pylsp bugged at cross-file resolution
      basedpyright = {
        root_markers = {
          "pyproject.toml",
          "setup.py",
          "setup.cfg",
          "requirements.txt",
          "Pipfile",
          "pyrightconfig.json",
          ".git",
        },
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "basic",
              -- uncomment when in standard typeCheckingMode
              diagnosticSeverityOverrides = {
                reportAttributeAccessIssue = "none",
                reportOptionalMemberAccess = "none",
                reportOptionalOperand = "none",
                reportUnknownMemberType = "none",
                reportUnknownVariableType = "none",
                reportUnknownArgumentType = "none",
                reportUnknownParameterType = "none",
                reportMissingTypeStubs = "none",
                reportOperatorIssue = "none",
                reportArgumentType = "none",
                reportAny = "none",
              },
            },
          },
        },
      },
      html = { filetypes = { "html", "twig", "hbs" } },
      cssls = {},
      -- tailwindcss = {},
      dockerls = {},
      -- sqlls = {},
      sqruff = {},
      -- terraformls = {},
      jsonls = {},
      yamlls = {},
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
            runtime = { version = "LuaJIT" },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.api.nvim_get_runtime_file("", true),
                "${3rd}/luv/library",
              },
            },
            diagnostics = {
              globals = { "vim" },
              disable = { "missing-fields" },
            },
            format = {
              enable = false,
            },
          },
        },
      },
    }

    if not is_windows then
      servers.autotools_ls = {} -- Makefiles
      servers.cmake = {}
    end

    -- Ensure the servers and tools above are installed
    -- Here are LSP servers not managed by Mason.
    local ensure_installed = vim.tbl_keys(servers or {})
    -- list_extend appends a table in place
    vim.list_extend(ensure_installed, {
      "stylua", -- Used to format Lua code
    })
    if not is_windows then
      -- table.insert appends a single value
      table.insert(ensure_installed, "asm-lsp")
    end
    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

    -- [CHANGED] Capabilities are now set globally via vim.lsp.config('*', ...) above,
    -- so we no longer need to merge them per-server here. The loop is simplified to just
    -- configure and enable each server.
    for server, cfg in pairs(servers) do
      vim.lsp.config(server, cfg)
      vim.lsp.enable(server)
    end
  end,
}
