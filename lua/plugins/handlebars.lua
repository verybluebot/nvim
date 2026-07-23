return {
  'mustache/vim-mustache-handlebars',
  ft = { 'handlebars', 'hbs' }, -- Optional: set file types
  -- Configure optional abbreviations if desired
  config = function()
    vim.g.mustache_abbreviations = 1
  end,
}
