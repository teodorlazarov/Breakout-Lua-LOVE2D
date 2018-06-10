local levels = {}
levels.current_level = 1
levels.gameFinished = false
levels.sequence = {}

levels.sequence[1] = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {2, 2, 2, 0, 0, 1, 1, 1, 0, 0, 0},
    {2, 0, 0, 2, 0, 0, 2, 0, 0, 0, 0},
    {2, 0, 0, 2, 0, 0, 2, 0, 0, 0, 0},
    {2, 2, 2, 0, 0, 0, 2, 0, 0, 0, 0},
    {2, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0},
    {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
}

levels.sequence[2] = {
    {0, 0, 0, 2, 0, 0, 1, 1, 1, 0, 0},
    {0, 0, 2, 2, 0, 1, 0, 0, 0, 1, 0},
    {0, 2, 0, 2, 0, 0, 0, 0, 1, 0, 0},
    {2, 2, 2, 2, 0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 2, 0, 0, 1, 0, 0, 0, 0},
    {0, 0, 0, 2, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 2, 0, 1, 1, 1, 1, 1, 1},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
}

function levels.switch_to_next_level(bricks, ball, lives_display)
    if bricks.no_more_bricks then
        if levels.current_level < #levels.sequence then
            levels.current_level = levels.current_level + 1
            lives_display.reset()
            ball.reposition()
            bricks.construct_level(levels.sequence[levels.current_level])
        else
            levels.gameFinished = true          
        end
    end
end

function levels.reset_current_level(bricks, ball, lives_display)
    bricks.reset_current_level()
    lives_display.reset()
    bricks.construct_level(levels.sequence[levels.current_level])
    ball.reposition()
end

function levels.is_game_done()
    return levels.gameFinished
end

return levels