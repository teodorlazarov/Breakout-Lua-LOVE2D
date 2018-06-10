local vector = require "vector"

local platform = {}
platform.position = vector(500,500)
platform.speed = vector(500,0)
platform.width = 90
platform.height = 20
platform.image = love.graphics.newImage("Paddle.png")
platform.quad = love.graphics.newQuad(500,500,90,20,70,20)

function platform.update(dt)
    if love.keyboard.isDown("right") then
        platform.position = platform.position + (platform.speed * dt)
    end
    
    if love.keyboard.isDown("left") then
        platform.position = platform.position - (platform.speed * dt)
    end
end

function platform.draw()
    love.graphics.draw(platform.image, platform.quad, platform.position.x, platform.position.y)
    love.graphics.rectangle('line', platform.position.x, platform.position.y, platform.width, platform.height)
end

function platform.bounce_from_wall(shift_platform)
    platform.position.x = platform.position.x + shift_platform.x
end

return platform