return {
    "folke/lazydev.nvim",

    config = function()
        local lazydev = require("lazydev")
        lazydev.setup()
    end
}
