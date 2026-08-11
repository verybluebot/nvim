return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'nvim-neotest/nvim-nio',
    {
      'rcarriga/nvim-dap-ui',
      dependencies = { 'nvim-neotest/nvim-nio' },
    },
    'theHamsta/nvim-dap-virtual-text',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    dap.adapters.codelldb = {
      type = 'server',
      port = '${port}',
      executable = {
        command = 'codelldb',
        args = { '--port', '${port}' },
      },
    }

    dapui.setup()
    require('nvim-dap-virtual-text').setup()

    local launch_configurations = {
      {
        name = 'Launch executable',
        type = 'codelldb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
      {
        name = 'Attach to process',
        type = 'codelldb',
        request = 'attach',
        pid = function()
          return require('dap.utils').pick_process()
        end,
        cwd = '${workspaceFolder}',
      },
    }

    dap.configurations.c = vim.deepcopy(launch_configurations)
    dap.configurations.cpp = vim.deepcopy(launch_configurations)
    dap.configurations.objc = vim.deepcopy(launch_configurations)
    dap.configurations.objcpp = vim.deepcopy(launch_configurations)

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DiagnosticError' })
    vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DiagnosticWarn' })
    vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DiagnosticInfo', linehl = 'Visual' })

    vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: start/continue' })
    vim.keymap.set('n', '<F10>', dap.step_over, { desc = 'Debug: step over' })
    vim.keymap.set('n', '<F11>', dap.step_into, { desc = 'Debug: step into' })
    vim.keymap.set('n', '<F12>', dap.step_out, { desc = 'Debug: step out' })
    vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = '[D]ebug toggle [B]reakpoint' })
    vim.keymap.set('n', '<leader>dB', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = '[D]ebug conditional [B]reakpoint' })
    vim.keymap.set('n', '<leader>dc', dap.continue, { desc = '[D]ebug [C]ontinue' })
    vim.keymap.set('n', '<leader>dl', dap.run_last, { desc = '[D]ebug run [L]ast' })
    vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = '[D]ebug open [R]EPL' })
    vim.keymap.set('n', '<leader>dt', dap.terminate, { desc = '[D]ebug [T]erminate' })
    vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = '[D]ebug toggle [U]I' })
    vim.keymap.set({ 'n', 'v' }, '<leader>de', dapui.eval, { desc = '[D]ebug [E]valuate expression' })
  end,
}
