-- max range is 32 blocks
local term = require('term')
local component = require('component')
local radar = component.radar
local gpu = component.gpu
floor = math.floor
 
 
color = {
  green = 0x00ff00,
  yellow = 0xffb600,
  red = 0xff0000
}
 
whiteList = {
  NextLV = true,
}
 
 
gpu.setResolution(80,25)
 
while true do
  players = radar.getPlayers()
  term.clear()
  gpu.setForeground(color.yellow)
  gpu.set(2,1, 'In the radar zone detection: '..#players..' people')
    for i = 1, #players do      
      if whiteList[players[i].name] then 
        gpu.setForeground(color.green)
      else 
        gpu.setForeground(color.red) 
      end
      gpu.set(2, i+1, i..'. '..players[i].name)
      gpu.set(players[i].name:len() + 5, i+1, ' - '..math.ceil(players[i].distance)..' m')      
    end
  os.sleep(0.5)
end 
