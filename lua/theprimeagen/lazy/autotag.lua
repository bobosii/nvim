return {
    "windwp/nvim-ts-autotag",
    config = function()
        require('nvim-ts-autotag').setup({
            opts = {
                -- Default settings should be enough
                enable_close = true, -- Auto close
                enable_rename = true, -- if you change any <> it should be change the other side of <>
                enable_close_on_slash = false
            }
        })
    end
}
