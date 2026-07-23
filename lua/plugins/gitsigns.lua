-- Adds git related signs to the gutter, as well as utilities for managing changes
return {
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    signs_staged = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    on_attach = function(bufnr)
      local gitsigns = require 'gitsigns'
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end

      -- Hunk navigation for reviewing AI-generated changes.
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal { ']c', bang = true }
        else
          gitsigns.next_hunk()
        end
      end, 'Git: next changed hunk')

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          gitsigns.prev_hunk()
        end
      end, 'Git: previous changed hunk')

      -- Stage/reset hunks while reviewing.
      map('n', '<leader>gs', gitsigns.stage_hunk, '[G]it [S]tage hunk')
      map('n', '<leader>gr', gitsigns.reset_hunk, '[G]it [R]eset hunk')
      map('v', '<leader>gs', function()
        gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, '[G]it [S]tage selected hunk')
      map('v', '<leader>gr', function()
        gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, '[G]it [R]eset selected hunk')

      map('n', '<leader>gS', gitsigns.stage_buffer, '[G]it [S]tage buffer')
      map('n', '<leader>gR', gitsigns.reset_buffer, '[G]it [R]eset buffer')
      map('n', '<leader>gp', gitsigns.preview_hunk, '[G]it [P]review hunk')
      map('n', '<leader>gb', gitsigns.blame_line, '[G]it [B]lame line')
      map('n', '<leader>gt', gitsigns.toggle_current_line_blame, '[G]it [T]oggle line blame')
      map('n', '<leader>gw', gitsigns.toggle_word_diff, '[G]it toggle [W]ord diff')
      map('n', '<leader>gu', gitsigns.undo_stage_hunk, '[G]it [U]ndo stage hunk')
    end,
  },
}
