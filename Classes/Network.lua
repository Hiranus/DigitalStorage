require "/Scripts/HelperScripts.lua"
require "/scripts/AdditionalFunctions.lua"
require "/LuaExtension/tableEx.lua"
require "/Config/Config.lua"
function Network(network)
  network = network or {};
  local self = {
    NetworkOriginal = network;
    IndexedNetwork = {};
  };

  for i1,v1 in pairs(network) do
    local tab = { Name = i1, Machines = {}};
    for i2,v2 in pairs(v1) do
      table.insert(tab["Machines"],v2);
    end
    table.insert(self.IndexedNetwork,tab);
  end

  return self;
end

local function GetNeighboursInt(machines,data)
  for i,v in pairs(data) do
    if world.getObjectParameter(i, "DigitalStorageNetworkPart") then
      local name = world.getObjectParameter(i, "objectName");
      local position = world.entityPosition(i);
      GenerateChildTables(machines,name,i)
      machines[name][i] = {Name = name, Id = i, Position = position};
    end
  end
end

function GetNeighbours()
  local dsMachines = {};
  if object.outputNodeCount() ~= 0 then
    local outConns = object.getOutputNodeIds(0);
    GetNeighboursInt(dsMachines,outConns);
  end
  if object.inputNodeCount() ~= 0 then
    local inConns = object.getInputNodeIds(0);
    GetNeighboursInt(dsMachines,inConns);
  end
  return dsMachines;
end

function UpdateNetworkPartControllerInfo(network,method,controllerId)
  local self = 
  {
    IsInitalized = false;
  };
  if method == nil then
    return self;
  end

  local _componentIndex = 1;
  local _machineIndex = 1;
  local _method = method;
  local _controllerId = controllerId;
  local _needsContinue = true;
  local _network = network["IndexedNetwork"];

  --local _componentMaxIndex = GetTableSize(_network);
  --local _machineMaxIndex = GetTableSize(_network[_componentIndex]["Machines"]);


  function self.Resume()
    local operationIndex = 0;
    while _network[_componentIndex] do
      if _network[_componentIndex]["Name"] ~= "digitalstorage_controller" then
        while _network[_componentIndex]["Machines"][_machineIndex] do
          world.callScriptedEntity(_network[_componentIndex]["Machines"][_machineIndex]["Id"], _method,_controllerId);
          _machineIndex = _machineIndex + 1;
          operationIndex = operationIndex + 1;
          if operationIndex > ControllerUpdateLimitPerUpdate then
            return;
          end
        end
      end
      _componentIndex = _componentIndex + 1;
      _machineIndex = 1;
    end
    _needsContinue = false;
  end

  function self.GetStatus()
    return _needsContinue;
  end
  return self;
end
