--Made by NexxxtLV#3769 v1.2.2
component = require("component")
computer = require("computer")
fs = require("filesystem")

gpu = component.gpu
chest = component.diamond
me = component.me_interface
apiary = component.proxy("94fd209f-b5f1-4863-b28f-e9fe3b4908ba")

exportSide = "EAST"
trashSide = "DOWN"
slotFromWhereGet = 2
timeZone = 3 -- GMT+3 Moscow
timeCorrection = timeZone * 3600

function getRealTime()
	if not fs.get("/").isReadOnly() then
	  local time = io.open("/tmp/.time", "w")
	  time:write()
	  time:close()
	  os.sleep(0.01)
	  local timeStamp = fs.lastModified("tmp/.time") / 1000 + timeCorrection
	  return timeStamp
	else
	  return false
	end
end

function isDrone(table)
	if string.find(table.label, "Drone") then
		return true
	else
		return false
	end
end

function findPrincessInChest(slot)
	local data = chest.getAllStacks(false)
	if data[slot] and data[slot].name then
		if string.find(data[slot].name, "beePrincessGE") then
			print("Found "..data[slot].name.." in slot: "..slot)
			return slot
		end
	else
		gpu.setForeground(0xFF0000)
		print("Critical error, can't find princess at slot: "..slot)
		gpu.setForeground(0x000000)
	end
end

function findPrincessInApiary()
	local data = apiary.getAllStacks(false)
	for i = 3, 8 do
		if data[i] and data[i].name then
			if string.find(data[i].name, "beePrincessGE") then
				print("Found "..data[i].name.." in slot: "..i)
				return i
			end
		end
	end
	return 0
end

function isApiaryFree()
	if apiary.getStackInSlot(1) then
		return false
	end
	return true
end

function waitForApiary(num)	
	io.write("waitForApiary(" .. num .. ") ")
	if isApiaryFree() ~= true then
		repeat
			io.write(". ")
			os.sleep(3)
		until isApiaryFree() == true
			print("waitForApiary(" .. num .. ") - is free")
	else
		print("waitForApiary(" .. num .. ") - is free")
	end
end

function clearNetwork()
	local ti = me.getItemsInNetwork() 
	local ta = me.getAvailableItems()
	local totalExported = 0

	for i in ipairs(ti) do
		if ti[i].size <= 10 and isDrone(ti[i]) then
			local exported = me.exportItem(ta[i].fingerprint, trashSide, ti[i].size, 1)
			totalExported = totalExported + exported.size
			os.sleep(0.1)
		end
	end

	gpu.setForeground(0xFFFF00)
	print("Removed "..totalExported.." drones")
	gpu.setForeground(0xFFFFFF)
end

function pushItem(side, slot, maxAmount, intoSlot)
	move = chest.pushItemIntoSlot(side, slot, maxAmount, intoSlot)
	if move ~= 0 then
		print("Getting princess from the chest slot at number "..slot.." and move to apiary")
		return true
	else
		gpu.setForeground(0xFF0000)
		print("Can't move 0 princess from chest")
		gpu.setForeground(0xFFFFFF)
		os.sleep(1)
		return false
	end
end

function pullItem(side, slot, maxAmount, intoSlot)
	move = chest.pullItemIntoSlot(side, slot, maxAmount, intoSlot)
	if move ~= 0 then
		print("Moving a princess from apiary to the chest slot at number "..intoSlot)
		return true
	else
		gpu.setForeground(0xFF0000)
		print("Can't move 0 princess from apiary")
		gpu.setForeground(0xFFFFFF)
		os.sleep(1)
		return false
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

startTime = getRealTime()

for i = 1, beesCount do -- how many bees
	for j = 1, multiplyCount do --how many cycles
		gpu.setForeground(0x00FF00)
		print("Bee number "..i.." is multiplying, number of multiply: "..j)
		gpu.setForeground(0xFFFFFF)

		if j == 1 then
			princessSlot = findPrincessInChest(slotFromWhereGet)
		else
			princessSlot = findPrincessInChest(1)
		end

		if princessSlot ~= 0 then
			repeat
			until pushItem(exportSide, princessSlot, 1, 1)
		else
			gpu.setForeground(0xFF0000)
			print("Can't get princess at slot nil")
			gpu.setForeground(0xFFFFFF)
		end

		waitForApiary(1)

		if j < multiplyCount then
			princessSlot = findPrincessInApiary()
			if princessSlot then
				repeat
				until pullItem(exportSide, princessSlot, 1, 1)
			end
		elseif j == multiplyCount then
			princessSlot = findPrincessInApiary()
			if princessSlot ~= 0 then
				repeat
				until pullItem(exportSide, princessSlot, 1, slotFromWhereGet)
				slotFromWhereGet = slotFromWhereGet + 1
			else
				gpu.setForeground(0xFF0000)
				print("[2]Can't get princess at slot nil")
				gpu.setForeground(0xFFFFFF)
			end
		end
	end
	os.sleep(5)
	if i % 3 == 0 then
		clearNetwork()
	end
end
print("All bees are bred, done in "..os.date("%H:%M:%S", getRealTime() - startTime))