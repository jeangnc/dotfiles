return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "olimorris/neotest-rspec",
      "zidhuss/neotest-minitest",
    },
    opts = {
      adapters = {
        ["neotest-rspec"] = {
          rspec_cmd = function()
            return vim.tbl_flatten({
              "docker-compose",
              "exec",
              "web",
              "bundle",
              "exec",
              "rspec",
            })
          end,
          transform_spec_path = function(path)
            local prefix = require("neotest-rspec").root(path)
            return string.sub(path, string.len(prefix) + 2, -1)
          end,
          results_path = "tmp/rspec.output",
          formatter = "json",
        },
        ["neotest-minitest"] = {
          test_cmd = function()
            return vim.tbl_flatten({
              "docker-compose",
              "exec",
              "web",
              "bundle",
              "exec",
              "rails",
              "test",
            })
          end,
          transform_spec_path = function(path)
            local prefix = require("neotest-minitest").root(path)
            return string.sub(path, string.len(prefix) + 2, -1)
          end,
        },
      },
    },
  },
}
