return function(_colors)
  return {
    -- Base Lua doc comment
    ["@comment.documentation.lua"] = { link = "@comment" },

    -- Luadoc injected language highlights
    ["@keyword.luadoc"] = { link = "@comment" },
    ["@keyword.return.luadoc"] = { link = "@comment" },
    ["@keyword.import.luadoc"] = { link = "@comment" },
    ["@keyword.coroutine.luadoc"] = { link = "@comment" },
    ["@keyword.function.luadoc"] = { link = "@comment" },
    ["@keyword.modifier.luadoc"] = { link = "@comment" },
    ["@variable.luadoc"] = { link = "@comment" },
    ["@variable.parameter.luadoc"] = { link = "@comment" },
    ["@variable.member.luadoc"] = { link = "@comment" },
    ["@variable.builtin.luadoc"] = { link = "@comment" },
    ["@type.luadoc"] = { link = "@comment" },
    ["@type.builtin.luadoc"] = { link = "@comment" },
    ["@module.luadoc"] = { link = "@comment" },
    ["@function.macro.luadoc"] = { link = "@comment" },
    ["@operator.luadoc"] = { link = "@comment" },
    ["@string.luadoc"] = { link = "@comment" },
    ["@string.special.path.luadoc"] = { link = "@comment" },
    ["@number.luadoc"] = { link = "@comment" },
    ["@constant.builtin.luadoc"] = { link = "@comment" },
    ["@punctuation.bracket.luadoc"] = { link = "@comment" },
    ["@punctuation.delimiter.luadoc"] = { link = "@comment" },
    ["@punctuation.special.luadoc"] = { link = "@comment" },
    ["@comment.luadoc"] = { link = "@comment" },
  }
end
