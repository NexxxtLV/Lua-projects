--made by NexxxtLV v1.0.0
component = require("component")
gpu = component.gpu
chest = component.proxy("cb60cd52-77cf-4c04-baad-bc0214b72095")
apiary = component.proxy("4cb619ae-5c51-446b-aee9-bbf463558a98")
 
chestSlot = 61
 
function findPrincessInChest()
  local data = chest.getAllStacks(false)
  for i = 1, 108 do
    if data[i] then
      for name, value in pairs(data[i]) do
        if type(value) ~= "table" then
          if name == "name" then
            if value == "beePrincessGE" then
              print("Found "..value.." in slot: "..i)
              return i
            end
          end
        end
      end
    end
  end
end
 
function findPrincessInApiary()
  local data = apiary.getAllStacks(false)
  for i = 3, 8 do
    if data[i] then
      for name, value in pairs(data[i]) do
        if type(value) ~= "table" then
          if name == "name" then
            if value == "beePrincessGE" then
              print("Found "..value.." in slot: "..i)
              return i
            end
          end
        end
      end
    end
  end
end
 
function isApiaryFree(num)
  for i = 1, 1 do
    if apiary.getStackInSlot(i) then
      return false
    end
  end
  return true
end
 
function waitForApiary(num) 
  io.write("waitForApiary(" .. num .. ") ")
  if isApiaryFree(num) ~= true then
    repeat
      io.write(". ")
      os.sleep(3)
    until isApiaryFree(num) == true
      print("waitForApiary(" .. num .. ") - is free")
  else
    print("waitForApiary(" .. num .. ") - is free")
  end
end
 
gpu.setForeground(0x00FF00)
print("Enter the number of breeder cycles: ")
gpu.setForeground(0xFFFFFF)
multiplyCount = io.read("*n")
 
gpu.setForeground(0x00FF00)
print("Enter the number of bees to multiply: ")
gpu.setForeground(0xFFFFFF)
beesCount = io.read("*n")
 
for i = 1, beesCount do -- how many bees
  for j = 1, multiplyCount do --how many cycles
    gpu.setForeground(0x00FF00)
    print("Bee number "..i.." is multiplying, number of multiply: "..j)
    gpu.setForeground(0xFFFFFF)
    princessSlot = findPrincessInChest()
    if princessSlot then
      movePrincess = chest.pushItemIntoSlot("SOUTH", princessSlot, 1, 1)
      print("Getting princess from the chest slot at number "..princessSlot.." and move to apiary")
    else
      gpu.setForeground(0xFF0000)
      print("Can't get princess at slot "..princessSlot)
      gpu.setForeground(0xFFFFFF)
    end
 
    waitForApiary(1)
 
    if j < multiplyCount then
      princessSlot = findPrincessInApiary()
      if princessSlot then
        movePrincess = chest.pullItemIntoSlot("SOUTH", princessSlot, 1, 1)
        print("[1]Moving a princess from apiary to the chest slot at number "..1)
      end
    elseif j == multiplyCount then
    princessSlot = findPrincessInApiary()
    if princessSlot then
      movePrincess = chest.pullItemIntoSlot("SOUTH", princessSlot, 1, chestSlot)
      print("[2]Moving a princess from apiary to the chest slot at number "..chestSlot)
      chestSlot = chestSlot + 1
      --beesCount = beesCount + 1
      --multiplyCount = 1
    end
    else
      gpu.setForeground(0xFF0000)
      print("[2]Can't get princess at slot nil")
      gpu.setForeground(0xFFFFFF)
    end
  end
end
print("All bees are bred, the program is stopped")
