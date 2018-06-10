local ball = require "ball"
local platform = require "platform"
local bricks = require "bricks"
local walls = require "walls"
local collisions = require "collisions"
local levels = require "levels"
local lives_display = require "lives"
local main_music = love.audio.newSource("sounds/theme.ogg")
main_music:setLooping(true)

function love.load()
    love.window.setMode(800, 600, {fullscreen = false})
    background = love.graphics.newImage("background.png")
    bricks.construct_level(levels.sequence[levels.current_level])
    walls.construct_walls()
    main_music:play()
end

function love.update(dt)
    ball.update(dt)
    platform.update(dt)
    bricks.update(dt)
    walls.update(dt)
    collisions.resolve_collisions(ball, platform, walls, bricks)
    levels.switch_to_next_level(bricks, ball, lives_display)
    ball.check_no_more_balls(ball, lives_display, bricks)
end

function love.draw()
    love.graphics.draw(background, 0,0)
    --love.graphics.print(tostring(levels.gameFinished), 300,300,0,2,2)
    ball.draw()
    platform.draw()
    bricks.draw()
    walls.draw()
    lives_display.draw()
end

function love.keyreleased(key, code)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.quit()
    print("Byeeee")
end

