return {

    before_init = function(init_params, config)
        -- See https://github.com/rust-lang/rust-analyzer/blob/eb5da56d839ae0a9e9f50774fa3eb78eb0964550/docs/dev/lsp-extensions.md?plain=1#L26
        if config.settings and config.settings['rust-analyzer'] then
            init_params.initializationOptions = config.settings['rust-analyzer']
        end
    end,

    capabilities : {
        experimental = {
            serverStatusNotification = true
        }
    },

    cmd : { "rust-analyzer" },

    filetypes : { "rust" },

        settings = {
            ["rust-analyzer"] = {
                chechOnSave = {
                    command = "clippy",
                },
            },
        },

    on_attach = function()
        vim.api.nvim_buf_create_user_command(0, 'LspCargoReload', function()
            reload_workspace(0)
        end, { desc = 'Reload current cargo workspace' })
    end,

    root_dir = function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        local reused_dir = is_library(fname)
        if reused_dir then
            on_dir(reused_dir)
            return
        end
        local cargo_crate_dir = vim.fs.root(fname, { 'Cargo.toml' })
        local cargo_workspace_root

        if cargo_crate_dir == nil then
            on_dir(
                vim.fs.root(fname, { 'rust-project.json' })
                or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
            )
            return
        end

        local cmd = {
            'cargo',
            'metadata',
            '--no-deps',
            '--format-version',
            '1',
            '--manifest-path',
            cargo_crate_dir .. '/Cargo.toml',
        }

        vim.system(cmd, { text = true }, function(output)
            if output.code == 0 then
                if output.stdout then
                    local result = vim.json.decode(output.stdout)
                    if result['workspace_root'] then
                        cargo_workspace_root = vim.fs.normalize(result['workspace_root'])
                    end
                end

                on_dir(cargo_workspace_root or cargo_crate_dir)
            else
                vim.schedule(function()
                    vim.notify(('[rust_analyzer] cmd failed with code %d: %s\n%s'):format(output.code, cmd, output.stderr))
                end)
            end
        end)
    end,
}
