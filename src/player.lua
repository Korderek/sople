local Player = {}

function Player.draw()
    local scale_x = gracz.kierunek == "prawo" and gracz.scale or -gracz.scale
    local scale_y = gracz.scale

    love.graphics.setColor(1, 1, 1)
    love.graphics.drawCentered(gracz.skin, gracz.x, gracz.y, gracz.width, gracz.height, scale_x, scale_y)
    love.graphics.rectangleDebug(gracz.x, gracz.y, gracz.width, gracz.height)
end

return Player
