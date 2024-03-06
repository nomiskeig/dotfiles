return {
"nvim-neorg/neorg",
    tag = "v7.0.0",
    build = ":Neorg sync-parsers",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("neorg").setup {
        load = {
          ["core.defaults"] = {},
          ["core.concealer"] = {
                    config = {
                        icons = {
                            ordered = {
                                icons = has_anticonceal and { "1.", "A.", "a.", "(1)", "I.", "i." }                or { "1", "A", "a", "(1)", "I", "i" }
                            }


                        }
                    }
                },
          ["core.dirman"] = {
            config = {
              workspaces = {
                wiki = "~/Wiki",
                alang = "~/dev/alang/theory"
              },
              default_workspace = "wiki",
            },
          },
        },
      }
    vim.wo.foldlevel = 99
        vim.wo.conceallevel = 2
    end,
}
