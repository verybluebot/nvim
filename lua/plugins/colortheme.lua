return {
  'folke/tokyonight.nvim',
  priority = 1000,
  config = function()
    local transparent = false -- set to true if you would like to enable transparency

    -- local bg = '#011628'
    -- local bg_dark = '#011423'
    -- local bg_highlight = '#143652'
    -- local bg_search = '#0A64AC'
    -- local bg_visual = '#275378'
    -- local fg = '#CBE0F0'
    -- local fg_dark = '#B4D0E9'
    -- local fg_gutter = '#627E97'
    -- local border = '#547998'

    require('tokyonight').setup {
      style = 'night',
      transparent = transparent,
      styles = {
        sidebars = transparent and 'transparent' or 'dark',
        floats = transparent and 'transparent' or 'dark',
      },
      -- on_colors = function(colors)
      --   colors.bg = bg
      --   colors.bg_dark = transparent and colors.none or bg_dark
      --   colors.bg_float = transparent and colors.none or bg_dark
      --   colors.bg_highlight = bg_highlight
      --   colors.bg_popup = bg_dark
      --   colors.bg_search = bg_search
      --   colors.bg_sidebar = transparent and colors.none or bg_dark
      --   colors.bg_statusline = transparent and colors.none or bg_dark
      --   colors.bg_visual = bg_visual
      --   colors.border = border
      --   colors.fg = fg
      --   colors.fg_dark = fg_dark
      --   colors.fg_float = fg
      --   colors.fg_gutter = fg_gutter
      --   colors.fg_sidebar = fg_dark
      -- end,
      on_highlights = function(highlights, colors)
        -- Make vimdiff/Diffview changed regions easier to see.
        -- DiffAdd/Change are the line backgrounds; DiffText is the inline changed text.
        highlights.DiffAdd = { bg = '#16351f' }
        highlights.DiffChange = { bg = '#142f1c' }
        highlights.DiffText = { bg = '#2f7d3f', fg = colors.fg, bold = true }
      end,
    }

    vim.cmd 'colorscheme tokyonight'
  end,
}
