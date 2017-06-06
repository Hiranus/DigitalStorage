require "/Classes/Network.lua"
require "/scripts/AdditionalFunctions.lua"
require "/LuaExtension/tableEx.lua"
local _connectedControllers = {};
local _hasSingleController = false;



function onNodeConnectionChange()
  for i,v in pairs(_connectedControllers) do
    world.callScriptedEntity(v, "onNodeConnectionChange");
  end
end
function UpdateMachineStatus()
  if GetTableSize(_connectedControllers) == 1 then
    _hasSingleController = true;
  else
    _hasSingleController = false;
  end
end
function AddController(id)
  table.insert(_connectedControllers,id);
  UpdateMachineStatus();
end
function RemoveController(id)
  RemoveTableValue(_connectedControllers,id);
  UpdateMachineStatus();
end


function init()
  
end

function uninit()
  
end

function update()
  
end
