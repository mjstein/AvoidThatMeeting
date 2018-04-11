display = require 'libs/display/display'
require 'libs/entities/player'
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
playerSpeed=100

love.window.setTitle( "Avoid That Meeting!" )
startGame()
end

function startGame()
  Player.initializePlayer(images.submarineImage,100,playerSpeed)
end

function love.draw()
  display.getDisplay(0,0,0,100)
  Player.drawPlayer()
  Player.drawTorpedos()
end

function love.update(dt)
  player = Player.getPlayer()
  player:updatePlayer(dt)
  player:updateTorpedoes(dt)
end
