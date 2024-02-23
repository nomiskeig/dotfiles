local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local http = require("socket.http")
local tokens = require("tokens")
local ltn12 = require("ltn12")
local json = require("json")
local gears = require("gears")
local async = require("async_http")

local fontSize = 20
local font = beautiful.get().font
font = font:sub(1, -2) .. fontSize

local taskWidget = wibox.widget {
    widget = wibox.widget.textbox,
    font = font,
    text = "No task is currently tracked"
}
local stopButton
local diffTime = 1;
local timeDisplay = wibox.widget {

    widget = wibox.widget.textbox,
    text = "difftime placeholder",
    font = font,
    visible = false,
}



local currentTask = {}
local function setRunTime()
    local diffSeconds = string.format("%02d", math.floor(diffTime % 60))
    local diffMinutes = string.format("%02d", math.floor((diffTime / 60) % 60))
    local diffHours = string.format("%02d", math.floor(diffTime / (60 * 60)))
    timeDisplay:set_text(diffHours .. ":" .. diffMinutes .. ":" .. diffSeconds)
end
gears.timer {
    timeout = 1,
    autostart = true,
    call_now = true,
    callback = function()
        diffTime = diffTime + 1
        setRunTime()
    end,

}





local function loadCurrentTask()
    async.async_http {
        url = "https://api.clockify.me/api/v1/workspaces/" .. tokens.clockify_workspace .. "/user/" .. tokens.clockify_user .. "/time-entries?in-progress=true",
        headers = {
            ["X-Api-Key"] = tokens.clockify_api,
        },
        callback = function(result)
            print(result)
            if result == "[]\n" then
                timeDisplay.visible = false
                stopButton.visible = false
                return
            end
            timeDisplay.visible = true
            stopButton.visible = true

            currentTask = json.decode(result)

            currentTask = currentTask[1]
            taskWidget:set_text(currentTask.description)
            -- parse start time
            local _, _, year, month, day, hours, minutes, seconds = string.find(currentTask.timeInterval.start,
                "(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)Z")
            local startTime = os.time {
                year = year,
                month = month,
                day = day,
                hour = hours + 1,
                min = minutes,
                sec = seconds
                -- TODO: this hour has to be adjusted on daylightsaving change lol, idk why its + and not -1
            }
            local currentTime = os.time()
            diffTime = os.difftime(currentTime, startTime)
            setRunTime()
        end
    }
end
local function endCurrentTask()
    async.async_http {
        url = "https://api.clockify.me/api/v1/workspaces/" .. tokens.clockify_workspace .. "/user/" .. tokens.clockify_user .. "/time-entries",
        method = "PATCH",
        body = {
            ["end"] = os.date("!%Y-%m-%dT%TZ")
        },
        headers = {
            ["X-Api-Key"] = tokens.clockify_api,
            ["Content-Type"] = "application/json"
        },
        callback = function(result) loadCurrentTask() end
    }
end
stopButton = wibox.widget {
    checked = false,
    color = "#ff0000",
    shape = gears.shape.cirle,
    forced_height = fontSize,
    forced_width = fontSize,
    widget = wibox.widget.checkbox,
    buttons = {
        awful.button {
            on_press = function() endCurrentTask() end
        }
    },
    visible = false
}
local clockify = wibox.widget {

    {

        text = "Currently tracking:",
        font = font,
        widget = wibox.widget.textbox
    },
    {
        taskWidget,
        {
            {
                stopButton,
                timeDisplay,
                widget = wibox.layout.fixed.horizontal
            },
            widget = wibox.container.place,
            halign = "right",
            fill_horizontal = true
        },
        widget = wibox.layout.fixed.horizontal
    },
    spacing = 10,
    widget = wibox.layout.fixed.vertical
}


local init = function()
    loadCurrentTask()
end


awesome.connect_signal("clockify::reload", function() loadCurrentTask() end)
awesome.connect_signal("clockify::init", function() init() end);
return clockify
