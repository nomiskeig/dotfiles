local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local http = require("socket.http")
local json = require("json")
local gears = require("gears")
local tokens = require("tokens")
local ltn12 = require("ltn12")
local async = require("async_http")




local defaultHeaders = {

    authorization = "Bearer " .. tokens.todoist
}
local fontSize = 20

local font = beautiful.font_dashboard




local prioColors = {
    [2] = "#5297ff",
    [3] = "#ff9a13",
    [4] = "#ff7066",
}

local projects = {};

local function getProjectNameById(id)
    for k, v in pairs(projects) do
        if v.id == id then
            return v.name
        end
    end
    return ""
end
local clockifyProjects = {}


local loadTasks;
local taskList = wibox.layout.fixed.vertical();
local closeTask = function(taskID)
    local uri = "https://api.todoist.com/rest/v2/tasks/" .. taskID .. "/close"
    http.request {
        url = uri,
        headers = defaultHeaders,
        method = "POST",
    }
    loadTasks()
end

local function trackTask(taskName, project)
    local clockifyProjectID
    for k, v in pairs(clockifyProjects) do
        print(k, v)
        if v.name == project then
            clockifyProjectID = v.id
        end
    end
    async.async_http {
        url = "https://api.clockify.me/api/v1/workspaces/" .. tokens.clockify_workspace .. "/time-entries",
        method = "POST",
        body = {
            ["description"] = taskName,
            ["projectId"] = clockifyProjectID
        },
        headers = {

            ["X-Api-Key"] = tokens.clockify_api,
            ["Content-Type"] = "application/json"
        },
        callback = function(res) awesome.emit_signal("clockify::reload") end
    }
end
local function loadClockifyProjects()
    async.async_http {
        url = "https://api.clockify.me/api/v1/workspaces/" .. tokens.clockify_workspace .. "/projects",
        method = "GET",
        headers = {
            ["X-Api-Key"] = tokens.clockify_api,
        },
        callback = function(res)
            print("got to callback")
            print(res)
            clockifyProjects = json.decode(res)
        end

    }
end
loadTasks = function()
    taskList:reset()
    async.async_http {
        url = "https://api.todoist.com/rest/v2/tasks?filter=today%7Coverdue",
        headers = defaultHeaders,
        callback = function(result)
            local tasks = json.decode(result)
            for k, v in pairs(tasks) do
                taskList:set_spacing(10)
                taskList:set_spacing_widget(wibox.widget.separator())
                local taskEntry = wibox.widget {
                    {
                        {
                            checked = false,
                            color = prioColors[v.priority],
                            shape = gears.shape.circle,
                            forced_height = fontSize,
                            forced_width = fontSize,
                            widget = wibox.widget.checkbox,
                            buttons = {
                                awful.button {
                                    on_press = function() closeTask(v.id) end
                                },
                            }
                        },
                        {
                            checked = true,
                            color = prioColors[v.priority],
                            shape = gears.shape.circle,
                            forced_height = fontSize,
                            forced_width = fontSize,
                            widget = wibox.widget.checkbox,
                            buttons = {
                                awful.button {
                                    on_press = function() trackTask(v.content, getProjectNameById(v.project_id)) end
                                },
                            }

                        },
                        widget = wibox.layout.align.horizontal
                    },
                    {
                        {
                            {
                                text = v.content,
                                font = font,
                                widget = wibox.widget.textbox
                            },
                            fps = 20,
                            speed = 45,
                            step_function = wibox.container.scroll.step_functions.linear_back_and_forth,
                            widget = wibox.container.scroll.horizontal,
                        },
                        margins = { left = 5, right = 5 },
                        widget = wibox.container.margin
                    },
                    {
                        {

                            text = getProjectNameById(v.project_id),
                            font = font,
                            widget = wibox.widget.textbox
                        },
                        halign = "right",
                        widget = wibox.container.place
                    },

                    spacing = 10,
                    widget = wibox.layout.align.horizontal,
                }
                taskList:add(taskEntry)
            end
        end
    }
end

local loadedProjects = false
local loadProjects = function()
    local t = {}
    async.async_http {
        url = "https://api.todoist.com/rest/v2/projects",
        headers = defaultHeaders,
        callback = function(result)
            projects = json.decode(result)
            if loadedProjects == false then
                loadTasks()
                loadedProjects = true
            end
        end
    }
end

local startTracking = function()

end

local init = function()
    loadClockifyProjects()
    loadProjects()
end
awesome.connect_signal("todoist::reload", function() loadTasks() end)
awesome.connect_signal("todoist::init", function() init() end)

local todoist = wibox.widget {
    {


        taskList,
        margins = {
            left = 5,
            top = 5,
        },
        widget = wibox.container.margin
    },
    --bg = theme.bg2,
    widget = wibox.container.background
}


return todoist
