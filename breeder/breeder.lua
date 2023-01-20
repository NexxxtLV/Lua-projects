--Made by NexxxtLV#3769 v1.1.3
component = require("component")
gpu = component.gpu
chest = component.diamond
apiary = component.proxy("94fd209f-b5f1-4863-b28f-e9fe3b4908ba")
me = component.me_interface

chestSlot = 61
exportSide = "EAST"
trashSide = "DOWN"

function isDrone(table)
	if string.find(table.label, "Drone") then
		return true
	else
		return false
	end
end

function findPrincessInChest()
	local data = chest.getAllStacks(false)
	for i = 1, chest.getInventorySize() do
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
	return 0
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

for i = 1, beesCount do -- how many bees
	for j = 1, multiplyCount do --how many cycles
		gpu.setForeground(0x00FF00)
		print("Bee number "..i.." is multiplying, number of multiply: "..j)
		gpu.setForeground(0xFFFFFF)
		princessSlot = findPrincessInChest()
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
				until pullItem(exportSide, princessSlot, 1, chestSlot)
				chestSlot = chestSlot + 1
			else
				gpu.setForeground(0xFF0000)
				print("[2]Can't get princess at slot nil")
				gpu.setForeground(0xFFFFFF)
			end
		end
	end
	os.sleep(1)
	if i % 3 == 0 then
		clearNetwork()
	end
end
print("All bees are bred, the program is stopped")
