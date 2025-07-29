local S = {}

function S.update(dt)
    local predkosc = 6
    for _, sopel in ipairs(sople) do
        sopel.y = sopel.y + predkosc
        if sopel.y > wysokosc then
            sopel.y = -100
            sopel.x = love.math.random(0, szerokosc - sopel.width)
        end
        if niesmiertelny < 0 and kolizja(gracz, sopel) then
            zycia = zycia - 1
            niesmiertelny = 2
            wstrzasy = 0.3
        end
    end
end

function S.draw()
    for _, sopel in ipairs(sople) do
        love.graphics.draw(sopelImg, sopel.x, sopel.y)
    end
end

function S.losowy()
    return {
        x = love.math.random(0, szerokosc - sopelImg:getWidth()),
        y = love.math.random(-600, -50),
        width = sopelImg:getWidth(),
        height = sopelImg:getHeight()
    }
end

return S
