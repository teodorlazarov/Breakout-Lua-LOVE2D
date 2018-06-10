local vector = require "vector"

local bricks = {}
bricks.current_level_bricks = {}
bricks.tile_width = 50
bricks.tile_height = 30
bricks.tileset_width = 384
bricks.tileset_height = 160
bricks.brick_width = bricks.tile_width
bricks.brick_height = bricks.tile_height
bricks.horizontal_distance = 10
bricks.vertical_distance = 15
bricks.top_left_position = vector(70, 50)
bricks.row = 8
bricks.columns = 11
bricks.no_more_bricks = false
bricks.image = love.graphics.newImage("bricksprite.png")
bricks.image1 = love.graphics.newImage("metalsprite.png")
bricks.quad = love.graphics.newQuad(0, 0, 50, 30, 50, 30)
bricks.quad1 = love.graphics.newQuad(0, 0, 50, 30, 50, 30)
bricks.score = 0
bricks.hp = 1
bricks.brickkind = 0

local break_sound = love.audio.newSource("sounds/breaksound.ogg", static)
local break_armor_sound = love.audio.newSource("sounds/armor_break.ogg", static)

function bricks.new_brick(position, width, height, bricktype)
    return ({position = position,
        width = width or bricks.brick_width,
        height = height or bricks.brick_height,
        hp = bricktype or bricks.hp,
        brickkind = bricktype or 1})
end

function bricks.add_to_current_level_bricks(brick)
    table.insert(bricks.current_level_bricks, brick)
end

function bricks.update_brick(single_brick)

end

function bricks.draw_brick(single_brick)
    
    --love.graphics.rectangle('line', single_brick.position.x, single_brick.position.y, single_brick.width, single_brick.height)
    if single_brick.brickkind == 1 then
    love.graphics.draw(bricks.image, bricks.quad, single_brick.position.x, single_brick.position.y)
    elseif single_brick.brickkind == 2 then
        love.graphics.draw(bricks.image1, bricks.quad1, single_brick.position.x, single_brick.position.y)
    end
end

function bricks.construct_level(level_bricks_arrangement)
    bricks.no_more_bricks = false
    for row_index, row in ipairs(level_bricks_arrangement) do
        for col_index, bricktype in ipairs(row) do
            if bricktype ~= 0 then
                local new_brick_position_x = bricks.top_left_position.x + (col_index - 1) * (bricks.brick_width + bricks.horizontal_distance)
                local new_brick_position_y = bricks.top_left_position.y + (row_index - 1) * (bricks.brick_height + bricks.vertical_distance)
                local new_brick_position = vector(new_brick_position_x, new_brick_position_y)
                local new_brick = bricks.new_brick(new_brick_position, bricks.brick_width, bricks.brick_height, bricktype)
                bricks.add_to_current_level_bricks(new_brick)
            end
        end
    end
end

function bricks.update(dt)
    if #bricks.current_level_bricks == 0 then
        bricks.no_more_bricks = true
    else
        for _, brick in pairs(bricks.current_level_bricks) do
            bricks.update_brick(brick)
        end
    end
end

function bricks.draw()
    for _, brick in pairs(bricks.current_level_bricks) do
        bricks.draw_brick(brick)
    end
    love.graphics.print("Score: " .. tostring(bricks.score), 300, 10, 0, 3, 3)
end

function bricks.brick_hit_by_ball(i, brick)
    if brick.hp > 0 then
        brick.hp = brick.hp - 1
        break_sound:play()
    end
    
    if brick.hp <= 0 then
        if brick.brickkind == 2 then
            break_armor_sound:play()
        
        elseif brick.brickkind == 1 then
            break_sound:play()
        else
            end
        table.remove(bricks.current_level_bricks, i)
        bricks.score = bricks.score + 10
    end
end

function bricks.reset_current_level()
    bricks.current_level_bricks = {}
end

return bricks
