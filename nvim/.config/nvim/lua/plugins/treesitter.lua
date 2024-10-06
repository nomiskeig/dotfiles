return {
    "nvim-treesitter/nvim-treesitter",
    build = function()
        require("nvim-treesitter.install").update({ with_sync = true })()
    end,
    config = function()
        local configs = require("nvim-treesitter.configs")
        configs.setup({
            ensure_installed = "all",
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },
        })
        local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
        parser_config.key = {
            install_info = {
                url = "~/.dotfiles/nvim/.config/nvim/treesitter/tree-sitter-key",
                files = {"src/parser.c"}


            },
            filetype = "key",
        }
    end
}
