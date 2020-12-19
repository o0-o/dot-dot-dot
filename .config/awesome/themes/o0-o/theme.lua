----------------------------------------------
-- Awesome theme which follows GTK+ 3 theme --
--   by Yauhen Kirylau                      --
----------------------------------------------

local theme_assets = require("beautiful.theme_assets")
local dpi = require("beautiful.xresources").apply_dpi
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local gears_shape = require("gears.shape")
local wibox = require("wibox")
local awful_widget_clienticon = require("awful.widget.clienticon")
local gtk = require("beautiful.gtk")

-- inherit gtk theme:
local theme = dofile(themes_path.."gtk/theme.lua")

theme.useless_gap = dpi(5)
theme.border_width = dpi(0)

theme.wallpaper = os.getenv("HOME").."/Pictures/Backgrounds/o0-o.png"

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80:foldmethod=marker
