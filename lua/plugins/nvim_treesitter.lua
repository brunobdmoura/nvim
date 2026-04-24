return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  lazy = false,
  config = function()
    require("nvim-treesitter").setup()

    local missing_parsers = {}
    for _, lang in ipairs(USER.treesitter.parsers) do
      -- Check if the compiled binaryu exists
      if #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0 then
        table.insert(missing_parsers, lang)
      end
    end

    -- Then, only install missing parsers
    if #missing_parsers > 0 then
      require("nvim-treesitter").install(missing_parsers)
    end

    -- Attach highlighting on file open
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("TreesitterAutoAttach", { clear = true }),
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end
}
