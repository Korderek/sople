player = {}

function player.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(gracz.skin, gracz.x - gracz.ox, gracz.y - gracz.oy, 0, gracz.scale, gracz.scale)
    love.graphics.rectangle('line', gracz.x, gracz.y, gracz.width, gracz.height)
end
