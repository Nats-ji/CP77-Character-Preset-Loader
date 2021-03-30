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

registerForEvent("onInit", function()
  PresetSystem = require("PresetSystem")
  UISystem = require("UISystem")
  CPS = UISystem.CPS
  wWidth, wHeight = GetDisplayResolution()
end)

registerForEvent("onDraw", function()

  if drawWindow then
    ImGui.SetNextWindowPos(wWidth/2, wHeight/2, ImGuiCond.FirstUseEver)
    CPS:setThemeBegin()
    ImGui.Begin("Character Preset Loader", bit32.bor(ImGuiWindowFlags.NoResize, ImGuiWindowFlags.AlwaysAutoResize))
    CPS:setFrameThemeBegin()
    UISystem.DropDown()
    UISystem.LoadButton()
    ImGui.SameLine()
    UISystem.SaveButton()
    CPS:setFrameThemeEnd()
    UISystem.SavePopup()
    ImGui.End()
    CPS:setThemeEnd()
  end

end)

registerForEvent("onOverlayOpen", function()
  if PresetSystem.IsInCharacterCustomization() then
    drawWindow = true
  end
end)

registerForEvent("onOverlayClose", function()
  drawWindow = false
end)
