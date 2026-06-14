function goto_c_implementation()
  local word = vim.fn.expand("<cword>")
  local h_file = vim.api.nvim_buf_get_name(0)
  local c_file = h_file:gsub("%.h$", ".c")
  if vim.fn.filereadable(c_file) == 1 then
    vim.cmd("edit " .. c_file)
    vim.cmd("/\\v^\\s*\\w+\\s+\\**" .. word .. "\\s*\\(")
  else
    print("Corresponding .c file not found: " .. c_file)
  end
end


local function get_repo_python_path(root_dir)
  if not root_dir then
    return nil
  end

  local uv = vim.uv or vim.loop
  for _, venv_name in ipairs({ ".venv", "venv" }) do
    local venv_dir = root_dir .. "/" .. venv_name
    local python_path = venv_dir .. "/bin/python"
    local stat = uv.fs_stat(python_path)
    if stat and stat.type == "file" then
      return python_path
    end
  end

  return nil
end

return {
  "neovim/nvim-lspconfig",
  -- event = "LazyFile",
  dependencies = {
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
  },
  opts = function()
    ---@class PluginLspOpts
    local ret = {
      -- options for vim.diagnostic.config()
      ---@type vim.diagnostic.Opts
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
      },
      inlay_hints = {
        enabled = true,
      },
      codelens = {
        enabled = true,
      },
      -- add any global capabilities here
      capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },

      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              -- doesn't work
              diagnostics = {
                globals = { 'vim' }, -- Recognize `vim` as a global variable
              },
              workspace = {
                checkThirdParty = false,
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
        pyright = {
          on_new_config = function(config, root_dir)
            local python_path = get_repo_python_path(root_dir)
            if not python_path then
              return
            end

            config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
              python = {
                pythonPath = python_path,
              },
            })
          end,
          settings = {
            pyright = {
              disableOrganizeImports = true,
              analysis = {
                autoImportCompletions = true,
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                typeCheckingMode = "basic",
              },
            },
          },
        },
        ts_ls = {
          -- Use this to add any additional keymaps
          -- for specific lsp servers
          -- ---@type LazyKeysSpec[]
          -- keys = {},
          init_options = {
            preferences = {
              importModuleSpecifierPreference = "absolute",
              quotePreference = "double",
            },
          },
          settings = {
            completions = {
              completeFunctionCalls = true,
            },
          },
        },
        clangd = {
          init_options = {
            clangdFileStatus = true,
            usePlaceholders = true,
            completeUnimported = true,
            semanticHighlighting = true,
          },
          settings = {
            clangd = {
              fallbackFlags = { "-std=c++17" },
              fallbackStyle = "Google",
              formatStyle = "Google",
              formatFallbackStyle = "LLVM",
            },
          },
          on_attach = function(client, bufnr)
            vim.keymap.set("n", "<leader>ci", function()
              goto_c_implementation()
            end, { buffer = bufnr, desc = "Go to C implementation" })
          end,
        },
        gopls = {
          settings = {
            gopls = {
              gofumpt = true, -- use gofumpt for stricter formatting
              analyses = {
                unusedparams = true,
              },
              staticcheck = true,
            },
          },
          on_attach = function(client, bufnr)
            -- Format and organize imports on save
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function()
                -- Organize imports
                local params = vim.lsp.util.make_range_params()
                params.context = { only = { "source.organizeImports" } }
                local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
                for _, res in pairs(result or {}) do
                  for _, r in pairs(res.result or {}) do
                    if r.edit then
                      vim.lsp.util.apply_workspace_edit(r.edit, "utf-8")
                    end
                  end
                end
                -- Format
                vim.lsp.buf.format({ async = false })
              end,
            })
          end,
        },
        rust_analyzer = {},
        clojure_lsp = {},
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },

      on_attach = function (client, bufnr)
        -- Add any additional on_attach functionality here
        -- e.g. keymaps, formatting, etc.
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code action" })
        vim.keymap.set("n", "<leader>ic", "<cmd>Telescope lsp_incoming_calls<CR>", { buffer = bufnr, desc = "Incoming calls" })

        if client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = true })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = "LspDocumentHighlight",
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.document_highlight()
            end,
          })
          vim.api.nvim_create_autocmd("CursorMoved", {
            group = "LspDocumentHighlight",
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.clear_references()
            end,
          })

          -- keybinds to call go to def and references using telescope lsp stuff
          vim.keymap.set("n", "gd", function()
            require("telescope.builtin").lsp_definitions({
              show_line = false,
            })
          end, { buffer = bufnr, desc = "Go to definition" })
          vim.keymap.set("n", "gr", function()
            require("telescope.builtin").lsp_references({
              show_line = false,
              jump_type = "never",
              layout_strategy = "vertical",
              layout_config = {
                preview_height = 0.5,
              },
            })
          end, { buffer = bufnr, desc = "Go to references" })
          vim.keymap.set("n", "gi", function()
            require("telescope.builtin").lsp_implementations({
              show_line = false,
              jump_type = "never",
            })
          end, { buffer = bufnr, desc = "Go to implementations" })
        end
      end
    }
    return ret
  end,

  ---@param opts PluginLspOpts
  config = function(_, opts)
    vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

    local servers = opts.servers
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local has_blink, blink = pcall(require, "blink.cmp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_nvim_lsp.default_capabilities() or {},
      has_blink and blink.get_lsp_capabilities() or {},
      opts.capabilities or {}
    )

    local function setup(server)
      local server_opts = vim.tbl_deep_extend("force", {
        capabilities = vim.deepcopy(capabilities),
        on_attach = function(client, bufnr)
          if opts.on_attach then
            opts.on_attach(client, bufnr)
          end
          if opts.servers[server] and opts.servers[server].on_attach then
            opts.servers[server].on_attach(client, bufnr)
          end
        end,
      }, servers[server] or {})
      if server_opts.enabled == false then
        return
      end

      if opts.setup[server] then
        if opts.setup[server](server, server_opts) then
          return
        end
      elseif opts.setup["*"] then
        if opts.setup["*"](server, server_opts) then
          return
        end
      end
      require("lspconfig")[server].setup(server_opts)
    end

    for server, server_opts in pairs(servers) do
        setup(server)
    end
  end,
}
