local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local main_menu = require("menu") -- Make sure this is correctly initialized
local my_custom_tasklist = require("wibar.custom_tasklist")

-- Create a textclock widget
local mytextclock = wibox.widget.textclock()

-- Create a system tray
local systray = wibox.widget.systray()

-- Taglist buttons
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

-- Wibar buttons with added debugging
local wibar_buttons = gears.table.join(
    awful.button({}, 3, function()
        print("Right-click detected")
        -- Debugging: Check if main_menu is initialized
        --if main_menu then
            --print("Right-click detected, toggling main menu.")
            --main_menu:toggle()
        --else
            --print("Error: main_menu is nil or not initialized properly!")
        --end
    end)
)

-- Create the wibar
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc(1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end)
    ))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create the custom tasklist
    local parent_widget, tasklist_widget = my_custom_tasklist(s, {
        fit = true,
        margins = { top = 10, bottom = 10, left = 20, right = 20 },
        icon_size = 32,  -- Set a larger icon size
        icon_alignment = "left",  -- Align icons to the left
        icon_spacing = 10,  -- Space between icons
        expand_icons = false  -- Do not expand the icons
    })

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "bottom", screen = s, height = 40 })

    -- Set wibar buttons
    s.mywibox:buttons(wibar_buttons)

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox,
        },
        parent_widget, -- Middle widget (custom tasklist)
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            systray,
            mytextclock,
            s.mylayoutbox,
        },
    }
end)

