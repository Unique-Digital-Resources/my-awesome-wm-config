-- rc.lua

-- Load libraries
pcall(require, "luarocks.loader")
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

-- Load external modules
require("errors")       -- Error handling
require("theme")        -- Theme initialization
require("bindings")     -- Key and mouse bindings
require("rules")        -- Window rules
require("signals")      -- Client signals
require("autostart")    -- Autostart applications

-- Load wibar modules
require("wibar")

local main_menu = require("menu")
-- local display_manager = require("display_manager.display_manager")

-- -- Create and show the display manager
-- display_manager.create()

-- Function to setup Awesome WM after authentication
local function setup_awesome()
    root.buttons(gears.table.join(
        awful.button({}, 3, function () main_menu:toggle() end)
    ))

    -- Show the wibar after authentication
    for s in screen do
        s.mywibox.visible = true
    end

    -- Other Awesome WM setup code here
end

setup_awesome()

-- -- Setup Awesome WM only after the display manager completes its task
-- awesome.connect_signal("authentication::successful", function()
--     for s in screen do
--         for _, c in pairs(s.all_clients) do
--             c.minimized = false
--         end
--     end
--     setup_awesome()
-- end)















-- -- Load libraries
-- pcall(require, "luarocks.loader")
-- local gears = require("gears")
-- local awful = require("awful")
-- require("awful.autofocus")
-- local wibox = require("wibox")
-- local beautiful = require("beautiful")
-- local naughty = require("naughty")
-- local menubar = require("menubar")
-- local hotkeys_popup = require("awful.hotkeys_popup")
-- require("awful.hotkeys_popup.keys")

-- -- Load external modules
-- require("errors")       -- Error handling
-- require("theme")        -- Theme initialization
-- --require("menu")         -- Menu and launcher
-- require("bindings")     -- Key and mouse bindings
-- require("rules")        -- Window rules
-- require("signals")      -- Client signals
-- require("autostart")    -- Autostart applications

-- -- Load wibar modules
-- require("wibar")

-- local main_menu = require("menu")


-- root.buttons(gears.table.join(
--     awful.button({}, 3, function () main_menu:toggle() end)
-- ))
