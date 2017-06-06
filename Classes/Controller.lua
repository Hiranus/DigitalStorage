require "/scripts/AdditionalFunctions.lua"
require "/Scripts/HelperScripts.lua"
require "/Classes/Network.lua"
require "/Classes/NetworkWalker.lua"
require "/Classes/Order.lua"

function Controller()
  local self = {

  };

  local _orders = Order();
  local _controllerId =  nil;
  local _networkWalker = nil;
  local _network = nil;
  local _controllerCoreInitalizad = false;
  local _singleControllerDetected = true;
  local _networkState = nil;
  local _networkInfoPropagator = nil;

  local function initalize()
    if not _controllerCoreInitalizad then
      _controllerId =  entity.id();
      _controllerCoreInitalizad = true;
      _network = Network();
      self.ConnectionChange();
    end
  end

  function self.ConnectionChange()

    local name = world.getObjectParameter(_controllerId, "objectName");
    local position = world.entityPosition(_controllerId);
    _networkInfoPropagator = nil;
    _networkState = "Uninitalized";
    _networkWalker = NetworkWalker({Name = name, Id = _controllerId, Position = position});
    script.setUpdateDelta(1);

  end

  function self.InitalizeStep()
    --LogDebug(to_string(_networkState));
    initalize();
    if _networkState ~= "FullyInitalized" then
      if _networkState == "Uninitalized" then

        if _networkWalker.ReturnWalkerStatus() then
          _networkWalker.ResumeWalker();
          return;
        end

        _networkState = "NetworkWalked";
        return;
      elseif _networkState == "NetworkWalked" then
        if _networkInfoPropagator == nil then
          _networkInfoPropagator = UpdateNetworkPartControllerInfo(_network,"RemoveController",_controllerId);
        end
        if _networkInfoPropagator.GetStatus() then
          _networkInfoPropagator.Resume()
          return;
        end
        _networkState = "OldControllerInfoRemoved";
        return;
      elseif _networkState == "OldControllerInfoRemoved" then

        _network = Network(_networkWalker.GetNetworkElements());
        _networkInfoPropagator = nil;
        _networkState = "NewControllerInfoInstalled";
        return;
      elseif _networkState == "NewControllerInfoInstalled" then
        if _networkInfoPropagator == nil then
          _networkInfoPropagator = UpdateNetworkPartControllerInfo(_network,"AddController",_controllerId);
        end
        if _networkInfoPropagator.GetStatus() then
          _networkInfoPropagator.Resume()
          return;
        end
        --LogDebug(to_string(_network["IndexedNetwork"]));
        if GetTableSize(_network["NetworkOriginal"]["digitalstorage_controller"]) ~= 1 then
          _singleControllerDetected = false;
          --More than one controller connected to network
        else
          _singleControllerDetected = true;
        end

        --script.setUpdateDelta(0);
        _networkState = "FullyInitalized";
      end

    end
  end

  function self.ControllerInitalized()
    return _networkState == "FullyInitalized";
  end

  function self.SingleControllerInNetwork()
    return _singleControllerDetected;
  end

  function self.QueueNewRequest(request)
    _orders.QueueRequest(request);
  end

  function self.AnyRequestToProcess()
    return _orders.AnyRequestToProcess();
  end





  function self.ProcessRequest()
    if _orders.GetCurrentRequest() == nil then
      if _orders.AnyRequestQueued() then
        _orders.TakeNewRequest();
      else
        return;
      end
    end
    if _orders.GetCurrentRequest().Order == "DisplayAllItems" then
      LogDebug("DisplayAllItems");
      _orders.RequestDone();
    end
  end


  return self;
end