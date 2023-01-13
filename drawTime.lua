local fs = require("filesystem")
component = require("component")
gpu = component.gpu
 
local event = require("event").pull
local timeZone = 3 --
local timeCorrection = timeZone * 3600
local screenW, screenH = gpu.getResolution()
local run = true
 
gpu.fill(1, 1, screenW, screenH, " ")
gpu.setForeground(0x00FF00)
gpu.setResolution(10, 5)
 
function getRealTime()
  if not fs.get("/").isReadOnly() then
    local time = io.open("/tmp/.time", "w")
    --time:write()
    time:close()
    os.sleep(0.01)
    local timeStamp = fs.lastModified("tmp/.time") / 1000 + timeCorrection
    return os.date("%H:%M:%S", timeStamp)
  else
    return false
  end
end
 
while run do
  local e = {event(1)}
  if e[1] == "key_down" then
    run = false
  end
  gpu.set(2, 3, getRealTime())
end
 
gpu.setResolution(80, 25)
gpu.setForeground(0xFFFFFF)
os.execute("cls")
