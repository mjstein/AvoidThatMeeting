display = require 'libs/display/display'
local class = require 'libs/middleclass'
function love.load()
images = {
  submarineImage = love.graphics.newImage("resources/images/submarine.png"),
  torpedoImage = love.graphics.newImage("resources/images/torpedo.png"),
  wattonImage = love.graphics.newImage("resources/images/watton.jpeg"),
  jeffImage = love.graphics.newImage("resources/images/jeffsmall.jpeg"),
  alexImage = love.graphics.newImage("resources/images/alex.jpeg"),
  adrianImage = love.graphics.newImage("resources/images/aj.jpeg"),
}
end

function love.draw()
  display.getDisplay(0,0,0,100)
end

function love.update(dt)
end
