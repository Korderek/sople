local S = {}

-- Lista wszystkich sopli
local sople = {}
-- Grafika dla sopli
local sopelImg = love.graphics.newImage("gfx/sopel.png")

-- Stopery
local czas = 0
local czas_ostatniego_dodania = 0
local predkosc = 6

-- Spawnuje określoną liczbę sopli
function S.spawn(ilosc)
    ilosc = ilosc or 1
    for i = 1, ilosc do
        table.insert(sople, S.losowy())
    end
end

function S.update(dt)
    czas = czas + dt

    if czas - czas_ostatniego_dodania >= szybkosci_dodawania[aktualny_poziom] then
        table.insert(sople, S.losowy())
        czas_ostatniego_dodania = czas
    end

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
