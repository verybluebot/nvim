return {
  'nvimtools/none-ls.nvim',
  dependencies = {
    'nvimtools/none-ls-extras.nvim',
    'jayp0521/mason-null-ls.nvim', -- ensure dependencies are installed
  },
  config = function()
    vim.api.nvim_create_user_command('FormatDisable', function(args)
      if args.bang then
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, { bang = true, desc = 'Disable format-on-save globally, or for this buffer with !' })

    vim.api.nvim_create_user_command('FormatEnable', function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, { desc = 'Enable format-on-save' })

    vim.api.nvim_create_user_command('FormatToggle', function(args)
      if args.bang then
        vim.b.disable_autoformat = not vim.b.disable_autoformat
        vim.notify('Buffer format-on-save: ' .. (vim.b.disable_autoformat and 'disabled' or 'enabled'))
      else
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        vim.notify('Global format-on-save: ' .. (vim.g.disable_autoformat and 'disabled' or 'enabled'))
      end
    end, { bang = true, desc = 'Toggle format-on-save globally, or for this buffer with !' })

    vim.keymap.set('n', '<leader>tf', '<cmd>FormatToggle<cr>', { desc = '[T]oggle [F]ormat-on-save' })
    vim.keymap.set('n', '<leader>tF', '<cmd>FormatToggle!<cr>', { desc = '[T]oggle buffer [F]ormat-on-save' })

    local function lint_project()
      local package_json = vim.fs.find('package.json', {
        upward = true,
        path = vim.fn.getcwd(),
      })[1]

      if not package_json then
        vim.notify('Could not find package.json for this project', vim.log.levels.ERROR)
        return
      end

      local root = vim.fs.dirname(package_json)
      local eslint = root .. '/node_modules/.bin/eslint'

      if vim.fn.executable(eslint) ~= 1 then
        vim.notify('Local ESLint binary not found: ' .. eslint, vim.log.levels.ERROR)
        return
      end

      vim.notify('Running ESLint across the project...')
      vim.system({ eslint, '.', '--format', 'json' }, {
        cwd = root,
        text = true,
      }, function(result)
        vim.schedule(function()
          if result.stdout == '' then
            vim.notify(result.stderr ~= '' and result.stderr or 'ESLint returned no output', vim.log.levels.ERROR)
            return
          end

          local ok, report = pcall(vim.json.decode, result.stdout)
          if not ok then
            vim.notify('Could not parse ESLint output: ' .. tostring(report), vim.log.levels.ERROR)
            return
          end

          local items = {}
          for _, file in ipairs(report) do
            for _, message in ipairs(file.messages) do
              table.insert(items, {
                filename = file.filePath,
                lnum = message.line or 1,
                col = message.column or 1,
                text = message.message,
                type = message.severity == 2 and 'E' or 'W',
              })
            end
          end

          vim.fn.setqflist({}, ' ', {
            title = 'ESLint project',
            items = items,
          })
          vim.cmd('copen')
          vim.notify(string.format('ESLint found %d issue%s', #items, #items == 1 and '' or 's'))
        end)
      end)
    end

    vim.api.nvim_create_user_command('LintProject', lint_project, {
      desc = 'Run ESLint across the project and open quickfix',
    })
    vim.keymap.set('n', '<leader>ll', '<cmd>LintProject<cr>', { desc = '[L]int project' })

    local function typecheck_project()
      local package_json = vim.fs.find('package.json', {
        upward = true,
        path = vim.fn.getcwd(),
      })[1]

      if not package_json then
        vim.notify('Could not find package.json for this project', vim.log.levels.ERROR)
        return
      end

      local root = vim.fs.dirname(package_json)
      local tsc = root .. '/node_modules/.bin/tsc'

      if vim.fn.executable(tsc) ~= 1 then
        vim.notify('Local TypeScript compiler not found: ' .. tsc, vim.log.levels.ERROR)
        return
      end

      vim.notify('Running TypeScript type check across the project...')
      vim.system({ tsc, '--noEmit', '--pretty', 'false', '--incremental', 'false' }, {
        cwd = root,
        text = true,
      }, function(result)
        vim.schedule(function()
          local output = result.stdout or ''
          local items = {}

          for line in output:gmatch('[^\r\n]+') do
            local file, line_number, column, severity, message = line:match(
              '^(.-)%((%d+),(%d+)%):%s+(%w+)%s+(.+)$'
            )

            if file then
              table.insert(items, {
                filename = root .. '/' .. file,
                lnum = tonumber(line_number),
                col = tonumber(column),
                text = message,
                type = severity == 'error' and 'E' or 'W',
              })
            end
          end

          if #items == 0 and result.code ~= 0 then
            vim.notify(result.stderr ~= '' and result.stderr or 'Could not parse TypeScript output', vim.log.levels.ERROR)
            return
          end

          vim.fn.setqflist({}, ' ', {
            title = 'TypeScript type check',
            items = items,
          })
          vim.cmd('copen')
          vim.notify(string.format('TypeScript found %d issue%s', #items, #items == 1 and '' or 's'))
        end)
      end)
    end

    vim.api.nvim_create_user_command('TypeCheckProject', typecheck_project, {
      desc = 'Run TypeScript type check across the project and open quickfix',
    })
    vim.keymap.set('n', '<leader>lt', '<cmd>TypeCheckProject<cr>', { desc = '[L]anguage [T]ype check project' })
    vim.keymap.set('n', '<leader>lq', '<cmd>Telescope quickfix<cr>', { desc = '[L]int [Q]uickfix in Telescope' })

    local null_ls = require 'null-ls'
    local formatting = null_ls.builtins.formatting   -- to setup formatters
    local diagnostics = null_ls.builtins.diagnostics -- to setup linters

    -- Formatters & linters for mason to install
    require('mason-null-ls').setup {
      ensure_installed = {
        'prettier',  -- ts/js formatter
        'stylua',    -- lua formatter
        'shfmt',     -- Shell formatter
        'checkmake', -- linter for Makefiles
        'ruff',      -- Python linter and formatter
      },
      automatic_installation = true,
    }

    local sources = {
      diagnostics.checkmake,
      formatting.prettier.with {
        filetypes = { 'html', 'json', 'yaml', 'markdown', 'js', 'javascriptreact', 'ts', 'tsx', 'typescriptreact' },
      },
      formatting.stylua,
      formatting.shfmt.with { args = { '-i', '4' } },
      formatting.terraform_fmt,
      require('none-ls.formatting.ruff').with { extra_args = { '--extend-select', 'I' } },
      require 'none-ls.formatting.ruff_format',
    }

    local function fix_eslint(bufnr)
      local eslint_clients = vim.lsp.get_clients { bufnr = bufnr, name = 'eslint' }
      local client = eslint_clients[1]

      if not client then
        return
      end

      client:request_sync('workspace/executeCommand', {
        command = 'eslint.applyAllFixes',
        arguments = {
          {
            uri = vim.uri_from_bufnr(bufnr),
            version = vim.lsp.util.buf_versions[bufnr],
          },
        },
      }, 1000, bufnr)
    end

    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
    null_ls.setup {
      -- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
      sources = sources,
      -- you can reuse a shared lspconfig on_attach callback here
      on_attach = function(client, bufnr)
        if client.supports_method 'textDocument/formatting' then
          vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = augroup,
            buffer = bufnr,
            callback = function()
              if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
              end

              fix_eslint(bufnr)
              vim.lsp.buf.format {
                async = false,
                filter = function(format_client)
                  return format_client.name == 'null-ls' or format_client.name == 'none-ls'
                end,
              }
            end,
          })
        end
      end,
    }
  end,
}
