require "/Collections/Deque.lua"

function Order()
  local self = {}

  local _queuedRequests = Deque()
  local _currentRequest = nil;

  function self.QueueRequest(request)
    _queuedRequests.PushEnd(request);
    script.setUpdateDelta(1);
  end
  
  function self.RequestDone()
    _currentRequest = nil;
  end
  function self.GetCurrentRequest()
    return _currentRequest;
  end
  function self.AnyRequestQueued()
    return _queuedRequests.Any();
  end
  function self.TakeNewRequest()
    if _currentRequest ~= nil then
      error("Current request not done.");
    end
    if _queuedRequests.Any() then
      _currentRequest = _queuedRequests.PopBegin()
      return _currentRequest;
    end
    return nil;
  end
  function self.AnyRequestToProcess()
    if self.GetCurrentRequest() == nil then
      if self.AnyRequestQueued() == false then
        return false;
      end
    end
    return true;
  end
  return self;
end

function GenerateOrderRequest(order, sourceId, additionalData)
  local self ={
    Order = order,
    SourceId = sourceId,
    AdditionalData = additionalData or {}
  }; 
  return self;
end