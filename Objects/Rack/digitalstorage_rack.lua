require "/Scripts/HelperScripts.lua"
require "/Classes/Network.lua"
require "/scripts/AdditionalFunctions.lua"
require "/LuaExtension/tableEx.lua"
require "/Classes/Order.lua"
require "/Classes/Drive.lua"
require "/Classes/Rack.lua"

local _connectedControllers = {};
local _orders = Order();
local _hasSingleController = false;
local _rack = Rack();


function onNodeConnectionChange()
  for i,v in pairs(_connectedControllers) do
    world.callScriptedEntity(v, "onNodeConnectionChange");
  end

end
function UpdateMachineStatus()
  if GetTableSize(_connectedControllers) == 1 then
    _hasSingleController = true;
    animator.setAnimationState("digitalstorage_rackState", "on");
  else
    _hasSingleController = false;
    animator.setAnimationState("digitalstorage_rackState", "off");
  end
end
function AddController(id)
  LogDebug("AddController");
  table.insert(_connectedControllers,id);
  UpdateMachineStatus();
end
function RemoveController(id)
  LogDebug("RemoveController");
  RemoveTableValue(_connectedControllers,id);
  UpdateMachineStatus();
end


function init()
  
end

function uninit()
  _rack.SaveDrives();
end

function update()




  --[[
  if _orders.GetCurrentRequest() == nil then
    if _orders.AnyRequestQueued() then
      _orders.TakeNewRequest();
      if _orders.GetCurrentRequest().Order == "LoadDrivesData" then
        _orders.GetCurrentRequest().AdditionalData.CurrentDrive = 0;
      elseif false then
      end
      return;
    else
      script.setUpdateDelta(0);
      return;
    end
  else
    if _orders.GetCurrentRequest().Order == "LoadDrivesData" then
      local drive = world.containerItemAt(entity.id(), _orders.GetCurrentRequest().AdditionalData.CurrentDrive);
      LogDebug("LoadDrivesData");
      ---load Drive Data

      _orders.GetCurrentRequest().AdditionalData.CurrentDrive = _orders.GetCurrentRequest().AdditionalData.CurrentDrive+1;
      if _orders.GetCurrentRequest().AdditionalData.CurrentDrive == 20 then
        _orders.RequestDone();
      end
      return;
    elseif false then
      
    end
  end
  --]]
end





function containerCallback()
  LogDebug("containerCallback Rack");
  local drives = {};
  for i=0,20 do
    local item = world.containerItemAt(entity.id(), i);
    if item then
      local drive,wasInit = Drive(item);
      if drive then
        
        drives[i] = {Drive = drive, WasInit = wasInit, Offset = i};
        
      else
        LogDebug(to_string(item));
        world.containerConsumeAt(entity.id(), i, item.count)
        local pos = entity.position();
        pos[2] = pos[2] + 2;
        world.spawnItem(item, pos)
      end
    end
  end
  _rack.UpdateDriveList(drives);
end




