local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local theme = require("themes.default.theme")
local dpi = require("beautiful.xresources").apply_dpi

local time = require("widgets.dashboard.time")
local todoist = require("widgets.dashboard.todoist")
local clockify = require("widgets.dashboard.clockify")
local async_http = require("async_http")
local function dashboard()
    local dashboard = wibox({
        visible = false,
        type = "dock",
        ontop = true,
        x = 0,
        y = 0,
        width = awful.screen.focused().geometry.width,
        height = awful.screen.focused().geometry.height,
        bg = theme.bg0,
        screen = awful.screen.focused {},


    })
    local keygrabber = awful.keygrabber {
        keybindings = {
            awful.key {
                modifiers = {},
                key = "t",
                on_press = function() awesome.emit_signal("todoist::reload") end
            }
        },
        keypressed_callback = function(self, mod, key, event)
            local modkeyPressed = false
            for k, v in pairs(mod) do
                if v == "Mod4" then
                    modkeyPressed = true
                end
            end
            if modkeyPressed and key == "d" then
                self:stop()
                dashboard:toggle()
            end
        end
    }
    local isLoaded = false;


    dashboard.toggle = function()
        if not dashboard.visible then
            dashboard.screen = awful.screen.focused {}
            dashboard.width = awful.screen.focused().geometry.width
            dashboard.height = awful.screen.focused().geometry.height
        end
        dashboard.visible = not dashboard.visible
        if dashboard.visible then
            keygrabber:start()
            if (not isLoaded) then
                awesome.emit_signal("todoist::init")
                awesome.emit_signal("clockify::init")
                isLoaded = true
            end
        end
    end
    local l = wibox.widget {
        homogeneous = true,
        expand = true,
        spacing = 5,
        forced_num_rows = 21,
        forced_num_cols = 20,
        layout = wibox.layout.grid
    }
    l:add_widget_at(time, 1, 7, 3, 8)
    l:add_widget_at(todoist, 4, 2, 13, 10)
    l:add_widget_at(clockify, 18, 2, 2, 10)
    --l:add_widget_at(time, 1, 3, 3, 3)
    --l:add_widget_at(time, 1, 4, 1, 1)
    --l:add_widget_at(time, 1, 5, 1, 1)
    --l:add_widget_at(time, 2, 1, 1, 1)
    --l:add_widget_at(time, 3, 1, 1, 1)
    --l:add_widget_at(time, 4, 1, 1, 1)
    --l:add_widget_at(time, 5, 1, 1, 1)
    --l:add_widget_at(time, 6, 1, 1, 1)
    --l:add_widget_at(time, 7, 1, 1, 1)
    --l:add_widget_at(time, 8, 1, 1, 1)
    --l:add_widget_at(time, 9, 1, 1, 1)
    --l:add_widget_at(time, 10, 1, 1, 1)
    --l:add_widget_at(time, 10, 2, 1, 1)
    --l:add_widget_at(time, 10, 2, 1, 1)
    --l:add_widget_at(time, 10, 3, 1, 1)
    --l:add_widget_at(time, 10, 4, 1)
    dashboard:setup {
        l,
        layout = wibox.layout.grid
    }


    awesome.connect_signal("dashboard::toggle", function()
        dashboard.toggle()
    end)
    return dashboard
end
return dashboard
