return {
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio"
        },
        config = function()
            require("dapui").setup()

            -- Attach Ui on Events
            local dap, dapui = require("dap"), require("dapui")
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

            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                -- Automatically spawn the server and retrieve port
                executable = {
                    command = 'codelldb', -- Shall be in path or need absolute
                    args = { "--port", "${port}" }
                }
            }
            dap.configurations.cpp = {
                {
                    name = "Launch file",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                    end,
                    cwd = '${workspaceFolder}',
                    stopOnEntry = false,
                },
            }
            dap.configurations.rust = {
                {
                    name = "Launch file",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                    end,
                    cwd = '${workspaceFolder}',
                    stopOnEntry = false,
                    sourceLanguages = { "rust" },
                },
            }
            dap.configurations.c = dap.configurations.cpp

            -- key mappings
            vim.keymap.set('n', '<leader>dc', function() require('dap').continue() end, { desc = "Continue" })
            vim.keymap.set('n', '<leader>dn', function() require('dap').step_over() end, { desc = "Step Over" })
            vim.keymap.set('n', '<leader>ds', function() require('dap').step_into() end, { desc = "Step Into" })
            vim.keymap.set('n', '<leader>df', function() require('dap').step_out() end, { desc = "Step Out" })
            vim.keymap.set('n', '<Leader>db', function() require('dap').toggle_breakpoint() end, { desc = "Breakpoint" })

            vim.keymap.set('n', '<leader>dt', function() require('dapui').toggle() end, { desc = "UI toggle" })
            vim.keymap.set({ 'n', 'v' }, '<leader>de', function() require('dapui').eval() end, { desc = "Eval" })

            vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })
        end
    },
    {
        'mrcjkb/rustaceanvim',
        version = '^5', -- Recommended
        lazy = false,   -- This plugin is already lazy
    },
}
