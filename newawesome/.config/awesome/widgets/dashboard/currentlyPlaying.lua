local wibox = require("wibox")
local playback = require("widgets.playback")

local currentlyPlaying = wibox.widget {
    {
        text = "test currently playing",
        widget = wibox.widget.textbox
    },
    playback.title,
    playback.artist,
    widget = wibox.layout.fixed.vertical
}
return currentlyPlaying
