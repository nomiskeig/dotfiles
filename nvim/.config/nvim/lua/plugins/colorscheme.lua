return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        opts = { style = "moon" },
        config = function()
            --    vim.cmd([[colorscheme tokyonight]])
        end,
    },
    {
        "navarasu/onedark.nvim",
        config = function()
            require("onedark").setup {
                style = "darker",
                highlights = {
                    ["@comment"] = { fg = '$green' }
                }

            }

            require('onedark').load()
        end,
    },

}
