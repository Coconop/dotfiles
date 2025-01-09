return {
    { 'nvim-tree/nvim-web-devicons', opts = {} },
    {
        'rcarriga/nvim-notify',
        config = function ()
           vim.notify = require("notify")
        end
    }
}
