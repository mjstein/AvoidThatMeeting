local class = require 'libs/middleclass'
local display = {}
local MainDisplay=class('MainDisplay')

function MainDisplay:initialize(borderWidth)
  self.borderWidth = borderWidth
end

function MainDisplay:formTopBanner(meetings,score,health,maxHealth)
  font = love.graphics.newFont(13)
  love.graphics.setFont(font)
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("Meetings: " .. meetings .. " Score: " .. score .. " Health: " .. health .. "/" .. maxHealth,0,0)
end

function MainDisplay:formMainDisplay()
  love.graphics.setColor(186, 255, 255)
  background = love.graphics.rectangle("fill", 0, self.borderWidth, love.graphics.getWidth(), love.graphics.getHeight()-self.borderWidth*2)
end

function MainDisplay:formBottomBanner(meetings)
  font = love.graphics.newFont(13)
  love.graphics.setFont(font)
  love.graphics.setColor(255, 255, 255)
  if meetings == 0 then
    love.graphics.print("Begin your day ...", 10,love.graphics.getHeight()-20)
  elseif  meetings >=1 and meetings <3 then
    love.graphics.print("Well ... it could be worse ...", 10,love.graphics.getHeight()-20)
  elseif  meetings >=3 and meetings <5 then
    love.graphics.print("Arghh the pain ...", 10,love.graphics.getHeight()-20)
  elseif  meetings >=5 and meetings <7 then
    love.graphics.print("Well there goes the day ...", 10,love.graphics.getHeight()-20)
  else
    love.graphics.print("Whoops, there goes the project deadline ...", 10,love.graphics.getHeight()-20)
  end
end
function display.getDisplay(meetings,score,health, maxHealth)
  mainDisplay=MainDisplay:new(20)
  mainDisplay:formTopBanner(meetings,score,health,maxHealth)
  mainDisplay:formMainDisplay(meetings)
end

return display
