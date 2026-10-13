return {
    'saghen/blink.cmp',
    build = function() require('blink.cmp').build():wait(60000) end,
    dependencies = {
        'saghen/blink.lib'
    },
    opts = {
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer', },
        }
    }
}
