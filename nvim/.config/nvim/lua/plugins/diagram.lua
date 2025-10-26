return {
  "3rd/diagram.nvim",
  dependencies = {
    "3rd/image.nvim",
  },
  ft = { "markdown" },
  config = function()
    require("diagram").setup({
      integrations = {
        require("diagram.integrations.markdown"),
      },
      renderer_options = {
        mermaid = {},
      },
    })
  end,
}
