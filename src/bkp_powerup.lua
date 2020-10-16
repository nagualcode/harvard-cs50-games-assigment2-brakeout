--[[
    GD50
    Breakout Remake

    -- Power Class --

]]

PowerUp = Class{}

-- some of the colors in our palette (to be used with particle systems)
paletteColors = {
    -- blue
    [1] = {
        ['r'] = 99,
        ['g'] = 155,
        ['b'] = 255
    },
    -- green
    [2] = {
        ['r'] = 106,
        ['g'] = 190,
        ['b'] = 47
    },
    -- red
    [3] = {
        ['r'] = 217,
        ['g'] = 87,
        ['b'] = 99
    },
    -- purple
    [4] = {
        ['r'] = 215,
        ['g'] = 123,
        ['b'] = 186
    },
    -- gold
    [5] = {
        ['r'] = 251,
        ['g'] = 242,
        ['b'] = 54
    }
}

function PowerUp:init(isKey)
    -- used for coloring and score calculation
    self.tier = 0
    self.color = 1
    
    self.x = VIRTUAL_WIDTH / 2

    self.y = VIRTUAL_HEIGHT

    self.dy = 1

    self.width = 32
    self.height = 16

    self.isKey = isKey
    

    self.inPlay = true

    -- particle system belonging to the brick, emitted on hit
    self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 64)

    -- various behavior-determining functions for the particle system
    -- https://love2d.org/wiki/ParticleSystem

    -- lasts between 0.5-1 seconds seconds
    self.psystem:setParticleLifetime(0.5, 1)

    -- give it an acceleration of anywhere between X1,Y1 and X2,Y2 (0, 0) and (80, 80) here
    -- gives generally downward 
    self.psystem:setLinearAcceleration(-15, 0, 15, 80)

    -- spread of particles; normal looks more natural than uniform
    self.psystem:setAreaSpread('normal', 10, 10)
end

--[[
    Triggers a hit on the PowerUp, taking it out of play if at 0 health or
    changing its color otherwise.
]]
function PowerUp:hit(key)

    if self.isKey then
        print("grab key")
        gSounds['confirm']:play()
        
    else
    
        -- set the particle system to interpolate between two colors; in this case, we give
        -- it our self.color but with varying alpha; brighter for higher tiers, fading to 0
        -- over the particle's lifetime (the second color)
        self.psystem:setColors(
            paletteColors[self.color].r,
            paletteColors[self.color].g,
            paletteColors[self.color].b,
            55 * (self.tier + 1),
            paletteColors[self.color].r,
            paletteColors[self.color].g,
            paletteColors[self.color].b,
            0
        )
        self.psystem:emit(64)

        -- sound on hit

        gSounds['confirm']:play()



    end

    end
    

function PowerUp:update(dt)
    self.psystem:update(dt)
    self.y = self.y + self.dy * dt
end

function PowerUp:render()
    gSounds['high-score']:play()
    if self.inPlay and self.isKey then
        print("generate: key")
        print(1 + ((self.color - 1) * 4) + self.tier)
        love.graphics.draw(gTextures['main'],
        gFrames['bricks'][24], self.x, self.y)
    elseif self.inPlay then
        print("generate: powerup ball")
        love.graphics.draw(gTextures['main'], 
            -- multiply color by 4 (-1) to get our color offset, then add tier to that
            -- to draw the correct tier and color brick onto the screen
            gFrames['bricks'][1 + ((self.color - 1) * 4) + self.tier],
            self.x, self.y)
    end
end
--[[
    Need a separate render function for our particles so it can be called after all bricks are drawn;
    otherwise, some bricks would render over other bricks' particle systems.
]]
function Brick:renderParticles()
    love.graphics.draw(self.psystem, self.x + 16, self.y + 8)
end