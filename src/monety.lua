local Monety = {}

-- Lista wszystkich monet
local listaMonet = {}

-- Grafika dla monet
local monetaImg = love.graphics.newImage("gfx/moneta.png")

-- Generuje przekazaną parametrem liczbę monet
function Monety.spawn(liczba_monet)
    local liczba_monet = liczba_monet or 1
    for _ = 1, liczba_monet do
        table.insert(listaMonet, Monety.losowaMoneta())
    end
end

function Monety.update(dt)
    for i, m in ipairs(listaMonet) do
        m.y = m.y + 2
        if m.y > wysokosc then
            -- Jeśli moneta spadnie poza ekran, generujemy nową
            listaMonet[i] = Monety.losowaMoneta()
        end
        if kolizja(gracz, m) then
            -- Jeśli gracz zbierze monetę, zwiększamy licznik i generujemy nową
            zebraneMonety = zebraneMonety + 1
            listaMonet[i] = Monety.losowaMoneta()
        end
    end
end

function Monety.draw()
    for _, m in ipairs(listaMonet) do
        love.graphics.draw(monetaImg, m.x, m.y)
    end
end

function Monety.losowaMoneta()
    return {
        -- Losowa pozycja x i y dla nowej monety
        x = love.math.random(0, szerokosc - 32),
        y = love.math.random(-400, -50),
        width = 64,
        height = 64
    }
end

return Monety
