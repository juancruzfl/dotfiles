local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
  spec = {
        {
          'sainnhe/everforest',
          lazy = false,
          priority = 1000,
          config = function()
            vim.o.background = "dark"
            vim.g.everforest_background = "hard"
            vim.g.everforest_ui_contrast = "high"
            vim.g.everforest_enable_italic = 1
            vim.g.everforest_transparent_background = 1
            vim.g.everforest_diagnostic_virtual_text = 'grey'
            vim.cmd.colorscheme('everforest')
          end
        },

        {
            'nvim-lualine/lualine.nvim',
            dependencies = { 'nvim-tree/nvim-web-devicons' },
            config = function()
                require("lualine").setup {
                    options = {
                        theme = "everforest"
                    }
                }
                end
        },

       {
            "karb94/neoscroll.nvim",
              config = function()
                local neoscroll = require('neoscroll')
                neoscroll.setup({
                    hide_cursor = true,
                    stop_eof = true,
                    respect_scrolloff = false,
                    easing_function = "quadratic",
                    duration_multiplier = 1.0,
                    cursor_scroll_alone = true,
                    easing = "quadratic",
                })
                local keymap = {
                  ["<C-k>"] = function() neoscroll.ctrl_u({ duration = 150 }) end,
                  ["<C-j>"] = function() neoscroll.ctrl_d({ duration = 150 }) end,
                  ["<C-b>"] = function() neoscroll.ctrl_b({ duration = 450 }) end,
                  ["<C-f>"] = function() neoscroll.ctrl_f({ duration = 450 }) end,
                  ["zt"] = function() neoscroll.zt({ half_win_duration = 150 }) end,
                  ["zz"] = function() neoscroll.zz({ half_win_duration = 150 }) end,
                  ["zb"] = function() neoscroll.zb({ half_win_duration = 150 }) end,
                }
                local modes = { 'n', 'v', 'x' }
                for key, func in pairs(keymap) do
                  vim.keymap.set(modes, key, func)
                end
              end
        },
        {
            "nvim-lua/plenary.nvim",
        },


        {
            "nvim-telescope/telescope.nvim",
            tag = '0.1.4',
        },

        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make'
        },

        {
            "nvim-treesitter/nvim-treesitter",
            branch = "master",
            lazy = false,
            build = ":TSUpdate",
            config = function()
                require("nvim-treesitter.configs").setup({
                    highlight = {
                        enable = true,
                    },
                    indent = {
                        enable = true,
                    },
                    ensure_installed = {
                        "lua",
                        "vim",
                        "python",
                        "query",
                        "javascript",
                        "c",
                        "vimdoc",
                        "make",
                        "css",
                        "dockerfile",
                        "go",
                        "html",
                        "json",
                    },
                    
                    auto_install = true,

                    incremental_selection = {
                        enable = true,
                            keymaps = {
                                init_selection = "<Leader>ss", 
                                node_incremental = "<Leader>si",
                                scope_incremental = "<Leader>sc",
                                node_decremental = "<Leader>sd",
                            },
                    },

                })
            end,
        },

        {
            "nvim-treesitter/nvim-treesitter-textobjects",
            config = function()
                    require'nvim-treesitter.configs'.setup {
                      textobjects = {
                        select = {
                            enable = true,
                            lookahead = true,

                            keymaps = { 
                                ["af"] = "@function.outer",
                                ["if"] = "@function.inner",
                                ["ac"] = "@class.outer",        
                                ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                                ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
                            },
                            selection_modes = {
                                ['@parameter.outer'] = 'v', 
                                ['@function.outer'] = 'V', 
                                ['@class.outer'] = '<c-v>', 
                            }, 
                          include_surrounding_whitespace = true,
                        },
                      },
                    }
                end,
        },  
        
        {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },

        {
            "neovim/nvim-lspconfig",
            config = function()
                vim.lsp.config("codebook", {
                    filetypes = {
                        "markdown",
                        "text",
                        "gitcommit",
                    },
                })
                end
        },

        {
            "mason-org/mason.nvim",
            config = function()
                require("mason").setup()
            end
        },
 
        {
            "mason-org/mason-lspconfig.nvim",
            dependencies = {"mason.nvim"},
            config = function() 
                require("mason-lspconfig").setup({
                    handlers = {
                        function(server_name)
                            require("lspconfig")[server_name].setup({})
                        end,    
                    },
                })
            end,
        },

        {
            "saghen/blink.cmp",
            dependencies = { "rafamadriz/friendly-snippets" },
            version = "1.*",
            opts = {
                keymap = { preset = "super-tab" },
                appearance = {
                    nerd_font_variant = "mono"
                },

                completion = { documentation = { auto_show = true } },

                sources = {
                    default = {"lsp", "path", "snippets", "buffer"},
                    providers = {
                        lazdev = {
                            name = "LazyDev",
                            module = "lazydev.integrations.blink",
                            score_offset = 100,
                        },
                    },
                },

                fuzzy = { implementation = "prefer_rust_with_warning" }
            },
            opts_extend = { "sources.default" }
        },
        {
          {
            "folke/lazydev.nvim",
            ft = "lua", 
            opts = {
              library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
              },
            },
          },
        },

        {
            "nvim-neo-tree/neo-tree.nvim",
            lazy = false,
            branch = "v3.x",
            dependencies = {
                "nvim-tree/nvim-web-devicons",
                "MunifTanjim/nui.nvim",
                "nvim-lua/plenary.nvim",
            },
           config = function()
                require("neo-tree").setup({
                    filesystem = {
                        filtered_items = {
                            visible = true,
                            hide_dotfiles = false,
                        }
                    }
                })
            end,
        },

        {
            "stevearc/oil.nvim",
            config = function()
                require("oil").setup({

                default_file_explorer = false,
                columns = {
                    "icons",
                    "permissions",
                    "size",
                    "mtime",
                },

                buff_options = {
                    buflisted = false,
                    bufhidden = "hide",
                },

                win_options = {
                    wrap = false,
                    signcolumn = "no",
                    cursorcolumn = "false",
                    foldcolumn = "0",
                    spell = false,
                    list = false,
                    conceallevel = 3,
                    concealcursor = "nvic",
                },

                delete_to_trash = false,
                skip_confirm_for_simple_edits = false,
                prompt_save_on_select_new_entry = true,
                cleanup_delay_ms = 2000,

                lsp_file_methods = {
                    enabled = true,
                    timeout_ms = 1000,
                    autosave_changes = false,
                },

                watch_for_changes = true,

                ssh = {
                   border = "rounded",
                },

                })
            end,

        },

        {
            "brianhuster/live-preview.nvim",
            dependencies = {
                "nvim-telescope/telescope.nvim",
            config = function()
                    require("livepreview.config").set()
                end,
            },
        },

        {
            "ThePrimeagen/harpoon",
            branch = "harpoon2",
            dependencies= { "nvim-lua/plenary.nvim" }
        },

        {
              "folke/flash.nvim",
              event = "VeryLazy",
              opts = {},
              keys = {
                { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
                { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
                { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
                { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
                { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
              },
        },

        {
            "kdheepak/lazygit.nvim",
            lazy = true,
            cmd = {
                "LazyGit",
                "LazyGitConfig",
                "LazyGitCurrentFile",
                "LazyGitFilter",
                "LazyGitFilterCurrentFile",
            },
            dependencies = {
                "nvim-lua/plenary.nvim",
            },
            keys = {
                { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
            }
        },

        {
            "supermaven-inc/supermaven-nvim",
            config = function()
               require("supermaven-nvim").setup({
                    keymaps = {
                        accept_word = "<C-y>",
                    }
                })
            end,
        },
        {
            "sphamba/smear-cursor.nvim",
              opts = {
                smear_between_buffers = true,
                smear_between_neighbor_lines = true,
                scroll_buffer_space = true,
                legacy_computing_symbols_support = false,
                smear_insert_mode = true,
                stiffness = 0.8,
                trailing_stiffness = 0.6,
                stiffness_insert_mode = 0.7,
                trailing_stiffness_insert_mode = 0.7,
                damping = 0.95,
                daming_insert_mode = 0.95,
                distance_stop_animating = 0.5,
            },
        }

    },
  checker = { enabled = true },

})
