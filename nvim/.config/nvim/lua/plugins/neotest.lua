return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-neotest/nvim-nio"
    },
    config = function()
        require('neotest').setup{
            adapters = {
                require('rustaceanvim.neotest')
            }
        }
    end
}
