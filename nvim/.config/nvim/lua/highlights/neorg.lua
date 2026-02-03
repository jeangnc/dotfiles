return function(colors)
  return {
    -- Neorg emphasis: lavender family for bold/italic/underline
    ["@neorg.markup.bold"] = { fg = colors.lavender, bold = true },
    ["@neorg.markup.italic"] = { fg = colors.lavender, italic = true },
    ["@neorg.markup.underline"] = { fg = colors.lavender, underline = true },

    -- Neorg code/math: green for inline code, blue for math
    ["@neorg.markup.verbatim"] = { fg = colors.green },
    ["@neorg.markup.inline_math"] = { fg = colors.blue },

    -- Neorg de-emphasis: dimmed/muted for strikethrough and comments
    ["@neorg.markup.strikethrough"] = { fg = colors.overlay1, strikethrough = true },
    ["@neorg.markup.inline_comment"] = { fg = colors.overlay0, italic = true },

    -- Neorg spoiler: hidden text (foreground matches background)
    ["@neorg.markup.spoiler"] = { fg = colors.surface2, bg = colors.surface2 },

    -- Neorg super/subscript
    ["@neorg.markup.superscript"] = { fg = colors.peach },
    ["@neorg.markup.subscript"] = { fg = colors.peach },

    -- Neorg variable references
    ["@neorg.markup.variable"] = { fg = colors.yellow },

    -- Dim the markup delimiters so content stands out
    ["@neorg.markup.bold.delimiter"] = { fg = colors.surface2 },
    ["@neorg.markup.italic.delimiter"] = { fg = colors.surface2 },
    ["@neorg.markup.underline.delimiter"] = { fg = colors.surface2 },
    ["@neorg.markup.strikethrough.delimiter"] = { fg = colors.surface2 },
    ["@neorg.markup.verbatim.delimiter"] = { fg = colors.surface2 },
    ["@neorg.markup.spoiler.delimiter"] = { fg = colors.surface2 },
    ["@neorg.markup.superscript.delimiter"] = { fg = colors.surface2 },
    ["@neorg.markup.subscript.delimiter"] = { fg = colors.surface2 },
    ["@neorg.markup.inline_math.delimiter"] = { fg = colors.surface2 },
    ["@neorg.markup.inline_comment.delimiter"] = { fg = colors.surface2 },
    ["@neorg.markup.variable.delimiter"] = { fg = colors.surface2 },

    -- Neorg headings: soft pastel cascade through Catppuccin accent colors
    ["@neorg.headings.1.prefix"] = { fg = colors.mauve, bold = true },
    ["@neorg.headings.1.title"] = { fg = colors.mauve, bold = true },
    ["@neorg.headings.2.prefix"] = { fg = colors.pink, bold = true },
    ["@neorg.headings.2.title"] = { fg = colors.pink, bold = true },
    ["@neorg.headings.3.prefix"] = { fg = colors.sapphire, bold = true },
    ["@neorg.headings.3.title"] = { fg = colors.sapphire, bold = true },
    ["@neorg.headings.4.prefix"] = { fg = colors.teal, bold = true },
    ["@neorg.headings.4.title"] = { fg = colors.teal, bold = true },
    ["@neorg.headings.5.prefix"] = { fg = colors.flamingo, bold = true },
    ["@neorg.headings.5.title"] = { fg = colors.flamingo, bold = true },
    ["@neorg.headings.6.prefix"] = { fg = colors.lavender, bold = true },
    ["@neorg.headings.6.title"] = { fg = colors.lavender, bold = true },

    -- Neorg quotes: same pastel cascade but dimmer (no bold)
    ["@neorg.quotes.1.prefix"] = { fg = colors.mauve },
    ["@neorg.quotes.1.content"] = { fg = colors.subtext0 },
    ["@neorg.quotes.2.prefix"] = { fg = colors.pink },
    ["@neorg.quotes.2.content"] = { fg = colors.subtext0 },
    ["@neorg.quotes.3.prefix"] = { fg = colors.sapphire },
    ["@neorg.quotes.3.content"] = { fg = colors.subtext0 },
    ["@neorg.quotes.4.prefix"] = { fg = colors.teal },
    ["@neorg.quotes.4.content"] = { fg = colors.subtext0 },
    ["@neorg.quotes.5.prefix"] = { fg = colors.flamingo },
    ["@neorg.quotes.5.content"] = { fg = colors.subtext0 },
    ["@neorg.quotes.6.prefix"] = { fg = colors.lavender },
    ["@neorg.quotes.6.content"] = { fg = colors.subtext0 },

    -- Neorg lists
    ["@neorg.lists.unordered.prefix"] = { fg = colors.mauve, bold = true },
    ["@neorg.lists.ordered.prefix"] = { fg = colors.mauve, bold = true },

    -- Neorg todo items
    ["@neorg.todo_items.undone"] = { fg = colors.overlay1 },
    ["@neorg.todo_items.done"] = { fg = colors.green, bold = true },
    ["@neorg.todo_items.pending"] = { fg = colors.yellow },
    ["@neorg.todo_items.on_hold"] = { fg = colors.overlay1, italic = true },
    ["@neorg.todo_items.cancelled"] = { fg = colors.red, strikethrough = true },
    ["@neorg.todo_items.uncertain"] = { fg = colors.peach },
    ["@neorg.todo_items.urgent"] = { fg = colors.red, bold = true },
    ["@neorg.todo_items.recurring"] = { fg = colors.blue },

    -- Neorg links
    ["@neorg.links.location.url"] = { fg = colors.rosewater, underline = true },
    ["@neorg.links.location.generic"] = { fg = colors.sapphire, underline = true },
    ["@neorg.links.location.generic.prefix"] = { fg = colors.surface2 },
    ["@neorg.links.location.external_file"] = { fg = colors.sapphire, underline = true },
    ["@neorg.links.location.external_file.prefix"] = { fg = colors.surface2 },
    ["@neorg.links.file"] = { fg = colors.sapphire, underline = true },
    ["@neorg.links.file.delimiter"] = { fg = colors.surface2 },
    ["@neorg.links.location.delimiter"] = { fg = colors.surface2 },
    ["@neorg.links.description"] = { fg = colors.sapphire, italic = true },
    ["@neorg.links.description.delimiter"] = { fg = colors.surface2 },

    -- Neorg definitions and footnotes
    ["@neorg.definitions.prefix"] = { fg = colors.flamingo, bold = true },
    ["@neorg.definitions.title"] = { fg = colors.flamingo, bold = true },
    ["@neorg.definitions.content"] = { fg = colors.text },
    ["@neorg.footnotes.prefix"] = { fg = colors.flamingo },
    ["@neorg.footnotes.title"] = { fg = colors.flamingo, italic = true },
    ["@neorg.footnotes.content"] = { fg = colors.subtext0 },

    -- Neorg anchors
    ["@neorg.anchors.declaration.delimiter"] = { fg = colors.surface2 },
    ["@neorg.anchors.declaration"] = { fg = colors.sapphire, underline = true },
    ["@neorg.anchors.definition.delimiter"] = { fg = colors.surface2 },

    -- Neorg tags (code blocks, metadata, etc.)
    ["@neorg.tags.ranged_verbatim.begin"] = { fg = colors.surface2 },
    ["@neorg.tags.ranged_verbatim.end"] = { fg = colors.surface2 },
    ["@neorg.tags.ranged_verbatim.name.word"] = { fg = colors.blue },
    ["@neorg.tags.ranged_verbatim.name.delimiter"] = { fg = colors.surface2 },
    ["@neorg.tags.ranged_verbatim.parameters.word"] = { fg = colors.yellow },
    ["@neorg.tags.comment.content"] = { fg = colors.overlay0, italic = true },
    ["@neorg.tags.carryover.begin"] = { fg = colors.surface2 },
    ["@neorg.tags.carryover.name.word"] = { fg = colors.blue },
    ["@neorg.tags.carryover.name.delimiter"] = { fg = colors.surface2 },
    ["@neorg.tags.carryover.parameters.word"] = { fg = colors.yellow },

    -- Neorg document metadata
    ["@neorg.tags.ranged_verbatim.document_meta.key"] = { fg = colors.blue },
    ["@neorg.tags.ranged_verbatim.document_meta.string"] = { fg = colors.green },
    ["@neorg.tags.ranged_verbatim.document_meta.number"] = { fg = colors.peach },
    ["@neorg.tags.ranged_verbatim.document_meta.object.bracket"] = { fg = colors.overlay1 },
    ["@neorg.tags.ranged_verbatim.document_meta.array.bracket"] = { fg = colors.overlay1 },
    ["@neorg.tags.ranged_verbatim.document_meta.title"] = { fg = colors.mauve, bold = true },
    ["@neorg.tags.ranged_verbatim.document_meta.description"] = { fg = colors.text, italic = true },
    ["@neorg.tags.ranged_verbatim.document_meta.authors"] = { fg = colors.flamingo },
    ["@neorg.tags.ranged_verbatim.document_meta.categories"] = { fg = colors.mauve },
    ["@neorg.tags.ranged_verbatim.document_meta.created"] = { fg = colors.teal },
    ["@neorg.tags.ranged_verbatim.document_meta.updated"] = { fg = colors.teal },
    ["@neorg.tags.ranged_verbatim.document_meta.version"] = { fg = colors.peach },

    -- Neorg delimiters (horizontal rules, etc.)
    ["@neorg.delimiters.strong"] = { fg = colors.surface1 },
    ["@neorg.delimiters.weak"] = { fg = colors.surface1 },
    ["@neorg.delimiters.horizontal_line"] = { fg = colors.surface1 },

    -- Neorg modifiers
    ["@neorg.modifiers.escape"] = { fg = colors.overlay0 },

    -- Neorg errors
    ["@neorg.error"] = { fg = colors.red, undercurl = true },
  }
end
