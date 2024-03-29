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

local PresetSystem = require("PresetSystem")
local FileSystem = require("FileSystem")
local CPS = GetMod("CPStyling"):New()
local theme = CPS.theme
local color = CPS.color
local UISystem = {
  CPS = CPS,
  CBPresetIndex = -1,
  CBPresetClicked = false,
  SaveFileName = "",
  Author = "",
  Version = "",
  Description = "",
  SaveState = 0,
  PopupButtonWidth = ImGui.CalcTextSize("Cancel")+20,
  WindowButtonWidth = ImGui.CalcTextSize("Save")+20,
}
UISystem.PresetFiles, UISystem.PresetCount = FileSystem.GetFileList("presets/")

function UISystem.Refresh()
  UISystem.PresetFiles, UISystem.PresetCount = FileSystem.GetFileList("presets/")
end

function UISystem.DropDown()
  UISystem.CBPresetIndex, UISystem.CBPresetClicked = ImGui.Combo("Preset", UISystem.CBPresetIndex, FileSystem.FormatFileList(UISystem.PresetFiles), UISystem.PresetCount)
  if ImGui.IsItemClicked() then
    UISystem.Refresh()
  end
end

function UISystem.LoadButton()
  if CPS:CPButton("Load", UISystem.WindowButtonWidth, 0) and UISystem.CBPresetIndex ~= -1 then
    PresetSystem.LoadPreset(UISystem.PresetFiles[UISystem.CBPresetIndex+1])
  end
end

function UISystem.SaveButton()
  if CPS:CPButton("Save", UISystem.WindowButtonWidth, 0) then
    ImGui.OpenPopup("Save Preset")
  end
end

function UISystem.SavePopup()
  if ImGui.BeginPopupModal("Save Preset", true, ImGuiWindowFlags.AlwaysAutoResize) then
    CPS:setFrameThemeBegin()
    if UISystem.SaveState ~= 2 then
      UISystem.SaveFileName = ImGui.InputTextWithHint("Preset Name", "Enter a file name...", UISystem.SaveFileName, 50)
      if UISystem.SaveState == 3 then
        ImGui.TextColored(theme.CPButtonText[1], theme.CPButtonText[2], theme.CPButtonText[3], theme.CPButtonText[4], "A file name can't contain:\n\\ / : * ? \" < > |")
      end
      ImGui.Spacing()
      if CPS:CPButton("Save", UISystem.PopupButtonWidth, 0) and UISystem.SaveFileName ~= "" then
        UISystem.SaveState = PresetSystem.SavePreset(UISystem.SaveFileName..".preset")
        if UISystem.SaveState == 1 then
          UISystem.SaveFileName = ""
          UISystem.SaveState = 0
          ImGui.CloseCurrentPopup()
        end
      end
      ImGui.SameLine()
      if CPS:CPButton("Cancel", UISystem.PopupButtonWidth, 0) then
        UISystem.SaveFileName = ""
        UISystem.SaveState = 0
        ImGui.CloseCurrentPopup()
      end
    else
      ImGui.TextColored(theme.CPButtonText[1], theme.CPButtonText[2], theme.CPButtonText[3], theme.CPButtonText[4], UISystem.SaveFileName..[[ already exists, do you want to overwrite it?]])
      ImGui.Spacing()
      if CPS:CPButton("Yes", UISystem.PopupButtonWidth, 0) then
        PresetSystem.SavePreset(UISystem.SaveFileName..".preset", true)
        UISystem.SaveFileName = ""
        UISystem.SaveState = 0
        ImGui.CloseCurrentPopup()
      end
      ImGui.SameLine()
      if CPS:CPButton("No", UISystem.PopupButtonWidth, 0) then
        UISystem.SaveState = 0
      end
    end
    CPS:setFrameThemeEnd()
    ImGui.EndPopup()
  end
end

return UISystem
