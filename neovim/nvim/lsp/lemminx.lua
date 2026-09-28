-- Look for custom config file on which virtual env to use
local function find_lemminx_cfg()
  local dir = vim.fn.expand("%:p:h")
  local home = vim.fn.expand("~")

  while true do
    local cfg_path = dir .. "/.lemminx.lua"
    if vim.fn.filereadable(cfg_path) == 1 then
      vim.notify("XML: " .. cfg_path, vim.log.levels.TRACE)
      return dofile(cfg_path) -- found: execute and return the config table
    end
    if dir == home then break end -- Do not walk up past HOME
    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir then break end  -- Do not walk up past ROOT
    dir = parent
  end

  return nil -- no config found :(
end

local cfg = find_lemminx_cfg() or {
    settings = {
        xml = {
            validation = {
                enabled = true,
                noGrammar = 'hint', -- no XSD/DTD referenced
                namespaces = {enabled = 'always'},
                schema = {enabled = 'always'}
            },
            --catalogs = { vim.fn.expand('~/schemas/catalog.xml') },
            downloadExternalResources = { enabled = false }, -- offline
        },
    }
}

return {
    cmd = {"lemminx"},
    filetypes = {"xml", "xsd", "xslt", "svg",},
    root_markers = {".git"},
    settings = cfg.settings,
}
