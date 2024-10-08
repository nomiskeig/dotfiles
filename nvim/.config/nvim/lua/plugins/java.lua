return {
    'nvim-java/nvim-java',
    config = function()
        require('java').setup()
    end,
    dependencies = {
        'nvim-java/lua-async-await',
        'nvim-java/nvim-java-core',
        'nvim-java/nvim-java-test',
        'nvim-java/nvim-java-dap',
        'nvim-java/nvim-java-refactor',
        'MunifTanjim/nui.nvim',
        'neovim/nvim-lspconfig',
        'mfussenegger/nvim-dap',
        {
            'willoamboman/mason.nvim',
            opts = {
                registries = {
                    'github:nvim-java/mason-registry',
                    'github:mason-org/mason-registry'
                }
            }
        }
    }

}
