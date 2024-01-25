  require("null-ls").setup({
    on_init = function(new_client, _) 
      new_client.offset_encoding = 'utf-32'
    end,
  })
