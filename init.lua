registerForEvent("onInit", function()
  CPS = require("CPStyling")
  PresetSystem = require("PresetSystem")
  UISystem = require("UISystem")
  wWidth, wHeight = GetDisplayResolution()
end)

registerForEvent("onDraw", function()

  if drawWindow then
    ImGui.SetNextWindowPos(wWidth/2, wHeight/2, ImGuiCond.FirstUseEver)
    CPS.setThemeBegin()
    ImGui.Begin("Character Preset Loader", ImGuiWindowFlags.NoResize | ImGuiWindowFlags.AlwaysAutoResize)
    CPS.setFrameThemeBegin()
    UISystem.DropDown()
    UISystem.LoadButton()
    ImGui.SameLine()
    UISystem.SaveButton()
    CPS.setFrameThemeEnd()
    UISystem.SavePopup()
    ImGui.End()
    CPS.setThemeEnd()
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
