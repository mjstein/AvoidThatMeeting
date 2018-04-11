local class = require 'libs/middleclass'
Torpedo=class('Torpedo')
Torpedo.static.image = love.graphics.newImage("resources/images/torpedo.png")

function Torpedo:initialize(xPos,yPos,speed)
  self.xPos = xPos
  self.yPos = yPos
  self.speed = speed
  self.width = 16
  self.height= 16
  self.img = Torpedo.static.image
  self.torpedoMaxSpeed = 600
end
