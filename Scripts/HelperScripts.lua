require "/scripts/AdditionalFunctions.lua"

local DebugLogEnabled = true;


function LogDebug(message)
  if DebugLogEnabled == true then
    sb.logInfo(message);
  end
end