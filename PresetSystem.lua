-- CP77 Character Preset Loader allows user to save and load character presets in-game.
-- Copyright (C) 2021  Mingming Cui
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
