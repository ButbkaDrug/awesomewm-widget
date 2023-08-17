local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local HOME = os.getenv("HOME")
local ICON_DIR = HOME .. "/.config/awesome/mycrp/icons/"

local widget= wibox.widget {
    {
        image = ICON_DIR .. 'bookmark.svg',
        resize = true,
        widget = wibox.widget.imagebox,
    },
    margins = 4,
    widget = wibox.container.margin
}

local menu_items = {
    {name = 'Reddit', icon_name = "reddit.svg", url = 'https://www.reddit.com/'},
    {name = 'StackOverflow', icon_name = "stackoverflow.svg", url = 'https://www.stackoverflow.com/'},
    {name = 'GitHub', icon_name = "github.svg", url = 'https://www.github.com/'},
}

local popup = awful.popup {
    ontop = true,
    visible = false,
    shape =function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 4)
    end,
    border_width = 1,
    border_color = beautiful.bg_focus,
    maximum_width= 400,
    offset = {y = 5},
    widget = {}
}

local rows = { layout = wibox.layout.fixed.vertical }


for _, item in ipairs(menu_items) do
    local row = wibox.widget {
        {
            {
                {
                    image = ICON_DIR .. item.icon_name,
                    forced_width = 16,
                    forced_height = 16,
                    widget = wibox.widget.imagebox
                },
                {
                    text = item.name,
                    widget = wibox.widget.textbox
                },
                spacing = 12,
                layout = wibox.layout.fixed.horizontal
            },
            margins = 8,
            widget = wibox.container.margin
        },
        bg = beautiful.bg_normal,
        widget = wibox.container.background
    }

    row:connect_signal("mouse::enter", function (c)
       c:set_bg(beautiful.bg_focus) 
    end)

    row:connect_signal("mouse::leave", function (c)
       c:set_bg(beautiful.bg_normal)
    end)

    local old_cursor, old_wibox

    row:connect_signal("mouse::enter", function ()
       local wb = mouse.current_wibox
       old_cursor, old_wibox = wb.cursor, wb
       wb.cursor = "hand1"
    end)

    row:connect_signal("mouse::leave", function ()
       if old_wibox then
           old_wibox.cursor = old_cursor
           old_wibox = nil
        end
    end)

    row:buttons(
        awful.util.table.join(
            awful.button({}, 1, function ()
               popup.visible = not popup.visible
               awful.spawn.with_shell('xdg-open' .. item.url)
        end)
    )
    )

    table.insert(rows, row)
end


popup:setup(rows)


widget:buttons(
    awful.util.table.join(
        awful.button({}, 1, function ()
            if popup.visible then
                popup.visible = not popup.visible
            else
                popup:move_next_to(mouse.current_widget_geometry)
            end
        end)

    )
)

return widget
