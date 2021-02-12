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

local FileSystem = {}

function FileSystem.CheckFileName(fileName)
  local filter = string.find(fileName, "/") or string.find(fileName, "\\") or string.find(fileName, "\"") or string.find(fileName, ">") or string.find(fileName, "<") or string.find(fileName, "*") or string.find(fileName, "?") or string.find(fileName, ":") or string.find(fileName, "|")
  if filter then
    return false
  else
    return true
  end
end

function FileSystem.FileExists(filename)
   local file=io.open(filename,"r")
   if file ~= nil then file:close() return true else return false end
end

function FileSystem.GetFileList(directory)
  local list = dir(directory)
  local filelist = {}
  for _,v in ipairs(list) do
    if v.type == "file" then
      table.insert(filelist, v.name)
    end
  end
  return filelist, #filelist
end

function FileSystem.FormatFileName(filename)
  local filename = string.gsub(filename, ".preset$", "")
  if string.find(filename, "_") then
    return string.gsub(" "..string.gsub(filename, "_" , " "), "%W%l", string.upper):sub(2)
  elseif string.find(filename, "-") then
    return string.gsub(" "..string.gsub(filename, "-" , " "), "%W%l", string.upper):sub(2)
  else
    return string.gsub(" "..filename, "%W%l", string.upper):sub(2)
  end
end

function FileSystem.FormatFileList(filelist)
  local namelist = {}
  for _,v in ipairs(filelist) do
    table.insert(namelist, FileSystem.FormatFileName(v))
  end
  return namelist
end

function FileSystem.ReadJSON(filename)
  local file = io.open(filename, "r")
  local tbl = json.decode(file:read("*a"))
  file:close()
  return tbl
end

function FileSystem.WriteJSON(filename, tbl)
  local file = io.open(filename, "w")
  file:write(json.encode(tbl))
  file:close()
end

return FileSystem
