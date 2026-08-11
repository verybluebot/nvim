return {
  'Civitasv/cmake-tools.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'mfussenegger/nvim-dap',
  },
  cmd = {
    'CMakeGenerate',
    'CMakeBuild',
    'CMakeRun',
    'CMakeDebug',
    'CMakeSelectBuildType',
    'CMakeSelectBuildTarget',
    'CMakeSelectLaunchTarget',
    'CMakeStopRunner',
    'CMakeStopExecutor',
  },
  keys = {
    { '<leader>mg', '<cmd>CMakeGenerate<cr>', desc = 'C[M]ake [G]enerate' },
    { '<leader>mb', '<cmd>CMakeBuild<cr>', desc = 'C[M]ake [B]uild' },
    { '<leader>mr', '<cmd>CMakeRun<cr>', desc = 'C[M]ake [R]un' },
    { '<leader>md', '<cmd>CMakeDebug<cr>', desc = 'C[M]ake [D]ebug' },
    { '<leader>mt', '<cmd>CMakeSelectBuildType<cr>', desc = 'C[M]ake select build [T]ype' },
    { '<leader>ms', '<cmd>CMakeSelectBuildTarget<cr>', desc = 'C[M]ake [S]elect build target' },
    { '<leader>ml', '<cmd>CMakeSelectLaunchTarget<cr>', desc = 'C[M]ake select [L]aunch target' },
    { '<leader>mx', '<cmd>CMakeStopRunner<cr><cmd>CMakeStopExecutor<cr>', desc = 'C[M]ake stop running tasks' },
  },
  opts = {
    cmake_command = 'cmake',
    cmake_generate_options = { '-DCMAKE_EXPORT_COMPILE_COMMANDS=1' },
    -- Keep compilation databases in the build directory. Individual projects
    -- can decide later whether to link one or point clangd at that directory.
    cmake_compile_commands_options = {
      action = 'none',
    },
    cmake_executor = {
      name = 'quickfix',
      opts = {
        show = 'always',
        position = 'belowright',
        size = 10,
        auto_close_when_success = false,
      },
    },
    cmake_runner = {
      name = 'terminal',
      opts = {
        name = 'CMake runner',
        prefix_name = '[CMake] ',
        split_direction = 'horizontal',
        split_size = 12,
        single_terminal_per_instance = true,
        single_terminal_per_tab = true,
        keep_terminal_static_location = true,
        auto_resize = true,
        start_insert = false,
      },
    },
    cmake_dap_configuration = {
      name = 'CMake launch target',
      type = 'codelldb',
      request = 'launch',
      stopOnEntry = false,
      runInTerminal = true,
      console = 'integratedTerminal',
    },
  },
}
