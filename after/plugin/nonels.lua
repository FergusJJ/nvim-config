local nullls = require("null-ls")

nullls.setup({
  sources = {
    nullls.builtins.formatting.clang_format,
  }
})
