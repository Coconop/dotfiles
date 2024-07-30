return {
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio"
        },
        config = function()
            -- Attach UI on events
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

            -- Setup debbugers
            dap.adapters.gdb = {
                type = "executable",
                command = "rust-gdb",
                args = { "-i", "dap" }
            }
            dap.configurations.rust = {
                {
                    name = "Launch",
                    type = "gdb",
                    request = "launch",
                    program = function()
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                    end,
                    cwd = "${workspaceFolder}",
                    stopAtBeginningOfMainSubprogram = false,
                },
            }

            -- key mappings
            vim.keymap.set('n', '<leader>dc', function() require('dap').continue() end, { desc = "DAP Continue" })
            vim.keymap.set('n', '<leader>do', function() require('dap').step_over() end, { desc = "DAP Step Over" })
            vim.keymap.set('n', '<leader>dj', function() require('dap').step_into() end, { desc = "DAP Step Info" })
            vim.keymap.set('n', '<leader>dk', function() require('dap').step_out() end, { desc = "DAP Out" })
            vim.keymap.set('n', '<Leader>db', function() require('dap').toggle_breakpoint() end,
                { desc = "DAP Toggle Brkpt" })
            vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end, { desc = "DAP Repl Open" })
            vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function() require('dap.ui.widgets').hover() end,
                { desc = "UI hover" })
            vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function()
                require('dap.ui.widgets').preview()
            end, { desc = "UI preview" })
            vim.keymap.set('n', '<Leader>df', function()
                local widgets = require('dap.ui.widgets')
                widgets.centered_float(widgets.frames)
            end, { desc = "UI Frames" })
            vim.keymap.set('n', '<Leader>ds', function()
                local widgets = require('dap.ui.widgets')
                widgets.centered_float(widgets.scopes)
            end, { desc = "UI Scopes" })
        end
    },
}
