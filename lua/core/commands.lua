vim.api.nvim_create_user_command("BufDeleteExt", function(opts)
  ---@type string
  local ext = opts.args
  -- idiomatic way to iterate over an array
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buf)
    if vim.bo[buf].buflisted and name:match("%." .. vim.pesc(ext) .. "$") then
      vim.api.nvim_buf_delete(buf, { force = false })
    end
  end
end, {
  nargs = 1,
  desc = "Delete all listed buffers with the given file extension",
})
