local PresetSystem = {}

local FileSystem = require("FileSystem")

function PresetSystem.LoadPreset(filename)
  local filename = "presets/"..filename
  local tbl = FileSystem.ReadJSON(filename)
  local preset = tbl.preset
  local characterCustomizationSystem = Game.GetCharacterCustomizationSystem()
  local options = characterCustomizationSystem:GetUnitedOptions(true, true, true, ToCName{}, ToCName{}, ToCName{})
  for k, v in pairs(options) do
    characterCustomizationSystem:ApplyChangeToOption(v, preset[k])
  end
  return true
end

function PresetSystem.SavePreset(filename, overwrite)
  if FileSystem.CheckFileName(filename) then
    local filename = "presets/"..filename
    if (not FileSystem.FileExists(filename)) or overwrite then
      local tbl = {}
      tbl.preset = {}
      local characterCustomizationSystem = Game.GetCharacterCustomizationSystem()
      local options = characterCustomizationSystem:GetUnitedOptions(true, true, true, ToCName{}, ToCName{}, ToCName{})
      for k,v in pairs(options) do
        table.insert(tbl.preset, v.currIndex)
      end
      FileSystem.WriteJSON(filename, tbl)
      return 1
    else
      return 2
    end
  else
    return 3
  end
end

function PresetSystem.IsInCharacterCustomization()
  if next(Game.GetCharacterCustomizationSystem():GetArmsOptions(ToCName{})) then
    return true
  else
    return false
  end
end

return PresetSystem
