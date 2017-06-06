require "/Scripts/HelperScripts.lua"


function containerCallback()
  LogDebug("digitalstorage_terminalGUI.lua containerCallback");
end

function onInteraction(args)
  LogDebug("digitalstorage_terminalGUI.lua onInteraction");
end
function uninit()
  LogDebug("digitalstorage_terminalGUI.lua uninit");
end
function init()
  local entityId = pane.containerEntityId();
  LogDebug(entityId);
  if world.callScriptedEntity(entityId, "SingleController") then
    LogDebug("SingleTerm");
    script.setUpdateDelta(5);
  else
    LogDebug("MultiTerm");

  end
  LogDebug("digitalstorage_terminalGUI.lua init");
end
function CustomCall()
  LogDebug("digitalstorage_terminalGUI.lua CustomCall");
end

function update()
  LogDebug("digitalstorage_terminalGUI.lua update");
end
function buy()
  LogDebug("digitalstorage_terminalGUI.lua buy");
end

function sell()
  LogDebug("digitalstorage_terminalGUI.lua sell");
end