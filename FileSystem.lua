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
