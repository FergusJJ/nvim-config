return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "j-hui/fidget.nvim",
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
    --needed for java, idk whether same is needed for python etc
    "mfussenegger/nvim-jdtls",
    "windwp/nvim-ts-autotag",
  },

  config = function()
    local cmp = require('cmp')
    local cmp_lsp = require("cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities())

    require("fidget").setup({})
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "basedpyright",
        "buf_ls",
        "clangd",
        "cssls",
        "cssmodules_ls",
        -- "elixirls",
        "lua_ls",
        "gopls",
        -- "hls",
        -- "jdtls",
        "prismals",
        -- "ruff",
        -- "rust_analyzer",
        -- "solidity_ls_nomicfoundation",
        "ts_ls",

      },
      require("nvim-ts-autotag").setup({}),

      handlers = {
        function(server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup {
            capabilities = capabilities
          }
        end,


        ["basedpyright"] = function()
          local lspconfig = require("lspconfig")
          local util = require("lspconfig/util")

          lspconfig.basedpyright.setup {
            settings = {
              basedpyright = {
                disableOrganizeImports = true,
                analysis = {
                  ignore = { "*" },
                  useLibraryCodeForTypes = true,
                  typeCheckingMode = "standard",
                  diagnosticMode = "openFilesOnly",
                  autoImportCompletions = true,
                }
              },
            },
            before_init = function(_, config)
              local venv_base_path = util.path.join(vim.env.HOME, "virtualenvs")
              local venv_python_path = util.path.join(venv_base_path, "default-venv", "bin", "python")

              if config.root_dir ~= nil then
                local root_dir_name = ""
                for substring in string.gmatch(config.root_dir, "([^/]+)") do
                  root_dir_name = substring
                end
                local project_venv_path = util.path.join(venv_base_path, root_dir_name)
                local project_venv_bin_path = util.path.join(project_venv_path, "bin", "python")
                local function dir_exists(path)
                  local stat = vim.loop.fs_stat(path)
                  return stat and stat.type == 'directory'
                end
                if not dir_exists(project_venv_path) then
                  os.execute(string.format("python3 -m venv %s", project_venv_path))
                  print("Created virtual environment: ", project_venv_path)
                  local requirements_path = util.path.join(config.root_dir, "requirements.txt")
                  local function file_exists(path)
                    local stat = vim.loop.fs_stat(path)
                    return stat and stat.type == 'file'
                  end
                  if file_exists(requirements_path) then
                    os.execute(string.format("%s -m pip install -r %s", project_venv_bin_path,
                      requirements_path))
                    print("Installed dependencies from requirements.txt")
                  else
                    print("No requirements.txt file found.")
                  end
                end
                venv_python_path = project_venv_bin_path
                print("setting venv: %s", venv_python_path)
              end

              -- Set the Python path in the LSP config
              config.settings.python = {
                pythonPath = venv_python_path
              }
            end,
          }
        end,

        ["clangd"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.clangd.setup {
            root_dir = require("lspconfig").util.root_pattern("src"),
            cmd = {
              "clangd",
              "--background-index",
              "--pch-storage=memory",
              "--all-scopes-completion",
              "--pretty",
              "--header-insertion=never",
              "-j=4",
              "--inlay-hints",
              "--header-insertion-decorators",
              "--function-arg-placeholders",
              "--completion-style=detailed",
            },
            filetypes = { "c", "cpp", "objc", "objcpp" },
            capabilities = capabilities,
          }
        end,

        ["cssmodules_ls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.cssmodules_ls.setup {
            filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
            capabilities = capabilities,
            init_options = {
              camelCase = "dashes"
            }
          }
        end,
        ["elixirls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.elixirls.setup {
            capabilities = capabilities,
            settings = {
              elixirLS = {
                dialyzerEnabled = true,
                fetchDeps = false,
                enableTestLenses = true,
                suggestSpecs = true,
              }
            },
          }
        end,

        ["lua_ls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.lua_ls.setup {
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = { version = "Lua 5.1" },
                diagnostics = {
                  globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                }
              }
            }
          }
        end,
        ["ruff"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.ruff.setup {
            on_attach = function(client, _)
              client.server_capabilities.hoverProvider = false
            end
          }
        end,

        ["rust_analyzer"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.rust_analyzer.setup {}
        end,

        ["solidity_ls_nomicfoundation"] = function()
          local lspconfig = require("lspconfig")
          local util = require("lspconfig.util")

          lspconfig.solidity.setup {
            cmd = { "nomicfoundation-solidity-language-server", "--stdio" },
            filetypes = { "solidity" },
            root_dir = util.root_pattern("hardhat.config.js", "hardhat.config.ts", "foundry.toml", "forge.toml", ".git"),
            single_file_support = true,
            settings = {
              solidity = {
                remappings = {
                  ["@openzeppelin/"] = "lib/openzeppelin-contracts/",
                  ["forge-std/"] = "lib/forge-std/src/",
                  ["account-abstraction/"] = "lib/account-abstraction/"
                },
                formatting = {
                  provider = "prettierd",
                },
                linter = "solhint"
              },
            },
          }
        end,
        -- TODO  add oxlint
        ["ts_ls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.ts_ls.setup {
            filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
            capabilities = capabilities
          }
        end,

      },

    })

    require("lspconfig").sourcekit.setup({
      capabilities = capabilities
    })
    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    cmp.setup({
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
      }),
      sources = cmp.config.sources({
        { name = "lazydev", group_index = 0 },
        { name = 'nvim_lsp' },
        { name = 'luasnip' }, -- For luasnip users.
      }, {
        { name = 'buffer' },
        { name = 'path' },
      })
    })

    vim.diagnostic.config({
      update_in_insert = true,
      float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
        source = "if_many",
        header = "",
        prefix = "",
      },
    })
  end
}
