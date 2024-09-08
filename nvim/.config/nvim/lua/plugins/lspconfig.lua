return {
    "neovim/nvim-lspconfig",
    config = function()
        local lspconfig = require("lspconfig")
        lspconfig.jdtls.setup({})
        lspconfig.lua_ls.setup {}
        lspconfig.texlab.setup {}
        lspconfig.clangd.setup {}
        lspconfig.mesonlsp.setup{}
        --[[lspconfig.rust_analyzer.setup {
            settings = {
                ['rust-analyzer'] = {
                    diagnostics = {
                        enable = true
                    },
                    check = {
                        command = "clippy"
                    }
                }

            }
        }
        ]]--

    end



}
