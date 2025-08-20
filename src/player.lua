local Player = {}

function Player.draw()
    local ox, oy = 25, 100
    if gracz.skin == spioszekImg then
        ox, oy = 15, 100
    end
    love.graphics.setColor(1, 1, 1)
    gracz.szerokosc = gracz.skin:getWidth() * gracz.scale
    if gracz.kierunek == "lewo" then
        love.graphics.draw(gracz.skin, gracz.x + gracz.szerokosc / 2, gracz.y - oy, 0, -gracz.scale, gracz.scale)
    else
        love.graphics.draw(gracz.skin, gracz.x - ox, gracz.y - oy, 0, gracz.scale, gracz.scale)
    end
    love.graphics.rectangleDebug(gracz.x, gracz.y, gracz.width, gracz.height)
end

return Player
