local neodev = require("plugins.lsp.neodev")
local mason = require("plugins.lsp.mason")
require("plugins.lsp.lspconfig")

return {
    neodev, mason, "mfussenegger/nvim-jdtls", {
    "nvim-tree/nvim-web-devicons", opts = {}
    }
}


