-- =============================================================
-- gruber-darker lualine theme
-- Mirrors gruber-darker-theme.el palette exactly
-- Place at: lua/lualine/themes/gruber-darker.lua
-- Usage:    require('lualine').setup { options = { theme = 'gruber-darker' } }
--
-- NOTE: unlike the main colorscheme palette, entries here are
-- intentionally split — fg-only or bg-only — to match the
-- table shape lualine expects for each section spec.
-- =============================================================

local p = {
  fg       = { fg = "#e4e4ef", ctermfg = 253 },
  fg1      = { fg = "#f4f4ff", ctermfg = 255 },
  white    = { fg = "#ffffff", ctermfg = 231 },
  bg       = { bg = "#181818", ctermbg = 234 },
  bg1      = { bg = "#282828", ctermbg = 235 },
  bg2      = { bg = "#453d41", ctermbg = 238 },
  bg3      = { bg = "#484848", ctermbg = 239 },
  bg4      = { bg = "#52494e", ctermbg = 240 },
  yellow   = { bg = "#ffdd33", ctermbg = 220 },
  green    = { bg = "#73c936", ctermbg = 76  },
  niagara  = { bg = "#96a6c8", ctermbg = 147 },
  quartz   = { fg = "#95a99f", ctermfg = 108 },
  wisteria = { bg = "#9e95c7", ctermbg = 98  },
  brown    = { bg = "#cc8c3c", ctermbg = 172 },
  red      = { bg = "#f43841", ctermbg = 196 },
  red1     = { bg = "#ff4f58", ctermbg = 203 },
}

-- Merge fg + bg tables into one lualine section spec.
-- opts is optional — pass bold = true for mode badges.
local function hi(fg, bg, opts)
  local t = {
    fg      = fg.fg,
    bg      = bg.bg,
    ctermfg = fg.ctermfg,
    ctermbg = bg.ctermbg,
  }
  if opts then
    for k, v in pairs(opts) do t[k] = v end
  end
  return t
end

local bold = { gui = "bold", cterm = "bold" }

-- =============================================================
-- Section roles:
--   a  — mode / leftmost badge     (most prominent)
--   b  — branch / filename         (mid prominence)
--   c  — right side info           (subtle)
-- =============================================================

return {

  -- NORMAL  — yellow badge
  normal = {
    a = hi(p.bg,     p.yellow,   bold),
    b = hi(p.quartz, p.bg2),
    c = hi(p.fg,     p.bg1),
  },

  -- INSERT  — green badge
  insert = {
    a = hi(p.bg,     p.green,    bold),
    b = hi(p.quartz, p.bg2),
    c = hi(p.fg,     p.bg1),
  },

  -- VISUAL  — niagara badge
  visual = {
    a = hi(p.bg,     p.niagara,  bold),
    b = hi(p.quartz, p.bg2),
    c = hi(p.fg,     p.bg1),
  },

  -- REPLACE — red badge
  replace = {
    a = hi(p.white,  p.red,      bold),
    b = hi(p.quartz, p.bg2),
    c = hi(p.fg,     p.bg1),
  },

  -- COMMAND — brown/gold badge
  command = {
    a = hi(p.bg,     p.brown,    bold),
    b = hi(p.quartz, p.bg2),
    c = hi(p.fg,     p.bg1),
  },

  -- TERMINAL — wisteria badge
  terminal = {
    a = hi(p.bg,     p.wisteria, bold),
    b = hi(p.quartz, p.bg2),
    c = hi(p.fg,     p.bg1),
  },

  -- INACTIVE — muted, no bold
  inactive = {
    a = hi(p.quartz, p.bg1),
    b = hi(p.quartz, p.bg1),
    c = hi(p.quartz, p.bg),
  },
}