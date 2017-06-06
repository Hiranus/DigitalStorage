require "/Classes/Controller.lua"
local _controller = Controller();

local function SetAnimationWorking()
  if animator.animationState("digitalstorage_controllerState") ~= "working" then
    animator.setAnimationState("digitalstorage_controllerState", "working");
  end
end

function onNodeConnectionChange()
  SetAnimationWorking();
  _controller.ConnectionChange();
end

function init()
  
  SetAnimationWorking();
  script.setUpdateDelta(1);
end

function update()
  SetAnimationWorking();
  if not _controller.ControllerInitalized() then
    _controller.InitalizeStep();
    return;
  end
  if not _controller.SingleControllerInNetwork() then
    animator.setAnimationState("digitalstorage_controllerState", "failure");
    script.setUpdateDelta(0);
    return;
  end
  if _controller.AnyRequestToProcess() == false then
    animator.setAnimationState("digitalstorage_controllerState", "idle");
    script.setUpdateDelta(0);
  end
  SetAnimationWorking();
  _controller.ProcessRequest();
end


function QueueNewRequest(request)
  _controller.QueueNewRequest(request);
end












