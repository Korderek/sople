local M = {}
local monetaImg = love.graphics.newImage("gfx/moneta.png")
local monety = {}

zebraneMonety = 0

-- Generuje przekazaną parametrem liczbę monet
function M.spawn(liczba_monet)
    local liczba_monet = liczba_monet or 1
    for _ = 1, liczba_monet do
        table.insert(monety, M.losowaMoneta())
    end
end

function M.update(dt)
    for _, m in ipairs(monety) do
        m.y = m.y + 2
        if m.y > wysokosc then
            -- Jeśli moneta spadnie poza ekran, generujemy nową
            m = M.losowaMoneta()
        end
        if kolizja(gracz, m) then
            -- Jeśli gracz zbierze monetę, zwiększamy licznik i generujemy nową
            zebraneMonety = zebraneMonety + 1
            m = M.losowaMoneta()
        end
    end
end

function M.draw()
    for _, m in ipairs(monety) do
        love.graphics.draw(monetaImg, m.x, m.y)
    end
end

function M.losowaMoneta()
    return {
        x = love.math.random(0, szerokosc - 32),
        y = love.math.random(-400, -50),
        width = 32,
        height = 32
    }
end

return M
