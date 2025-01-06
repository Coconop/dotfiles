local add, later = MiniDeps.add, MiniDeps.later

later(function()
    add({
        source = 'nvim-treesitter/nvim-treesitter',
        checkout = 'master',
        hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
    })
    add('nvim-treesitter/nvim-treesitter-textobjects')

    local ensure_installed = {
        'bash',
        'c',
        'cmake',
        'cpp',
        'diff',
        'git_config',
        'git_rebase',
        'gitattributes',
        'gitcommit',
        'gitignore',
        'go',
        'gpg',
        'html',
        'ini',
        'java',
        'javascript',
        'jq',
        'json',
        'linkerscript',
        'lua',
        'make',
        'markdown',
        'markdown_inline',
        'nginx',
        'objdump',
        'passwd',
        'pem',
        'perl',
        'php',
        'powershell',
        'printf',
        'python',
        'regex',
        'robot',
        'rst',
        'rust',
        'sql',
        'tmux',
        'toml',
        'udev',
        'yaml',
        'vim',
        'vimdoc',
        'xml',
    }

    require('nvim-treesitter.configs').setup({
        ensure_installed = ensure_installed,
        highlight = { enable = true },
        incremental_selection = { enable = true },
        textobjects = { enable = true },
        indent = { enable = false }, -- experimental
    })

    -- Disable injections in 'lua' language
    local ts_query = require('vim.treesitter.query')
    local ts_query_set = vim.fn.has('nvim-0.9') == 1 and ts_query.set or ts_query.set_query
    ts_query_set('lua', 'injections', '')
end)
