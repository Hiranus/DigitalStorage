require "/Scripts/HelperScripts.lua"
require "/Classes/Item.lua"


local function DescriptionGenerator(driveItem)
  return driveItem.ItemConfig.config.digitalstorage_drivedata.description .. "\nItems stored: ".. driveItem.ItemData.parameters.ItemCount .." / " .. driveItem.ItemConfig.config.digitalstorage_drivedata.capacity .. "\nItem types: ".. driveItem.ItemData.parameters.ItemTypes .." / 64" ;
end

function Drive(item)
  local _driveItem = Item(item);
  
  if not _driveItem then
    return;
  elseif not _driveItem.ItemConfig.config.digitalstorage_drivedata then
    return;
  end
  
  local self = {};
  local wasinit = false;
  local _driveStoredItems = nil;
  local _driveItemsLoaded = false;

  function self.ResetUUID()
    _driveItem.ItemData.parameters.Uuid = sb.makeUuid();
  end


  function self.GetDrive()
    return _driveItem.ItemData;
  end

  function self.GetItemTypes()
    return _driveItem.ItemData.parameters.ItemTypes;
  end

  function self.GetItemCount()
    return _driveItem.ItemData.parameters.ItemCount;
  end

  function self.LoadItems()
    _driveStoredItems = {};
    for i,v in pairs(_driveItem.ItemData.Data) do
      table.insert( _driveStoredItems , Item(v));
    end
    _driveItemsLoaded= true;
  end
  function self.GetItems()
    return { Items = _driveStoredItems, ItemCount = _driveItem.ItemData.parameters.ItemCount, ItemTypes = _driveItem.ItemData.parameters.ItemTypes};
  end

  function self.ItemsLoaded()
    return _driveItemsLoaded;
  end

  function self.SaveItems()
    _driveItem.ItemData.Data={};
    for i,v in pairs(_driveStoredItems) do
      table.insert(_driveItem.ItemData.Data,v.ItemData);
    end
  end
  
  function self.UpdateDriveCounts()
    local itemCount = 0;
    local itemTypes = 0;
    for i,v in pairs(_driveItem.ItemData.Data) do
      itemTypes = itemTypes + 1;
      itemCount = itemCount + v.count;
    end
    _driveItem.ItemData.parameters.ItemCount = itemCount;
    _driveItem.ItemData.parameters.ItemTypes = itemTypes;
  end
  
  function self.UpdateDriveDescription()
    self.UpdateDriveCounts();
    _driveItem.ItemData.parameters.description = DescriptionGenerator(_driveItem)
  end

  if _driveItem.ItemData.parameters.DriveFormatted == nil then
    wasinit = true;
    _driveStoredItems = {};
    _driveItem.ItemData.Data = {};
    _driveItem.ItemData.itemConfig = itemConfigData;
    _driveItem.ItemData.parameters = {
      ItemCount = 0;
      ItemTypes = 0;
      DriveFormatted = true;
      Uuid = sb.makeUuid()
    };
    self.UpdateDriveDescription();
  end
  return self, wasinit;
end
