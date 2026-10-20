-- Site build filter for the ML103 Quarto website.
-- 1. Converts GitHub alert blockquotes (> [!NOTE]) into Quarto callouts.
-- 2. Points links to code files and folders at the GitHub source,
--    because the site only renders the Markdown notes.

local repo = "https://github.com/MattBixley/ml103_dev"
local branch = "main"

-- Markdown files kept as source only (not rendered as site pages).
local unrendered = {
  ["PLAN.md"] = true, ["README.md"] = true,
  ["extras/AGENTS.md"] = true, ["extras/CLAUDE.md"] = true,
}

local alert_types = {
  NOTE = "note", TIP = "tip", IMPORTANT = "important",
  WARNING = "warning", CAUTION = "caution",
}

local function strip_alert_marker(blocks)
  local first = blocks[1]
  if not first or (first.t ~= "Para" and first.t ~= "Plain") then return nil end
  local marker = first.content[1]
  if not marker or marker.t ~= "Str" then return nil end
  local kind = marker.text:match("^%[!(%u+)%]$")
  if not kind or not alert_types[kind] then return nil end
  local rest = pandoc.List(first.content)
  rest:remove(1)
  while #rest > 0 and (rest[1].t == "SoftBreak" or rest[1].t == "Space" or rest[1].t == "LineBreak") do
    rest:remove(1)
  end
  local body = pandoc.List(blocks)
  if #rest > 0 then
    body[1] = pandoc.Para(rest)
  else
    body:remove(1)
  end
  return alert_types[kind], body
end

function BlockQuote(el)
  local kind, body = strip_alert_marker(el.content)
  if not kind then return nil end
  return quarto.Callout({ type = kind, content = body })
end

local function normalise(path)
  local parts = {}
  for part in path:gmatch("[^/]+") do
    if part == ".." then
      table.remove(parts)
    elseif part ~= "." then
      table.insert(parts, part)
    end
  end
  return table.concat(parts, "/")
end

local function input_dir()
  local input = quarto.doc.input_file
  local root = quarto.project.directory
  local rel = input:sub(#root + 2)
  return rel:match("^(.*)/[^/]*$") or ""
end

function Link(el)
  local target = el.target
  if target:match("^%a[%w+.-]*:") or target:match("^#") then return nil end
  local path, anchor = target:match("^([^#]*)(#?.*)$")
  if path == "" then return nil end
  local dir = input_dir()
  local full = normalise((dir ~= "" and (dir .. "/") or "") .. path)
  if path:match("%.md$") and not unrendered[full] and not full:match("^archive/") then
    el.target = path:gsub("%.md$", ".html") .. anchor
    return el
  end
  local kind = path:match("/$") and "tree" or "blob"
  el.target = string.format("%s/%s/%s/%s%s", repo, kind, branch, full, anchor)
  return el
end

-- Turn the blocks between <!-- tabs --> and <!-- /tabs --> into a
-- Quarto tabset. Each heading inside starts a tab ("#### R", "#### Python").
-- The "language" group keeps the chosen tab in sync across pages.
local function is_marker(block, text)
  return block.t == "RawBlock" and block.format:match("html")
    and block.text:match("^%s*<!%-%-%s*" .. text .. "%s*%-%->%s*$")
end

local function build_tabsets(blocks)
  local out = pandoc.List()
  local i = 1
  while i <= #blocks do
    local block = blocks[i]
    if is_marker(block, "tabs") then
      local inner = pandoc.List()
      i = i + 1
      while i <= #blocks and not is_marker(blocks[i], "/tabs") do
        inner:insert(blocks[i])
        i = i + 1
      end
      out:insert(pandoc.Div(inner, pandoc.Attr("", { "panel-tabset" }, { group = "language" })))
    else
      out:insert(block)
    end
    i = i + 1
  end
  return out
end

-- Use the first level-1 heading as the page title, as GitHub does.
function Pandoc(doc)
  doc.blocks = build_tabsets(doc.blocks)
  if not doc.meta.title then
    for i, block in ipairs(doc.blocks) do
      if block.t == "Header" and block.level == 1 then
        doc.meta.title = pandoc.MetaInlines(block.content)
        doc.meta.pagetitle = pandoc.utils.stringify(block.content)
        doc.blocks:remove(i)
        break
      end
    end
  end
  return doc
end

-- GitHub tables need a pipe inside code escaped as `\|>`. GitHub hides the
-- backslash; Pandoc keeps code literal, so remove it here.
function Code(el)
  if el.text:find("\\|", 1, true) then
    el.text = el.text:gsub("\\|", "|")
    return el
  end
  return nil
end
