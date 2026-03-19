-- =============================================================
-- gruber-darker lualine theme
-- Mirrors gruber-darker-theme.el palette exactly
-- Place at: lua/lualine/themes/gruber-darker.lua
-- Usage:    require('lualine').setup { options = { theme = 'gruber-darker' } }
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
  yellow   = { fg = "#ffdd33", ctermfg = 220 },
  green    = { fg = "#73c936", ctermfg = 76 },
  niagara  = { fg = "#96a6c8", ctermfg = 147 },
  quartz   = { fg = "#95a99f", ctermfg = 108 },
  wisteria = { fg = "#9e95c7", ctermfg = 98 },
  brown    = { fg = "#cc8c3c", ctermfg = 172 },
  red      = { fg = "#f43841", ctermfg = 196 },
  red1     = { fg = "#ff4f58", ctermfg = 203 },
}

-- Helper: merge fg + bg tables into one spec
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

-- =============================================================
-- Section roles:
--   a  — mode / leftmost badge     (most prominent)
--   b  — branch / filename         (mid prominence)
--   c  — right side info           (subtle)
-- =============================================================

local gruber = {

  -- -----------------------------------------------------------
  -- NORMAL  — yellow badge
  -- -----------------------------------------------------------
  normal = {
    a = hi(p.bg, p.yellow, { gui = "bold", cterm = "bold" }),
    b = hi(p.quartz, p.bg2, {}),
    c = hi(p.fg, p.bg1, {}),
  },

  -- -----------------------------------------------------------
  -- INSERT  — green badge
  -- -----------------------------------------------------------
  insert = {
    a = hi(p.bg, p.green, { gui = "bold", cterm = "bold" }),
    b = hi(p.quartz, p.bg2, {}),
    c = hi(p.fg, p.bg1, {}),
  },

  -- -----------------------------------------------------------
  -- VISUAL  — niagara badge
  -- -----------------------------------------------------------
  visual = {
    a = hi(p.bg, p.niagara, { gui = "bold", cterm = "bold" }),
    b = hi(p.quartz, p.bg2, {}),
    c = hi(p.fg, p.bg1, {}),
  },

  -- -----------------------------------------------------------
  -- REPLACE — red badge
  -- -----------------------------------------------------------
  replace = {
    a = hi(p.white, p.red, { gui = "bold", cterm = "bold" }),
    b = hi(p.quartz, p.bg2, {}),
    c = hi(p.fg, p.bg1, {}),
  },

  -- -----------------------------------------------------------
  -- COMMAND — brown/gold badge
  -- -----------------------------------------------------------
  command = {
    a = hi(p.bg, p.brown, { gui = "bold", cterm = "bold" }),
    b = hi(p.quartz, p.bg2, {}),
    c = hi(p.fg, p.bg1, {}),
  },

  -- -----------------------------------------------------------
  -- TERMINAL — wisteria badge
  -- -----------------------------------------------------------
  terminal = {
    a = hi(p.bg, p.wisteria, { gui = "bold", cterm = "bold" }),
    b = hi(p.quartz, p.bg2, {}),
    c = hi(p.fg, p.bg1, {}),
  },

  -- -----------------------------------------------------------
  -- INACTIVE — muted, no bold
  -- -----------------------------------------------------------
  inactive = {
    a = hi(p.quartz, p.bg1, {}),
    b = hi(p.quartz, p.bg1, {}),
    c = hi(p.quartz, p.bg, {}),
  },
}

return gruber
