--[[
    GD50
    Breakout Remake

    -- Ball Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a ball which will bounce back and forth between the sides
    of the world space, the player's paddle, and the bricks laid out above
    the paddle. The ball can have a skin, which is chosen at random, just
    for visual variety.
]]

PowerUp = Class{}

function PowerUp:init(tipo, x, y)
    -- simple positional and dimensional variables
    self.width = 8
    self.height = 8

    self.x = x
    self.y = y
    self.tipo = tipo

    -- these variables are for keeping track of our velocity on both the
    -- X and Y axis, since the ball can move in two dimensions
   self.dy = math.random(10,50)
   self.dx = 0

    -- this will effectively be the color of our ball, and we will index
    -- our table of Quads relating to the global block texture using this
    self.skin = skin
end

--[[
    Expects an argument with a bounding box, be that a paddle or a brick,
    and returns true if the bounding boxes of this and the argument overlap.
]]
function PowerUp:hit()
    print("grab Powerup")
    gSounds['confirm']:play()
end

function PowerUp:collides(target)
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    return true
end


function PowerUp:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

end

function PowerUp:render()
   -- print(self.tipo)
    -- gTexture is our global texture for all blocks
    -- gBallFrames is a table of quads mapping to each individual ball skin in the texture
    if self.tipo == "key" then
         pupicon = 10
    else
         pupicon = 9
        
    end
    love.graphics.draw(gTextures['main'], gFrames['power'][pupicon], self.x, self.y)
end