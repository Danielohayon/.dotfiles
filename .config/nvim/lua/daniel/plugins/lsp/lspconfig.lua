return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    "nvim-lua/plenary.nvim"
  },
  config = function()
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- LSP keymaps (set up on LspAttach)
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
      callback = function(ev)
        local opts = { buffer = ev.buf, noremap = true, silent = true }

        vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", vim.tbl_extend("force", opts, { desc = "Show LSP references" }))
        vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", vim.tbl_extend("force", opts, { desc = "Show LSP definitions" }))
        vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", vim.tbl_extend("force", opts, { desc = "Show LSP type definitions" }))
        vim.keymap.set("n", "gi", "<cmd>Telescope lsp_incoming_calls<CR>", vim.tbl_extend("force", opts, { desc = "Incoming Calls" }))
        vim.keymap.set("n", "go", "<cmd>Telescope lsp_outgoing_calls<CR>", vim.tbl_extend("force", opts, { desc = "Outgoing Calls" }))

        vim.keymap.set("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, vim.tbl_extend("force", opts, { desc = "Add workspace folder" }))
        vim.keymap.set("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, vim.tbl_extend("force", opts, { desc = "Remove workspace folder" }))
        vim.keymap.set("n", "<leader>lwl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, vim.tbl_extend("force", opts, { desc = "List workspace folders" }))

        vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "See available code actions" }))
        vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Smart rename" }))
        vim.keymap.set("n", "<leader>lD", "<cmd>Telescope diagnostics bufnr=0<CR>", vim.tbl_extend("force", opts, { desc = "Show buffer diagnostics" }))
        vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Show line diagnostics" }))
        vim.keymap.set("n", "<leader>lp", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Go to previous diagnostic" }))
        vim.keymap.set("n", "<leader>ln", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Go to next diagnostic" }))
        vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Show documentation for what is under cursor" }))
        vim.keymap.set("n", "<leader>lx", ":LspRestart<CR>", vim.tbl_extend("force", opts, { desc = "Restart LSP" }))
        vim.keymap.set("n", "<leader>ls", "<cmd>Telescope spell_suggest<cr>", vim.tbl_extend("force", opts, { desc = "Spell Suggest" }))
      end,
    })

    -- Configure LSP servers using vim.lsp.config (Neovim 0.11+)
    vim.lsp.config("pyright", {
      capabilities = capabilities,
    })

    vim.lsp.config("bashls", {
      capabilities = capabilities,
    })

    vim.lsp.config("dockerls", {
      capabilities = capabilities,
    })

    vim.lsp.config("marksman", {
      capabilities = capabilities,
    })

    vim.lsp.config("vimls", {
      capabilities = capabilities,
    })

    vim.lsp.config("lua_ls", {
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
        },
      },
    })

    -- Enable the configured servers
    vim.lsp.enable({ "pyright", "bashls", "dockerls", "marksman", "vimls", "lua_ls" })
  end,
}
