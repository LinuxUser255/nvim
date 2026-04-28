-- debugging.lua
-- Check which TreeSitter parsers have broken queries

local function check_treesitter_queries()
  -- Get all languages from the language table (works in 0.12)
  local languages = {}
  for lang, _ in pairs(vim.treesitter.language) do
    table.insert(languages, lang)
  end

  if #languages == 0 then
    print("No TreeSitter languages found.")
    return
  end

  local broken_count = 0

  for _, lang in ipairs(languages) do
    local ok, err = pcall(function()
      vim.treesitter.query.get(lang, "highlights")
    end)

    if not ok then
      print("BROKEN: " .. lang .. " → " .. tostring(err))
      broken_count = broken_count + 1
    end
  end

  if broken_count == 0 then
    print("All TreeSitter queries loaded successfully!")
  else
    print("Total broken parsers: " .. broken_count)
  end
end

-- Run it
check_treesitter_queries()
