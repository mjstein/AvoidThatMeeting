function love.load()
  submarineImage = love.graphics.newImage("resources/images/submarine.png")
  torpedoImage = love.graphics.newImage("resources/images/torpedo.png")
  wattonImage = love.graphics.newImage("resources/images/watton.jpeg")
  jeffImage = love.graphics.newImage("resources/images/jeffsmall.jpeg")
  alexImage = love.graphics.newImage("resources/images/alex.jpeg")
  adrianImage = love.graphics.newImage("resources/images/aj.jpeg")

  torpedoTimerMax = 0.7
  torpedoStartSpeed = 100
  torpedoMaxSpeed = 600
  wattonSpeed = 200
  jeffSpeed = 150
  alexSpeed = 350
  adrianSpeed = 350
  chargeSpeed = 1200
  spawnTimerMax = 0.5
  score=0
  meetings=0
  speedFactor=0
  xShift=0
  timer=0
  ySpeedShift=0
  xSpeedShift=0
  love.window.setTitle( "Avoid That Meeting!" )
  soundTrack = love.audio.newSource("resources/audio/Mercury.wav","static")
  soundTrack:play()
  startGame()
end

function startGame()
  print("Starting")
  score = 0
  player = {xPos = 0, yPos = 0, width = 64, height = 64, speed=250, img=submarineImage, health = 100}
  torpedoes = {}
  enemies = {}

  canFire = true
  hasCollided = false
  torpedoTimer = torpedoTimerMax
  spawnTimer = 0
end

function generateMeetingText()
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

function love.draw()
  font = love.graphics.newFont(12)
  love.graphics.setFont(font)
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("Meetings: " .. meetings .. " Score: " .. score .. " Health: " .. player.health .. "/100", 10,0)
  generateMeetingText()
  love.graphics.setColor(186, 255, 255)
  background = love.graphics.rectangle("fill", 0, 20, love.graphics.getWidth(), love.graphics.getHeight()-40)
  love.graphics.setColor(255, 255, 255)

  love.graphics.draw(player.img, player.xPos, player.yPos, 0, 2, 2)

  for index, torpedo in ipairs(torpedoes) do
    love.graphics.draw(torpedo.img, torpedo.xPos, torpedo.yPos)
  end

  for index, enemy in ipairs(enemies) do
    love.graphics.draw(enemy.img, enemy.xPos, enemy.yPos, 0, 2, 2)
  end
end

function love.update(dt)

  timer = timer + 1
  if not soundTrack:isPlaying() then
    soundTrack:play()
  end
  updatePlayer(dt)

  updateTorpedoes(dt)
  updateEnemies(dt)
  checkCollisions()
  updateSpeedFactor()
end
--updateSpeedFactor
function updateSpeedFactor()
  speedFactor = (score/50) * 20
end
-- Player logic

function updatePlayer(dt)
  down = love.keyboard.isDown("down")
  up = love.keyboard.isDown("up")
  left = love.keyboard.isDown("left")
  right = love.keyboard.isDown("right")

  speed = player.speed
  if((down or up) and (left or right)) then
    speed = speed / math.sqrt(2)
  end

  if down and player.yPos<love.graphics.getHeight()-player.height then
    player.yPos = player.yPos + dt * speed
  elseif up and player.yPos>0 then
    player.yPos = player.yPos - dt * speed
  end

  if right and player.xPos<love.graphics.getWidth()-player.width then
    player.xPos = player.xPos + dt * speed
  elseif left and player.xPos>0 then
    player.xPos = player.xPos - dt * speed
  end

  if love.keyboard.isDown("space") then
    torpedoSpeed = torpedoStartSpeed
    if(left) then
      torpedoSpeed = torpedoSpeed - player.speed/2
    elseif(right) then
      torpedoSpeed = torpedoSpeed + player.speed/2
    end
    torpAngle = love.math.random(70, 110)
    spawnTorpedo(player.xPos + player.width, player.yPos + player.height/2, torpedoSpeed, torpAngle)
  end

  if torpedoTimer > 0 then
    torpedoTimer = torpedoTimer - dt
  else
    canFire = true
  end
end

-- Projectile logic

function updateTorpedoes(dt)
  for i=table.getn(torpedoes), 1, -1 do
    torpedo = torpedoes[i]
    xSpeedT = math.sin(math.rad (torpedo.torpAngle)) * torpedo.speed
    ySpeedT = math.cos(math.rad (torpedo.torpAngle)) * torpedo.speed
    torpedo.xPos = torpedo.xPos + dt * xSpeedT
    torpedo.yPos = torpedo.yPos + dt * ySpeedT
    if torpedo.speed < torpedoMaxSpeed then
      torpedo.speed = torpedo.speed + dt * 100
    end
    if torpedo.xPos > love.graphics.getWidth() then
      table.remove(torpedoes, i)
    end
  end
end

function spawnTorpedo(x, y, speed,torpAngle)
  if canFire then
    shootSound = love.audio.newSource("resources/audio/Shoot.wav","static")
    shootSound:play()
    torpedo = {xPos = x, yPos = y, width = 16, height=16, speed=speed, img = torpedoImage, justFired= true, torpAngle = torpAngle}
    table.insert(torpedoes, torpedo)

    canFire = false
    torpedoTimer = torpedoTimerMax
  end
end

-- Enemy logic

function updateEnemies(dt)
  if spawnTimer > 0 then
    spawnTimer = spawnTimer - dt
  else
    spawnEnemy()
  end

  for i=table.getn(enemies), 1, -1 do
    enemy=enemies[i]
    enemy.update = enemy:update(dt)
    if enemy.xPos < -enemy.width then
      table.remove(enemies, i)
    end
  end
end

function spawnEnemy()
  y = love.math.random(0, love.graphics.getHeight() - 64)
  enemyType = love.math.random(0, 3)
  if enemyType == 0 then
    enemy = Enemy:new{score = 1,yPos = y, speed = wattonSpeed + speedFactor, img = wattonImage, update=moveLeft}
  elseif enemyType == 1 then
    enemy = Enemy:new{score = 10,yPos = y, speed = jeffSpeed + speedFactor , img = jeffImage, update=chargePlayer}
  elseif enemyType == 2 then
    enemy = Enemy:new{score = 14,yPos = y, speed = adrianSpeed + speedFactor , img = adrianImage, update=moveLeftWithShift}
  else
    enemy = Enemy:new{score = 5, yPos = y, speed = alexSpeed + speedFactor , img = alexImage, update=moveToPlayer}
  end
  table.insert(enemies, enemy)

  spawnTimer = spawnTimerMax
end

Enemy = {xPos = love.graphics.getWidth(), yPos = 0, width = 64, height = 64}

function Enemy:new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function moveLeft(obj, dt)
  obj.xPos = obj.xPos - obj.speed * dt
  return moveLeft
end

function moveLeftWithShift(obj, dt)
  --obj.speed = obj.speed + xShift*100 -(xShift * 4)
  if (timer % 30 == 0) then
    xShift = love.math.random(0, 180)
    yShift = love.math.random(0, 180)
    xSpeedShift = math.sin(math.rad (xShift)) * obj.speed
    ySpeedShift = math.cos(math.rad (yShift)) * obj.speed
  end
  obj.yPos = obj.yPos - ySpeedShift * dt
  obj.xPos = obj.xPos - xSpeedShift * dt
  return moveLeftWithShift
end

function moveToPlayer(obj, dt)
  xSpeed = math.sin(math.rad (60)) * obj.speed
  ySpeed = math.cos(math.rad (60)) * obj.speed
  if (obj.yPos - player.yPos) > 10 then
    obj.yPos = obj.yPos - ySpeed * dt
    obj.xPos = obj.xPos - xSpeed * dt
  elseif (obj.yPos - player.yPos) < -10 then
    obj.yPos = obj.yPos + ySpeed * dt
    obj.xPos = obj.xPos - xSpeed * dt
  else
    obj.xPos = obj.xPos - obj.speed * dt
  end
  return moveToPlayer
end

function chargePlayer(obj, dt)
  xDistance = math.abs(obj.xPos - player.xPos)
  yDistance = math.abs(obj.yPos - player.yPos)
  distance = math.sqrt(yDistance^2 + xDistance^2)
  if distance < 300 then
    obj.speed = chargeSpeed
    return moveLeft
  end
  moveToPlayer(obj, dt)
  return chargePlayer
end

-- Helper functions

function checkCollisions()
  for index, enemy in ipairs(enemies) do
    if intersects(player, enemy) or intersects(enemy, player) then
      shootSound = love.audio.newSource("resources/audio/Explosion.wav","static")
      shootSound:play()
      score = score - 1
      player.health = player.health -1
      if player.health <= 0 then
        shootSound1 = love.audio.newSource("resources/audio/Lightening.wav","static")
        shootSound1:play()
        meetings = meetings + 1
        startGame()
      end
    end


    for index2, torpedo in ipairs(torpedoes) do
      if intersects(enemy, torpedo) then
        shootSound2 = love.audio.newSource("resources/audio/Lightening.wav","static")
        shootSound2:play()
        score = score + enemy.score
        table.remove(enemies, index)
        table.remove(torpedoes, index2)
        break
      end
    end

  end
end

function intersects(rect1, rect2)
  if rect1.xPos < rect2.xPos and rect1.xPos + rect1.width > rect2.xPos and
  rect1.yPos < rect2.yPos and rect1.yPos + rect1.height > rect2.yPos then
    return true
  else
    return false
  end
end
