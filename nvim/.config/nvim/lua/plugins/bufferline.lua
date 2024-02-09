return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    lazy = false,
    opts = {
        options = {
            mode = "buffers",
            truncate_names = true,
            tab_size =2,
            diagnostics = "nvim_lsp",
            offsets = {
                {
                    filetype = "NvimTree",
                    text = "File Explorer",
                    text_align = "center",
                    separator = false
                }
            },
            show_close_icon= false,
            show_buffer_close_icons = false
        },
    }
}
