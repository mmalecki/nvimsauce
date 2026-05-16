return {
    'saghen/blink.cmp',
    build = function() require('blink.cmp').build():wait(60000) end,
    dependencies = {
        'Kaiser-Yang/blink-cmp-avante',
        'saghen/blink.lib'
    },
    opts = {
        sources = {
            -- Add 'avante' to the list
            default = { 'avante', 'lsp', 'path', 'buffer', 'omni' },
            providers = {
                avante = {
                    module = 'blink-cmp-avante',
                    name = 'Avante',
                    opts = {}
                }
            },
        }
    }
}
