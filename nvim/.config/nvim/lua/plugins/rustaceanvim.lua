vim.g.rustaceanvim = {
    server = {
        default_settings = {
            ['rust-analyzer'] = {

                check = {
                    command = "clippy"
                }
            }
        }
    }
}


return {
    'mrcjkb/rustaceanvim',
    version = '^4',
    ft = {'rust'}
}

