local elevatorStrings = {
	"fixtures_escalators_01_48",
	"fixtures_escalators_01_49",
	"fixtures_escalators_01_50",
	"fixtures_escalators_01_51",
	"fixtures_escalators_01_56",
	"fixtures_escalators_01_57"
};

function SquareHasElevator(square)
	if square ~= nil then
		for i=0,square:getObjects():size()-1 do
			local spriteName = square:getObjects():get(i):getSprite():getName();
			for _,elevatorString in ipairs(elevatorStrings) do
				if spriteName == elevatorString then
					return true;
				end
			end
		end
	end
	return false;
end

function FindElevatorExit(x, y, z, xmod, ymod)
	local cell = getCell();
	-- First check if there is an elevator directly above or below
	if SquareHasElevator(cell:getGridSquare(x, y, z)) then
		return x - xmod, y - ymod, z;
	end
	-- Otherwise check for an exit in the direction we entered the elevator
	for steps=5,1,-1 do
		if SquareHasElevator(cell:getGridSquare(x + steps * xmod, y + steps * ymod, z)) then
			return x + steps * xmod + xmod, y + steps * ymod + ymod, z;
		end
	end
	return nil;
end

function GetElevatorFacing(player, square, x, y)
	-- Return the x or y direction by which we would "enter" the elevator.
	local xmod = 0;
	local ymod = 0;
	if square:getWall(true) then
		if y > player:getSquare():getY() then
			ymod = 1;
		else
			ymod = -1;
		end
	else
		if x > player:getSquare():getX() then
			xmod = 1;
		else
			xmod = -1;
		end
	end
	return xmod, ymod
end

function AddElevatorSubMenu(player, context, square)
	local elevatorOption = context:addOption("Use Elevator", worldobjects);
	local subMenu = ISContextMenu:getNew(context);
	local x = square:getX();
	local y = square:getY();
	local z = square:getZ();
	xmod, ymod = GetElevatorFacing(player, square, x, y);
	context:addSubMenu(elevatorOption, subMenu);
	for zi=0,6 do
		if zi ~= z then
			local level = (zi == 0 and "Ground Level") or ("Level " .. zi);
			xi, yi, _ = FindElevatorExit(x, y, zi, xmod, ymod);
			if xi ~= nil then
				subMenu:addOption(level, nil, ProjectElevator.UseElevator, player, 250, xi, yi, zi);
			end
		end
	end
end

function ElevatorFloorObjectMenu(player, square, context)
	if(square ~= nil) then
		if((SandboxVars.ElecShutModifier > -1 and GameTime:getInstance():getNightsSurvived() < SandboxVars.ElecShutModifier) or player:getSquare():haveElectricity()) then
			if SquareHasElevator(square) then
				AddElevatorSubMenu(player, context, square);
				return true
			end
		end
	end
	return false
end

function CheckForElevatorTile(player, context, worldobjects, test)
	local player = getSpecificPlayer(player);
	local square = player:getCurrentSquare();
	if not ElevatorFloorObjectMenu(player, square, context) then
		square = square:getTileInDirection(player:getDir());
		if square then
			ElevatorFloorObjectMenu(player, square, context);
		end
	end
end

Events.OnFillWorldObjectContextMenu.Add(CheckForElevatorTile)
