return {
    "neovim/nvim-lspconfig",
    dependencies = {
        {
            "williamboman/mason.nvim",
            version = "v1.31.0"
        },
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "rafamadriz/friendly-snippets",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
        "windwp/nvim-autopairs",     -- Auto-closing pairs engine
        "ray-x/lsp_signature.nvim",  -- Parameter helper
    },

    config = function()
        -- 1. Signature Help (Parameter Hints)
        require("lsp_signature").setup({
            bind = true,
            handler_opts = { border = "rounded" },
            hint_enable = false,
        })

        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        -- 2. Autopairs Settings (Customized)
        local npairs = require("nvim-autopairs")
        local Rule = require('nvim-autopairs.rule') -- NEEDED FOR ADDING RULES MANUALLY

        npairs.setup({})

        -- CRITICAL: Clear all default rules ({, ", ' etc.)
        npairs.clear_rules()

        -- RE-ADD: Only add the parenthesis rule back.
        -- This allows 'confirm_done' to work for functions ()
        -- while keeping { and " manual.
        npairs.add_rule(Rule("(", ")"))

        require("luasnip.loaders.from_vscode").lazy_load()
        require("fidget").setup({})
        require("mason").setup()

        -- 3. Common Settings (for Inlay Hints)
        local on_attach = function(client, bufnr)
            if client.server_capabilities.inlayHintProvider then
                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end
        end

        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls", "rust_analyzer", "pyright", "clangd", "ts_ls",
            },
            handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities,
                        on_attach = on_attach,
                    }
                end,

                ["ts_ls"] = function()
                    require("lspconfig").ts_ls.setup {
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = {
                            completions = {
                                completeFunctionCalls = true
                            },
                            typescript = {
                                inlayHints = {
                                    includeInlayParameterNameHints = "all",
                                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                                    includeInlayFunctionParameterTypeHints = true,
                                    includeInlayVariableTypeHints = true,
                                    includeInlayPropertyDeclarationTypeHints = true,
                                    includeInlayFunctionLikeReturnTypeHints = true,
                                    includeInlayEnumMemberValueHints = true,
                                }
                            },
                            javascript = {
                                inlayHints = {
                                    includeInlayParameterNameHints = "all",
                                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                                    includeInlayFunctionParameterTypeHints = true,
                                    includeInlayVariableTypeHints = true,
                                    includeInlayPropertyDeclarationTypeHints = true,
                                    includeInlayFunctionLikeReturnTypeHints = true,
                                    includeInlayEnumMemberValueHints = true,
                                }
                            }
                        }
                    }
                end,

                ["lua_ls"] = function()
                    require("lspconfig").lua_ls.setup {
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                                },
                                hint = { enable = true },
                            }
                        }
                    }
                end,
            }
        })

        vim.diagnostic.config({
            virtual_text = true,
            signs = true,
            underline = true,
            update_in_insert = true,
            severity_sort = true,
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
            }, {
                { name = 'buffer' },
            })
        })

        -- 4. CMP Integration
        local cmp_autopairs = require('nvim-autopairs.completion.cmp')
        cmp.event:on(
            'confirm_done',
            cmp_autopairs.on_confirm_done()
        )
    end
}
