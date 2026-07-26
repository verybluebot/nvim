return {
  '3rd/image.nvim',
  lazy = false,
  cond = function()
    -- image.nvim needs a real terminal UI to query pixel dimensions; skip it for headless checks.
    return #vim.api.nvim_list_uis() > 0
  end,
  opts = {
    -- WezTerm implements Kitty's graphics protocol. Tmux passthrough is already
    -- enabled in ~/.config/tmux/tmux.conf, which is required when running inside tmux.
    backend = 'kitty',
    processor = 'magick_cli',
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = false,
        only_render_image_at_cursor = false,
        floating_windows = false,
        filetypes = { 'markdown', 'vimwiki' },
      },
      asciidoc = { enabled = false },
      neorg = { enabled = false },
      rst = { enabled = false },
      typst = { enabled = false },
      html = { enabled = false },
      css = { enabled = false },
    },
    max_width = nil,
    max_height = nil,
    max_width_window_percentage = 90,
    max_height_window_percentage = 80,
    scale_factor = 1.0,
    kitty_direct_chunk_size = 4096,
    window_overlap_clear_enabled = false,
    editor_only_render_when_focused = false,
    tmux_show_only_in_active_window = true,
    hijack_file_patterns = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp', '*.avif' },
  },
}
