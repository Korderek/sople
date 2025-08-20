local Sople = {}

-- Lista wszystkich sopli
local listaSopli = {}

-- Grafika dla sopli
local sopelImg = love.graphics.newImage("gfx/sopel.png")

-- Stopery
local czas = 0
local czas_ostatniego_dodania = 0
local predkosc = 6

-- Spawnuje określoną liczbę sopli
function Sople.spawn(ilosc)
    ilosc = ilosc or 1
    for i = 1, ilosc do
        table.insert(listaSopli, Sople.losowy())
    end
end

-- Przemieszcza sople i sprawdza kolizje z graczem
function Sople.update(dt)
    czas = czas + dt
    punkty = math.floor(czas)

    if czas - czas_ostatniego_dodania >= szybkosci_dodawania[aktualny_poziom] then
        table.insert(listaSopli, Sople.losowy())
        czas_ostatniego_dodania = czas
    end

    for _, sopel in ipairs(listaSopli) do
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

-- Rysuje wszystkie sople
function Sople.draw()
    for _, sopel in ipairs(listaSopli) do
        love.graphics.draw(sopelImg, sopel.x, sopel.y)
        love.graphics.rectangleDebug(sopel.x, sopel.y, sopel.width, sopel.height)
    end
end

function Sople.losowy()
    return {
        x = love.math.random(0, szerokosc - sopelImg:getWidth()),
        y = love.math.random(-600, -50),
        width = sopelImg:getWidth(),
        height = sopelImg:getHeight()
    }
end

return Sople
