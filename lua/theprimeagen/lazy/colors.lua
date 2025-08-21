function ColorMyPencils(color)
    color = color or "gruvbox-material"
    vim.cmd.colorscheme(color)

    -- keep background transparent for main and floating windows
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
    {
        "folke/tokyonight.nvim",
        config = function()
            require("tokyonight").setup({
                -- your configuration comes here
                -- or leave it empty to use the default settings
                style = "storm",        -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
                transparent = true,     -- Enable this to disable setting the background color
                terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
                styles = {
                    -- Style to be applied to different syntax groups
                    -- Value is any valid attr-list value for `:help nvim_set_hl`
                    comments = { italic = false },
                    keywords = { italic = false },
                    -- Background styles. Can be "dark", "transparent" or "normal"
                    sidebars = "dark", -- style for sidebars, see below
                    floats = "dark",   -- style for floating windows
                },
            })
        end,
    },

    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require("rose-pine").setup({
                disable_background = true,
                transparent = true,
            })
            vim.cmd("colorscheme rose-pine")
            ColorMyPencils()
        end
    },

    {
        "ellisonleao/gruvbox.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            contrast = "hard", -- soft, medium, hard
            transparent_mode = false,
        },
    },

    -- NEW: gruvbox-material (by sainnhe)
    {
        "sainnhe/gruvbox-material",
        priority = 1000, -- load early so colorscheme is available
        init = function()
            -- global variables must be set before loading colorscheme
            vim.g.gruvbox_material_background = "medium"   -- 'soft', 'medium', 'hard'
            vim.g.gruvbox_material_foreground = "material" -- 'material', 'mix', 'original'
            vim.g.gruvbox_material_enable_italic = 1
            vim.g.gruvbox_material_transparent_background = 1
            -- Optional: better performance for large files
            vim.g.gruvbox_material_better_performance = 1
        end,
        config = function()
            -- do not set colorscheme here if you don't want to override others
            -- Example usage:
            -- vim.cmd("colorscheme gruvbox-material")
            -- ColorMyPencils()
        end
    },

    -- NEW: everforest (by sainnhe)
    {
        "sainnhe/everforest",
        init = function()
            vim.g.everforest_background = "medium" -- 'soft', 'medium', 'hard'
            vim.g.everforest_enable_italic = 1
            vim.g.everforest_transparent_background = 1
            vim.g.everforest_better_performance = 1
        end,
        config = function()
            -- Example usage:
            -- vim.cmd("colorscheme everforest")
            -- ColorMyPencils()
        end
    },
}
