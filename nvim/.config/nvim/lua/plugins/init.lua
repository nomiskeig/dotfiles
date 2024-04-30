local neodev = require("plugins.lsp.neodev")
local mason = require("plugins.lsp.mason")
require("plugins.lsp.lspconfig")

return {
    neodev, mason, {
    "nvim-tree/nvim-web-devicons", opts = {}
    }
}
