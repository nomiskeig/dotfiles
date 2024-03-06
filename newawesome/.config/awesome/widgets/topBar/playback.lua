local awful = require("awful")
local wibox = require("wibox")

local playback = require("widgets.playback")

local playbackWidget = wibox.widget {
        playback.playerImage,
        playback.title,
        {
            widget = wibox.widget.textbox,
            text = " - ",
        },
        playback.artist,
        layout = wibox.layout.fixed.horizontal,
}

return playbackWidget
