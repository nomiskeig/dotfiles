local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local amountScreens = screen.count()

local fontSize = 30

local font = beautiful.get().font
font = font:sub(1, -2) .. fontSize

local time = wibox.widget.textclock()
time.font = font
time.format = '%H:%M'

local date = wibox.widget.textclock()
date.font = font
date.format = '%a %e.%m.%y'
local w = wibox.widget {
    {
        {
            date,
            halign = "center",
            widget = wibox.container.place
        },
        {
            time,
            halign = "center",
            widget = wibox.container.place
        },
        spacing = 5,
        layout = wibox.layout.fixed.vertical
    },

    valign = "center",
    widget = wibox.container.place
}
return w
