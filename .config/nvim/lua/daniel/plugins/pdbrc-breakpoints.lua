-- pdbrc-breakpoints: Toggle breakpoints that write to .pdbrc
return {
  dir = vim.fn.stdpath("config"),  -- dummy dir, this is just config
  name = "pdbrc-breakpoints",
  config = function()
    local sign_name = "PdbrcBreakpoint"
    local pdbrc_path = vim.fn.getcwd() .. "/.pdbrc"

    -- Ensure signcolumn is visible
    vim.opt.signcolumn = "yes"

    -- Define the sign with high priority
    vim.fn.sign_define(sign_name, {
      text = "",
      texthl = "DiagnosticError",
      linehl = "",
      numhl = "DiagnosticError",
    })

    -- Parse .pdbrc and return table of {file = {line1, line2, ...}}
    local function parse_pdbrc()
      local breakpoints = {}
      local file = io.open(pdbrc_path, "r")
      if not file then return breakpoints end

      for line in file:lines() do
        local filepath, lnum = line:match("^break%s+(.+):(%d+)")
        if filepath and lnum then
          -- Normalize path
          local normalized = vim.fn.fnamemodify(filepath, ":p")
          breakpoints[normalized] = breakpoints[normalized] or {}
          table.insert(breakpoints[normalized], tonumber(lnum))
        end
      end
      file:close()
      return breakpoints
    end

    -- Write breakpoints table back to .pdbrc
    local function write_pdbrc(breakpoints)
      local file = io.open(pdbrc_path, "w")
      if not file then
        vim.notify("Cannot write to " .. pdbrc_path, vim.log.levels.ERROR)
        return
      end

      for filepath, lines in pairs(breakpoints) do
        local relpath = vim.fn.fnamemodify(filepath, ":.")
        for _, lnum in ipairs(lines) do
          file:write(string.format("break %s:%d\n", relpath, lnum))
        end
      end
      file:close()
    end

    -- Place signs for all breakpoints in current buffer
    local function refresh_signs(bufnr)
      bufnr = bufnr or vim.api.nvim_get_current_buf()
      local filepath = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":p")

      vim.fn.sign_unplace("pdbrc_breakpoints", { buffer = bufnr })

      local breakpoints = parse_pdbrc()
      local file_bps = breakpoints[filepath] or {}
      for _, lnum in ipairs(file_bps) do
        vim.fn.sign_place(0, "pdbrc_breakpoints", sign_name, bufnr, { lnum = lnum, priority = 100 })
      end
    end

    -- Toggle breakpoint on current line
    local function toggle()
      local bufnr = vim.api.nvim_get_current_buf()
      local filepath = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":p")
      local lnum = vim.api.nvim_win_get_cursor(0)[1]

      local breakpoints = parse_pdbrc()
      breakpoints[filepath] = breakpoints[filepath] or {}

      local idx = nil
      for i, l in ipairs(breakpoints[filepath]) do
        if l == lnum then
          idx = i
          break
        end
      end

      if idx then
        -- Remove breakpoint
        table.remove(breakpoints[filepath], idx)
        if #breakpoints[filepath] == 0 then
          breakpoints[filepath] = nil
        end
        vim.fn.sign_unplace("pdbrc_breakpoints", { buffer = bufnr, id = lnum })
        vim.notify("Breakpoint removed: " .. lnum, vim.log.levels.INFO)
      else
        -- Add breakpoint
        table.insert(breakpoints[filepath], lnum)
        vim.fn.sign_place(lnum, "pdbrc_breakpoints", sign_name, bufnr, { lnum = lnum, priority = 100 })
        vim.notify("Breakpoint added: " .. lnum, vim.log.levels.INFO)
      end

      write_pdbrc(breakpoints)
    end

    -- Clear all breakpoints in current file
    local function clear_file()
      local bufnr = vim.api.nvim_get_current_buf()
      local filepath = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":p")

      local breakpoints = parse_pdbrc()
      breakpoints[filepath] = nil
      write_pdbrc(breakpoints)
      refresh_signs(bufnr)
      vim.notify("Cleared all breakpoints in file", vim.log.levels.INFO)
    end

    -- Clear all breakpoints
    local function clear_all()
      local file = io.open(pdbrc_path, "w")
      if file then file:close() end
      refresh_signs()
      vim.notify("Cleared all breakpoints", vim.log.levels.INFO)
    end

    -- List all breakpoints
    local function list()
      local breakpoints = parse_pdbrc()
      local items = {}

      for filepath, lines in pairs(breakpoints) do
        for _, lnum in ipairs(lines) do
          table.insert(items, {
            filename = filepath,
            lnum = lnum,
            text = vim.fn.fnamemodify(filepath, ":.") .. ":" .. lnum,
          })
        end
      end

      if #items == 0 then
        vim.notify("No breakpoints set", vim.log.levels.INFO)
        return
      end

      vim.fn.setqflist(items)
      vim.cmd("copen")
    end

    -- Refresh signs when opening a buffer
    vim.api.nvim_create_autocmd({ "BufReadPost", "BufEnter" }, {
      callback = function(args)
        refresh_signs(args.buf)
      end,
    })

    -- Keymaps
    vim.keymap.set("n", "<leader>pb", toggle, { desc = "Toggle pdbrc breakpoint" })
    vim.keymap.set("n", "<leader>pB", clear_file, { desc = "Clear file breakpoints" })
    vim.keymap.set("n", "<leader>pX", clear_all, { desc = "Clear all breakpoints" })
    vim.keymap.set("n", "<leader>pl", list, { desc = "List all breakpoints" })
  end,
}
