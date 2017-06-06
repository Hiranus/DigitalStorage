require "/Collections/Deque.lua"
require "/scripts/AdditionalFunctions.lua"
require "/Config/Config.lua"
function NetworkWalker (start)
  if start == nil then
    return;
  end

  local self = {
  };

  local _startId = start;
  local _taskUnfinished = true;
  local _foundNetworkElements = {};
  local _queuedElementsToScan = Deque();
  _queuedElementsToScan.PushBegin(_startId);
  GenerateChildTables(_foundNetworkElements,_startId.Name,_startId.Id);
  _foundNetworkElements[_startId.Name][_startId.Id] = _startId;

  function self.ReturnWalkerStatus()
    return _taskUnfinished;
  end

  function self.ResumeWalker()
    local calls = 0;
    while _queuedElementsToScan.PeekBegin() ~= nil do
      calls = calls+1;
      if calls <= NetworkWalkerLimitPerUpdate then
        local _current = _queuedElementsToScan.PopBegin();
        local result = world.callScriptedEntity(_current.Id, "GetNeighbours");
        for i1,v1 in pairs(result) do
          for i2,v2 in pairs(v1) do

            if string.compare(i1,"digitalstorage_router") then
              if not CheckChildTables(_foundNetworkElements,i1,i2) then
                _queuedElementsToScan.PushEnd(v2);
                GenerateChildTables(_foundNetworkElements,i1,i2);
                _foundNetworkElements[i1][i2] = v2;
              end
            else
              GenerateChildTables(_foundNetworkElements,i1,i2);
              _foundNetworkElements[i1][i2] = v2;
            end
          end
        end
      else
        return;
      end
    end
    _taskUnfinished = false;
  end

  function self.GetNetworkElements()
    if _taskUnfinished then
      return;
    end
    return _foundNetworkElements;

  end

  return self;
end


