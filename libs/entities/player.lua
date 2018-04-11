local class = require 'libs/middleclass'
require 'libs/entities/torpedo'
Player=class('Player')

function Player:initialize(image,health,speed)
  self.img = image
  self.health = health
  self.xPos = 0
  self.yPos = 0
  self.width = 64
  self.height = 64
  self.speed = speed
  self.canFire = true
  self.torpedos = {}
  self.torpedoTimer = 0
  self.torpedoTimerMax = 0.5
end


function Player:updatePlayer(dt)
  down = love.keyboard.isDown("down")
  up = love.keyboard.isDown("up")
  left = love.keyboard.isDown("left")
  right = love.keyboard.isDown("right")

  speed = self.speed
  if((down or up) and (left or right)) then
    speed = speed / math.sqrt(2)
  end
  if down and self.yPos<love.graphics.getHeight()-self.height then
    self.yPos = self.yPos + dt * speed
  elseif up and self.yPos>0 then
    self.yPos = self.yPos - dt * speed
  end

  if right and self.xPos<love.graphics.getWidth()-self.width then
    self.xPos = self.xPos + dt * speed
  elseif left and self.xPos>0 then
    self.xPos = self.xPos - dt * speed
  end

  if love.keyboard.isDown("space") then
    torpedoSpeed = 100
    if(left) then
      torpedoSpeed = torpedoSpeed - self.speed/2
    elseif(right) then
      torpedoSpeed = torpedoSpeed + self.speed/2
    end
    player:spawnTorpedo(self.xPos + self.width, self.yPos + self.height/2, torpedoSpeed)
  end

  if self.torpedoTimer > 0 then
    self.torpedoTimer = self.torpedoTimer - dt
  else
    self.canFire = true
  end
end


function Player:spawnTorpedo(x, y, speed)
  if self.canFire then
    shootSound = love.audio.newSource("resources/audio/Shoot.wav","static")
    shootSound:play()
    --torpedo = {xPos = x, yPos = y, width = 16, height=16, speed=speed, img = torpedoImage}
    torpedo = Torpedo:new(x,y,speed)
    table.insert(self.torpedos, torpedo)

    self.canFire = false
    self.torpedoTimer = self.torpedoTimerMax
  end
end

function Player:updateTorpedoes(dt)
  for i=table.getn(self.torpedos), 1, -1 do
    torpedo = self.torpedos[i]
    torpedo.xPos = torpedo.xPos + dt * torpedo.speed
    if torpedo.speed < torpedo.torpedoMaxSpeed then
      torpedo.speed = torpedo.speed + dt * 100
    end
    if torpedo.xPos > love.graphics.getWidth() then
      table.remove(self.torpedos, i)
    end
  end
end

function Player.setPlayer(player)
    Player.static.player = player
end


function Player.initializePlayer(image,health,speed)
  Player.setPlayer(Player:new(image,health,speed))
end
function Player.getPlayer()
  return Player.player
end

function Player.drawPlayer()
  player = Player.player
  love.graphics.draw(player.img, player.xPos, player.yPos, 0, 2, 2)
end

function Player.drawTorpedos()
  player = Player.player
   for index, torpedo in ipairs(player.torpedos) do
      love.graphics.draw(torpedo.img, torpedo.xPos, torpedo.yPos)
   end
end
