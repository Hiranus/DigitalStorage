require "/Classes/Drive.lua"

function Rack()
  local self={};

  local _drives = {};


  function self.AddDrive(drive, offset)
    _drives[offset] = drive;

  end

  function self.RemoveDrive(offset)
    _drives[offset] = nil;
  end

  function self.UpdateDriveList(drives)
    for i,v in pairs(_drives) do
      if drives[i] == nil then
        _drives[i] = nil;
      end
    end

    for i,v in pairs(drives) do
      if _drives[v.Offset] == nil then
        _drives[v.Offset] = v.Drive;
        if v.WasInit then
          self.SaveDrive(v.Offset);
        end

      elseif _drives[v.Offset].GetDrive().parameters.Uuid ~= v.Drive.GetDrive().parameters.Uuid then
        _drives[v.Offset] = nil;
        _drives[v.Offset] = v.Drive;
        if v.WasInit then
          self.SaveDrive(v.Offset);
        end
      end
    end
  end

  function self.SaveDrive(offset)
    if _drives[offset] then
      _drives[offset].SaveItems();
      world.containerConsumeAt(entity.id(), offset,1);
      world.containerPutItemsAt(entity.id(),_drives[offset].GetDrive(), offset);
    end
  end

  function self.LoadItems()
    for i,v in pairs(_drives) do
      v.LoadItems();
    end
  end
  
  function self.GetItems()
    local rackItems = {}
    local rackId = entity.Id();
    for i,v in pairs(_drives) do
      table.insert(_rackItems,{Rack = rackId , DriveOffset = i, DriveData = v.GetItems()});
    end
  end

  function self.SaveDrives()
    for i,v in pairs(_drives) do
      self.SaveDrive(i);
    end
  end


  return self;
end
