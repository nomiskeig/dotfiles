local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local playback = {}
playback.title = wibox.widget {
    text = "title",
    font = beautiful.font,
    widget = wibox.widget.textbox,
}
playback.artist = wibox.widget {
    text = "artist",
    font = beautiful.font,
    widget = wibox.widget.textbox
}

playback.playerImage = wibox.widget {
    image = gears.filesystem.get_configuration_dir() .. "theme/images/spotify-logo.png",
    resize = true,
    widget = wibox.widget.imagebox
}
print(gears.filesystem.get_configuration_dir())
print(playback.playerImage.source_width)
local function extractAndSetInfos(output)
    local _, _, title = string.find(output, "title\"[^\"]*\"([^\"]*)\".*")
    local _, _, artist = string.find(output, "artist\"[^\"]*\"([^\"]*)\".*")

    --playback_textbox:set_text(title .. "\n" .. artist .."\n" .. output)
    playback.artist:set_text(artist)
    playback.title:set_text(title)
end

local function setCurrentlyPlaying(platform)
    if platform == "Firefox" then
        awful.spawn.easy_async(
            'bash -c "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.firefox.instance_1_8 /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata"',
            function(stdout, stderr, exitreason, exitcode)
                extractAndSetInfos(stdout)
            end)
    end
    if platform == "Spotify" then
        awful.spawn.easy_async(
            'bash -c "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata"',
            function(stdout, stderr, exitreason, exitcode)
                extractAndSetInfos(stdout)
            end)
    end
end




gears.timer {
    timeout = 10,
    call_now = true,
    autostart = true,
    callback = function()
        -- check spotify
        awful.spawn.easy_async(
            'bash -c "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:PlaybackStatus"',
            function(stdout, stderr, exitreason, exitcode)
                if string.find(stdout, "Playing") then
                    setCurrentlyPlaying("Spotify")
                end
            end)
        -- check youtube
        awful.spawn.easy_async(
            'bash -c "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.firefox.instance_1_8 /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:PlaybackStatus"',
            function(stdout, stderr, exitreason, exitcode)
                if string.find(stdout, "Playing") then
                    setCurrentlyPlaying("Firefox")
                end
            end)
    end

}


return playback
