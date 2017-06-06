require "/LuaExtension/tableEx.lua"
require "/scripts/util.lua"

function GenerateNameForItem (item)
  if item.parameters ~= nil then
    if item.parameters.shortdescription ~= nil then
      return item.parameters.shortdescription;

    end
  end

  local generatedData = root.itemConfig(item);
  if generatedData.config ~= nil then
    if generatedData.config.shortdescription ~= nil then
      return generatedData.config.shortdescription;

    end
  end
  if generatedData.parameters ~= nil then
    if generatedData.parameters.shortdescription ~= nil then
      return generatedData.parameters.shortdescription;

    end
  end
  return "Unknown Name";
end



function Item(item)
  if item == nil then
    return nil;
  end
  --LogDebug(to_string(root.itemConfig("sgeredgggggg")));
  local self = {
    ItemData = item,
    ItemConfig = root.itemConfig(item.name),
    ItemName = GenerateNameForItem (item),
    ItemImagePartial = nil,
    ItemImage = nil
  };
  self.ItemImagePartial = self.ItemData.parameters.inventoryIcon or self.ItemConfig.config.inventoryIcon;
  self.ItemImage = util.absolutePath(self.ItemConfig.directory, self.ItemImagePartial);

  function CopyItem()
   return table.deepcopy(self.ItemData);
end


  function self.GetItem(count)
    if count then
      local tmpItem = table.deepcopy(self.ItemData);
      self.ItemData.count = self.ItemData.count - count;
      tmpItem.count = count;
      return tmpItem;
    else
      return self.ItemData;
    end
  end

  function self.GetItemCount()
    return self.ItemData.count;
  end
  function self.SetItemCount(count)
    self.ItemData.count = count;
  end
  function self.AddItemCount(count)
    self.ItemData.count = self.ItemData.count + count;
  end

  function self.ShallowCompare (itemObj)
    if self.ItemData.name ~= itemObj.ItemData.name then
      return false;
    end
    if self.ItemName ~= itemObj.ItemName then
      return false;
    end
    if self.ItemImage ~= itemObj.ItemImage then
      return false;
    end
    return true;

  end

  function self.DeepCompare (itemObj)
    return table_eq(self.ItemData, itemObj.ItemData);
  end


  return self;
end