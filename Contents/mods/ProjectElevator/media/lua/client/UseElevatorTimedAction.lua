
ProjectElevator = {};

ProjectElevator.UseElevator = function(item, player, time, x, y, z)
   ISTimedActionQueue.add(UseElevatorAction:new(player:getPlayerNum(), item, time, x, y, z));
end

require "TimedActions/ISBaseTimedAction"

UseElevatorAction = ISBaseTimedAction:derive("UseElevatorAction");

 
function UseElevatorAction:isValid()
	return true;
end

function UseElevatorAction:update()
end

function UseElevatorAction:start()
	self.sound = self.character:getEmitter():playSound("ElevatorSound")
	local directionToGo = self.character:getCurrentSquare():getZ() < self.z and "up" or "down";
	self.character:Say("Going " .. directionToGo);
end

function UseElevatorAction:stop()
	if self.sound then
		self.character:getEmitter():stopSound(self.sound)
		self.sound = nil
	end
	ISBaseTimedAction.stop(self);
end

function UseElevatorAction:perform()
	self.character:setX(self.x)
	self.character:setLx(self.x);
	self.character:setY(self.y)
	self.character:setLy(self.y);
	self.character:setZ(self.z)
	self.character:setLz(self.z);
	ISBaseTimedAction.perform(self);
end

function UseElevatorAction:new(character, pie, time, x, y, z)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = getSpecificPlayer(character);
	o.x = x
	o.y = y
	o.z = z
	o.stopOnWalk = true;
	o.stopOnRun = true;
	o.maxTime = time;
	return o;
end
