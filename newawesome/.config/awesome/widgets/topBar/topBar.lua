local awful = require("awful")
local wibox = require("wibox")
local playback = require("widgets.topBar.playback")


local bar = {}



local function createTaskList(screen)
    screen.taskList = awful.widget.tasklist {
        screen = screen,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = {
            awful.button({}, 1, function(c)
                if c == client.focus then
                    c.minimized = true
                else
                    c:emit_signal("request::activate", "tasklist", { raise = true })
                end
            end)
        }

    }
end


function bar.createTopBar(screen)
    createTaskList(screen)

    screen.promptbox = awful.widget.prompt()

    screen.mywibox = awful.wibar({ position = "top", screen = screen, height = 22 })

    screen.mywibox:setup {
        layout = wibox.layout.fixed.horizontal,
        {

            screen.promptbox,
            screen.taskList,
            widget = wibox.layout.fixed.horizontal
        },
        {
            widget = wibox.container.place,
            halign = "right",
            fill_horizontal = "true",
            {
                playback,
                    wibox.widget.systray(false),
                {
                    widget = wibox.widget.textclock,
                    format = '%a %e.%m.%y, %k:%M'
                },
                {
                    widget = awful.widget.layoutbox,
                    screen = screen

                },
                layout = wibox.layout.fixed.horizontal
            },
        }
    }
end

return bar
