--[[
  Copyright 2016 Joshua Musselwhite, Whizzbang Inc

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
--]]


local LrSystemInfo = import 'LrSystemInfo'
local LrFunctionContext = import 'LrFunctionContext'
local LrApplication = import 'LrApplication'
local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'
local LrTasks = import 'LrTasks'
local LrFileUtils = import 'LrFileUtils'
local LrPathUtils = import 'LrPathUtils'
local LrLogger = import 'LrLogger'
local LrStringUtils = import "LrStringUtils"


local myLogger = LrLogger( 'libraryLogger' )
myLogger:enable( "logfile" )

isDebug = false
isLog = false


function splitToKeyValue(str, delim)
  if str == nill then return nill end
  local index = string.find(str, delim)
  if index == nill then
    return nill
  end
  local r = {}
  r.key = string.sub(str, 0, index-1)
  r.value = string.sub(str, index+1, #str)
  return r
end

function split(str, delim)
  local t = {} ; i=1
  for str in string.gmatch(str, "([^" .. delim .. "]+)") do
    t[i] = str
    i = i + 1
  end
  return t
end

function log(str)
  if (isLog) then
    myLogger:warn(str)
  end
end

function parseDimens(strDimens)
  local index = string.find(strDimens, "x")
  if (index == nill) then return nill end
  local w = string.sub(strDimens, 0, index-1)
  local h = string.sub(strDimens, index+1)
  w = LrStringUtils.trimWhitespace(w)
  h = LrStringUtils.trimWhitespace(h)
  return tonumber(w), tonumber(h)
end


function arrayKeyOf(table, val)
    for k,v in pairs(table) do
      log(k .. " | " .. v .. " | " .. val)
        if v == val then
          return k
        end
    end
    return nil
end

function transformCoordinates(x, y, oX, oY, angle, scaleX, scaleY)
    -- Rotation around 0,0
    local rX = x * math.cos(angle) + y * math.sin(angle)
    local rY = -x * math.sin(angle) + y * math.cos(angle)

    -- Rotation of origin corner
    local roX = oX * math.cos(angle) + oY * math.sin(angle)
    local roY = -oX * math.sin(angle) + oY * math.cos(angle)

    -- Translation so the top left corner become the origin
    local tX = rX - roX
    local tY = rY - roY

    -- Let's resize everything to match the view
    tX = tX * scaleX
    tY = tY * scaleY

    return tX, tY
end
