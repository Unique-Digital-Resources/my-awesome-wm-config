local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- Function to create a custom client widget with mouse events
local function create_client_widget(c)
    print("icon_name: " , c.icon_name)
    print("class: " , c.class)
    -- Create the icon widget
    local a_client_icon = wibox.widget{ 
        widget = awful.widget.clienticon(c), 
    }
    local a_small_shape = wibox.widget{
        {
            widget = wibox.widget.textbox,
        },
        shape = gears.shape.circle,  -- Shape of the background to circle
        bg = "#FF0000",  -- Background color of the circle
        widget = wibox.container.background,
    }
    local inner_layout = wibox.widget {
        a_client_icon,
        a_small_shape,
        layout = wibox.layout.ratio.vertical,
    }
    
    inner_layout:set_widget_ratio(my_client_icon, 0.8)
    inner_layout:set_widget_ratio(my_small_shape, 0.2)
    -- inner_layout:adjust_ratio(2, 0.8, 0.2)  -- Explicitly set and apply ratios
    -- inner_layout:add(my_client_icon)
    -- inner_layout:add(my_small_shape)
    -- inner_layout:set_widget_ratio(my_client_icon, 0.8)
    -- inner_layout:set_widget_ratio(my_small_shape, 0.2)

    local icon = wibox.widget {
        {
            {
                {
                   widget = inner_layout, -- widget = awful.widget.clienticon(c),  -- Use awful.widget.clienticon to get the client's icon
                },
                forced_width = 40,
                forced_height = 40,
                margins = 4,  -- Margins around the icon
                widget = wibox.container.margin,
            },
            shape = gears.shape.circle,  -- Shape of the background to circle
            bg = "#FF0000",  -- Background color of the circle
            widget = wibox.container.background,
        },
        margins = 1,  -- Margins around the icon background
        widget = wibox.container.margin,
    }

     -- Reference to the outer background container for changing the color
    local outer_bg = icon.children[1]  -- The outer container that holds the background and icon

    
    -- Add mouse events to the icon
    icon:buttons(gears.table.join(
        -- Left click to focus the client
        awful.button({}, 1, function()
            c:emit_signal("request::activate", "tasklist", {raise = true})
        end),
        
        -- Right click to show a simple context menu (simplified for testing)
        awful.button({}, 3, function()
            print("Right-click detected on client: " .. c.name)
            awful.menu({
                items = {
                    { "Open Terminal", terminal },
                    { "Restart", awesome.restart },
                    { "Quit", awesome.quit }
                }
            }):show()
        end)
    ))

    -- Optional: Change icon background on mouse hover
    icon:connect_signal("mouse::enter", function()
        outer_bg.bg = "#00FF00"  -- Change background color of the outer container (circle) on hover
    end)

    icon:connect_signal("mouse::leave", function()
        outer_bg.bg = "#FF0000"  -- Revert background color when mouse leaves
    end)

    return icon
end


-- Function to create custom tasklist with configurable order
local function create_custom_tasklist(s, alignment, client_order)
    local a_client_order = client_order or "first"  -- Default to "first"
    
    -- Configurable margin for tasklist
    local tasklist_margin = 4  -- tasklist height, Customize this value as needed

    -- Create the tasklist widget
    local tasklist_widget = wibox.widget {
        layout = wibox.layout.fixed.horizontal,  -- Fixed horizontal layout for the icons
    }

    tasklist_widget.spacing = 10 -- Add spacing between each layout widgets.

    -- Style the tasklist with a background and rounded corners, including alignment
    local styled_tasklist = wibox.widget {
        {
            tasklist_widget,  -- Tasklist with icons
            halign = alignment or "center",  -- Set alignment: "left", "center", or "right"
            widget = wibox.container.place,  -- Align the entire tasklist
        },
        bg = "#CCCCCC",  -- Background color of the tasklist
        shape = gears.shape.rounded_rect,  -- Shape for the tasklist
        widget = wibox.container.background,
    }

    -- Wrap the tasklist in a container with margins
    local parent_widget = wibox.widget {
        {
            styled_tasklist,  -- The styled tasklist
            margins = tasklist_margin,  -- Apply margins here
            widget = wibox.container.margin,
        },
        widget = wibox.container.background,
    }

    -- Update the tasklist with configurable client order
    local function update_tasklist()
        tasklist_widget:reset()

        local tag = s.selected_tag
        if tag then
            for _, c in ipairs(tag:clients()) do
                -- Create the client widget (icon)
                local icon = create_client_widget(c)

                -- Add the icon to the tasklist at the specified position (first or last)
                if a_client_order == "first" then
                    tasklist_widget:insert(1, icon)  -- Insert at the start (first)
                else
                    tasklist_widget:add(icon)  -- Add at the end (last)
                end

                -- -- Add spacing between icons
                -- if _ < #tag:clients() then
                --     local spacer = wibox.widget {
                --         forced_width = 1, -- Space between icons
                --         layout = wibox.layout.fixed.horizontal,
                --     }
                --     tasklist_widget:add(spacer)
                -- end
            end
        end
    end

    -- Connect signals to update tasklist
    s:connect_signal("tag::history::update", update_tasklist)
    s:connect_signal("property::selected_tag", update_tasklist)
    client.connect_signal("manage", update_tasklist)
    client.connect_signal("unmanage", update_tasklist)
    client.connect_signal("property::icon", update_tasklist)
    client.connect_signal("property::name", update_tasklist)
    client.connect_signal("tagged", update_tasklist)
    client.connect_signal("untagged", update_tasklist)

    -- Trigger initial update
    update_tasklist()

    return parent_widget, tasklist_widget
end

return create_custom_tasklist
