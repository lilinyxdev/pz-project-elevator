require 'Blacksmith/ISUI/ISBlacksmithMenu'

Events.OnFillWorldObjectContextMenu.Remove(ISBlacksmithMenu.doBuildMenu)

local oldDoBuild = ISBlacksmithMenu.doBuildMenu

ElevatorCraft = {};

ElevatorCraft.onElevator = function(worldobjects, player, torchUse)
    local elevator = ISDoubleTileFurniture:new("Elevator", "fixtures_escalators_01_51", "fixtures_escalators_01_50", "fixtures_escalators_01_48", "fixtures_escalators_01_49");
    -- local fence = ISWoodenWall:new("fixtures_escalators_01_48","fixtures_escalators_01_49", nil);
    elevator.needToBeAgainstWall = true;
    elevator.blockAllTheSquare = false;
    elevator.isWallLike = true;
    elevator.firstItem = "BlowTorch";
    elevator.secondItem = "WeldingMask";
    elevator.craftingBank = "BlowTorch";
    elevator.modData["xp:MetalWelding"] = 25;
    elevator.modData["need:Base.SmallSheetMetal"]= "2";
    elevator.modData["need:Base.SheetMetal"]= "4";
    elevator.modData["need:Base.MetalBar"]= "8";
    elevator.modData["need:Base.MetalPipe"] = "4";
    elevator.modData["need:Base.ScrapMetal"]= "3";
    elevator.modData["need:Base.ElectronicsScrap"] = "4";
    elevator.modData["use:Base.BlowTorch"] = torchUse;
    elevator.modData["use:Base.WeldingRods"] = ISBlacksmithMenu.weldingRodUses(torchUse);
    elevator.player = player
    elevator.completionSound = "BuildMetalStructureLargePoleFence";
    getCell():setDrag(elevator, player);
end


Events.OnFillWorldObjectContextMenu.Add(ElevatorCraft.OnFillWorldObjectContextMenu);

-- Metalwork menu injection code from https://steamcommunity.com/sharedfiles/filedetails/
-- begin
function ISBlacksmithMenu.doBuildMenu(player, context, worldobjects, test, ...)
	local oldaddSubMenu = ISContextMenu.addSubMenu
	local menu = nil
	ISContextMenu.addSubMenu = function(self, option, submenu, ...)
		menu = menu ~= nil and menu or option == context:getOptionFromName(getText("ContextMenu_MetalWelding")) and submenu
		return oldaddSubMenu(self, option, submenu, ...)
	end
	local ret = {oldDoBuild(player, context, worldobjects, test, ...)}
	ISContextMenu.addSubMenu = oldaddSubMenu
	local playerObj = getSpecificPlayer(player)
	local playerInv = playerObj:getInventory()
    -- Metalwork menu injection code end

    local elevatorOption = menu:addOption(getText("ContextMenu_BuildElevator"), worldobjects, ElevatorCraft.onElevator, player,"1");
    local toolTip = ISBlacksmithMenu.addToolTip(elevatorOption, getText("ContextMenu_BuildElevator"), "fixtures_escalators_01_50");

    local hasScrap = true;
    local requiredElectronicsScrap = 4;
    local requiredElectricitySkill = 7;
    local count = ISBlacksmithMenu.getMaterialCount(playerObj, "ElectronicsScrap");
    if count < requiredElectronicsScrap then
        toolTip.description = toolTip.description .. " <LINE> " .. ISBlacksmithMenu.bhs .. getItemNameFromFullType("Base.ElectronicsScrap") .. " " .. count .. "/" .. requiredElectronicsScrap;
        hasScrap = false;
    else
        toolTip.description = toolTip.description .. " <LINE> " .. ISBlacksmithMenu.ghs .. getItemNameFromFullType("Base.ElectronicsScrap") .. " " .. count .. "/" .. requiredElectronicsScrap;
    end
    -- metalPipes, smallMetalSheet, metalSheet, hinge, scrapMetal, torchUse, skill, player, toolTip, metalBar, wire
    local canDo, tooltip = ISBlacksmithMenu.checkMetalWeldingFurnitures(4,2,4,0,3,10,10,playerObj,toolTip, 8);
    if playerObj:getPerkLevel(Perks.Electricity) < requiredElectricitySkill then
        toolTip.description = toolTip.description .. " <LINE> " .. ISBlacksmithMenu.bhs .. getText("IGUI_perks_Electricity") .. " " .. playerObj:getPerkLevel(Perks.Electricity) .. "/" .. requiredElectricitySkill;
        canDo = false;
    else
        toolTip.description = toolTip.description .. " <LINE> " .. ISBlacksmithMenu.ghs .. getText("IGUI_perks_Electricity") .. " " .. playerObj:getPerkLevel(Perks.Electricity) .. "/" .. requiredElectricitySkill ;
    end
    canDo = canDo == true and hasScrap == true;

    if not canDo then elevatorOption.notAvailable = true; end


    -- Metalwork menu code begin
	return unpack(ret)
end


Events.OnFillWorldObjectContextMenu.Add(ISBlacksmithMenu.doBuildMenu)
-- Metalwork menu injection code end












-- function ElevatorCraft.OnFillWorldObjectContextMenu(playerId, context, worldobjects, test)

--     -- Boilerplate to bring this in line with ISBlacksmithMenu
--     if test and ISWorldObjectContextMenu.Test then return true end

--     if getCore():getGameMode()=="LastStand" then
--         return;
--     end

--     if test then return ISWorldObjectContextMenu.setTest() end
--     local playerObj = getSpecificPlayer(playerId)
--     local playerInv = playerObj:getInventory()

--     if playerObj:getVehicle() then return; end

--     local elevatorOption = context:addOption(getText("ContextMenu_BuildElevator"), worldobjects, ElevatorCraft.onElevator, playerId,"1");
--     local toolTip = ISBlacksmithMenu.addToolTip(elevatorOption, getText("ContextMenu_BuildElevator"), "fixtures_escalators_01_50");

--     -- local canDo, toolTip = ISBlacksmithMenu.checkMetalWeldingFurnitures(4,2,4,0,3,10,9,playerObj,toolTip, 8);
--     -- local canDo, toolTip = checkElevatorCraftingMaterials(playerObj, toolTip);

--     local hasScrap = true;
--     local requiredElectronicsScrap = 4;
--     local requiredElectricitySkill = 7;
--     local count = ISBlacksmithMenu.getMaterialCount(playerObj, "ElectronicsScrap");
--     if count < requiredElectronicsScrap then
--         toolTip.description = toolTip.description .. " <LINE> " .. ISBlacksmithMenu.bhs .. getItemNameFromFullType("Base.ElectronicsScrap") .. " " .. count .. "/" .. requiredElectronicsScrap;
--         hasScrap = false;
--     else
--         toolTip.description = toolTip.description .. " <LINE> " .. ISBlacksmithMenu.ghs .. getItemNameFromFullType("Base.ElectronicsScrap") .. " " .. count .. "/" .. requiredElectronicsScrap;
--     end
--     -- metalPipes, smallMetalSheet, metalSheet, hinge, scrapMetal, torchUse, skill, player, toolTip, metalBar, wire
--     local canDo, tooltip = ISBlacksmithMenu.checkMetalWeldingFurnitures(4,2,4,0,3,10,10,playerObj,toolTip, 8);
--     if playerObj:getPerkLevel(Perks.Electricity) < requiredElectricitySkill then
--         toolTip.description = toolTip.description .. " <LINE> " .. ISBlacksmithMenu.bhs .. getText("IGUI_perks_Electricity") .. " " .. playerObj:getPerkLevel(Perks.Electricity) .. "/" .. requiredElectricitySkill;
--         canDo = false;
--     else
--         toolTip.description = toolTip.description .. " <LINE> " .. ISBlacksmithMenu.ghs .. getText("IGUI_perks_Electricity") .. " " .. playerObj:getPerkLevel(Perks.Electricity) .. "/" .. requiredElectricitySkill ;
--     end
--     canDo = canDo == true and hasScrap == true;

--     if not canDo then elevatorOption.notAvailable = true; end

-- end