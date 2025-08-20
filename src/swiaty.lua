local Swiaty = {}

local UI = require("src.ui")
local Efekty = require("src.efekty")

local planetafacet = love.graphics.newImage("gfx/gracz.png")
local planetaLas = love.graphics.newImage("gfx/planety/las.png")
local planetaJednorozce = love.graphics.newImage("gfx/planety/jednorozce.png")
local klodka = love.graphics.newImage("gfx/klodka.png")

local planety = {
    las = {
        x = 310,
        y = 310,
        nazwa = "Świat leśny",
        grafika = planetaLas,
        zablokowana = false,
    },
    jednorozce = {
        x = 800,
        y = 500,
        nazwa = "Świat tęczowy",
        grafika = planetaJednorozce,
        zablokowana = true,
    },
    konie = {
        x = 900,
        y = 100,
        nazwa = "Świat koni",
        grafika = planetaJednorozce,
        zablokowana = false,
    },
    puszcza = {
        x = 1500,
        y = 200,
        nazwa = "Groźna puszcza",
        grafika = planetaLas,
        zablokowana = false,
    },
}
local drogi = {
    [planety.las] = { planety.jednorozce, planety.konie },
    [planety.konie] = { planety.puszcza }
}

function Swiaty.draw()
    -- Rysowanie świata
    love.graphics.setColor(1, 1, 1)

    for start, drogi_od in pairs(drogi) do
        for _, koniec in ipairs(drogi_od) do
            Swiaty.droga(start, koniec, koniec.zablokowana or start.zablokowana)
        end
    end

    -- Rysowanie planet
    for _, p in pairs(planety) do
        if UI.przycisk_swiat(p.x, p.y, p.grafika, p.nazwa, p.zablokowana) then
            Efekty.rozpocznijLadowanie(function() stanGry = stan.menu end)
        end
    end
end

function Swiaty.droga(a, b, zablokowana)
    local x1 = a.x + a.grafika:getWidth() / 2
    local y1 = a.y + a.grafika:getHeight() / 2 + 50
    local x2 = b.x + b.grafika:getWidth() / 2
    local y2 = b.y + b.grafika:getHeight() / 2 + 50
    love.graphics.setLineWidth(30)
    love.graphics.line(x1, y1, x2, y2)
    love.graphics.setLineWidth(1)
    if zablokowana then
        love.graphics.drawCentered(klodka, x1, y1, x2 - x1, y2 - y1)
    end
end

return Swiaty
