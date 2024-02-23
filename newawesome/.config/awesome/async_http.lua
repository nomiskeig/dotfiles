local awful = require("awful")
local json = require("json")

local async = {}
function async.async_http(params)
    local res = {}
    local method = params.method
    if type(params.url) ~= "string" then
        error("no url provided")
    end
    if type(params.method) ~= "string" then
        method = "GET"
    end
    local headers = "{"
    for k, v in pairs(params.headers) do
        headers = headers .. "['" .. k .. "']" .. " = '" .. v .. "',"
    end
    headers = headers .. "}"
    local sendBody = ""
    if type(params.body) == "string" then
        json.encode(params.body)
    end
    local test = "{\"end\": \"asdf\"}"
    local testCommand = [[
        io.write('test')
        io.write('test2')
    ]]
    -- TODO: make body post work, see https://stackoverflow.com/questions/74960005/how-would-one-send-an-http-post-request

    local command = [[
        local http = require('socket.http')
        local ltn12 = require('ltn12')
        local t = {}
        local _, error = http.request {
            url = ']] .. params.url .. [[',
            method = "]] .. method .. [[",
            headers = ]] .. headers .. [[,
            sink = ltn12.sink.table(t)
        }
        local body = table.concat(t)
        io.write(body)
        io.stderr:write(error)

    ]]
    if params.body then
        command = [[
        local http = require('socket.http')
        local ltn12 = require("ltn12")
        local t = {}
        local _, error = http.request {
            url = ']] .. params.url .. [[',
            method = ']] .. method .. [[',
            headers = ]] .. headers .. [[,
            sink = ltn12.sink.table(t),
            source = ltn12.source.string(']] ..  json.encode(params.body) .. [[')
        }
        local body = table.concat(t)
        io.write(body)
        io.stderr:write(error)
    ]]
    end
    awful.spawn.easy_async("lua  -e \"" .. string.gsub(command, "\"", "\\\"") .. "\"", function(stdout, stderr, exitreason, exitcode)
        if stderr ~= "200" then
            --print("Error: " .. stderr)
        end
        params.callback(stdout)
    end)
end

return async
