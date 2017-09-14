local module = {}

module.debugging = false -- whether to print status updates

local eventtap = require "hs.eventtap"
local event    = eventtap.event
local inspect  = require "hs.inspect"

local systemKeyHandler = function(e)
  local flags = e:getFlags()
  local raw_event = e:getRawEventData()

 -- if we catch fn + power key then sleep
  if flags.fn and raw_event.NSEventData.subtype == 16 then
    hs.caffeinate.systemSleep()
    return true
  end

  return false
end

module.listener = hs.eventtap.new({ hs.eventtap.event.types.NSSystemDefined }, systemKeyHandler)

module.start = function()
    module.listener:start()
    if module.debugging then print("sleep_key: listener started") end
end

module.stop = function()
    module.listener:stop()
    if module.debugging then print("sleep_key: listener stopped") end
end

module.start() -- autostart

return module

