local vector = require "vector"
local levels = require "levels"

local ball = {}
ball.position = vector(400, 300)
ball.speed = vector(0, -300)
ball.radius = 10
ball.escaped_screen = false

function ball.update(dt)
    if not levels.is_game_done() then 
    ball.position = ball.position + ball.speed * dt
    ball.check_escape_from_screen()
    end
end

function ball.draw()
    local segments_in_circle = 16
    love.graphics.circle('line', ball.position.x, ball.position.y, ball.radius, segments_in_circle)
    --love.graphics.print(tostring(ball.escaped_screen), 600, 500)
end

function ball.rebound(shift_ball)
    local min_shift = math.min(math.abs(shift_ball.x), math.abs(shift_ball.y))
    if math.abs(shift_ball.x) == min_shift then
        shift_ball.y = 0
    else
        shift_ball.x = 0
    end
    ball.position = ball.position + shift_ball
    if shift_ball.x ~= 0 then
        ball.speed.x = -ball.speed.x
    end
    if shift_ball.y ~= 0 then
        ball.speed.y = -ball.speed.y
    end
end

function ball.check_escape_from_screen()
    local x = ball.position.x
    local y = ball.position.y
    local ball_top = y - ball.radius
    if ball_top > love.graphics.getHeight() then
        ball.escaped_screen = true
    end
end

function ball.reposition()
    ball.escaped_screen = false
    ball.position = vector(400, 300)
end

function ball.check_no_more_balls(ball, lives_display, bricks)
    if ball.escaped_screen then
        lives_display.lose_life()
        if lives_display.lives < 0 then
            levels.reset_current_level(bricks, ball, lives_display)
        else
            ball.reposition()
        end
    end
end

function ball.platform_rebound( shift_ball, platform )
    ball.bounce_from_sphere( shift_ball, platform )
 end
 
 function ball.bounce_from_sphere( shift_ball, platform )
    local actual_shift = ball.determine_actual_shift( shift_ball )
    ball.position = ball.position + actual_shift
    if actual_shift.x ~= 0 then
       ball.speed.x = -ball.speed.x
    end
    if actual_shift.y ~= 0 then
       local sphere_radius = 200
       local ball_center = ball.position
       local platform_center = platform.position +
          vector( platform.width / 2, platform.height / 2  )
       local separation = ( ball_center - platform_center )
       local normal_direction = vector( separation.x / sphere_radius, -1 )
       local v_norm = ball.speed:projectOn( normal_direction )
       local v_tan = ball.speed - v_norm
       local reverse_v_norm = v_norm * (-1)
       ball.speed = reverse_v_norm + v_tan
    end
 end
 
 function ball.determine_actual_shift( shift_ball )
    local actual_shift = vector( 0, 0 )
    local min_shift = math.min( math.abs( shift_ball.x ),
                                math.abs( shift_ball.y ) )  
    if math.abs( shift_ball.x ) == min_shift then
       actual_shift.x = shift_ball.x
    else
       actual_shift.y = shift_ball.y
    end
    return actual_shift
 end

return ball
