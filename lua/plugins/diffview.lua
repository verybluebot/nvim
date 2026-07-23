return {
  'sindrets/diffview.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  cmd = {
    'DiffviewOpen',
    'DiffviewClose',
    'DiffviewToggleFiles',
    'DiffviewFocusFiles',
    'DiffviewRefresh',
    'DiffviewFileHistory',
  },
  keys = {
    { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = '[G]it [D]iff review' },
    { '<leader>gD', '<cmd>DiffviewOpen --staged<cr>', desc = '[G]it staged [D]iff review' },
    { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = '[G]it file [H]istory' },
    { '<leader>gH', '<cmd>DiffviewFileHistory<cr>', desc = '[G]it repo [H]istory' },
    { '<leader>gf', '<cmd>DiffviewToggleFiles<cr>', desc = '[G]it toggle diffview [F]iles panel' },
    { '<leader>gq', '<cmd>DiffviewClose<cr>', desc = '[G]it diffview close' },
  },
  opts = function()
    local actions = require 'diffview.actions'

    return {
      enhanced_diff_hl = true,
      file_panel = {
        win_config = {
          position = 'left',
          width = 28,
        },
      },
      view = {
        default = {
          -- Top/bottom diff is much easier to read in normal terminal widths than side-by-side.
          layout = 'diff2_vertical',
        },
        merge_tool = {
          layout = 'diff3_mixed',
        },
        file_history = {
          layout = 'diff2_vertical',
        },
      },
      keymaps = {
        view = {
          { 'n', '<leader>gf', actions.toggle_files, { desc = '[G]it toggle diffview [F]iles panel' } },
        },
        file_panel = {
          { 'n', '<leader>gf', actions.toggle_files, { desc = '[G]it toggle diffview [F]iles panel' } },
        },
      },
    }
  end,
}
