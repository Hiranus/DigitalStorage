require "/Classes/Network.lua"
require "/scripts/AdditionalFunctions.lua"
require "/LuaExtension/tableEx.lua"
require "/Scripts/HelperScripts.lua"
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

function SingleController()
  return _hasSingleController;
end

function update()
  LogDebug("digitalstorage_terminal.lua update");
  LogDebug(entity.id());
  script.setUpdateDelta(0);
end

function init()
  LogDebug("digitalstorage_terminal.lua init");
  message.setHandler("GetTerminalController", SingleController);
  --script.setUpdateDelta(5);
end

function containerCallback()
  LogDebug("digitalstorage_terminal.lua containerCallback");
end

function onInteraction(args)
  LogDebug("digitalstorage_terminal.lua onInteraction");
end
function uninit()
  LogDebug("digitalstorage_terminal.lua uninit");
end