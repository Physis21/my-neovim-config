-- Adds git related signs to the gutter, as well as utilities for managing changes
return {
  "lewis6991/gitsigns.nvim",
  opts = {
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
    signs_staged = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
    on_attach = function(bufnr)
      local gitsigns = require("gitsigns")

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map("n", "]c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gitsigns.nav_hunk("next")
        end
      end, { desc = "Go to previous git change" })

      map("n", "[c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gitsigns.nav_hunk("prev")
        end
      end, { desc = "Go to next git change" })

      -- Actions
      map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage hunk" })
      map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk" })

      map("v", "<leader>hs", function()
        gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Stage visually selected line" })

      map("v", "<leader>hr", function()
        gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Reset visually selected line" })

      map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage all hunks in current buffer" })
      map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset all hunks in current buffer" })
      map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk at cursor pos" })

      map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Preview hunk at cursor pos inline" })

      map("n", "<leader>hb", function()
        gitsigns.blame_line({ full = true })
      end, { desc = "Blame line" })

      map("n", "<leader>hd", gitsigns.diffthis, { desc = "Perform vimdiff on current file" })

      map("n", "<leader>hD", function()
        gitsigns.diffthis("~")
      end)

      map("n", "<leader>hQ", function()
        gitsigns.setqflist("all")
      end)
      map("n", "<leader>hq", gitsigns.setqflist, { desc = "Populate quickfix list with hunks" })

      -- Toggles
      map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle blaming current line" })
      map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "Toggle diffing current word" })

      -- Text object
      map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "Select hunk under cursor" })
    end,
  },
}
