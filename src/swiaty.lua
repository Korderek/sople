local Swiaty = {}
local UI = require("src.ui")
local Efekty = require("src.efekty")
local Pustynia = require("planety.pustynia.pustynia")
local klodka = love.graphics.newImage("gfx/klodka.png")

local planety = {
    las = {
        x = 250,
        y = 250,
        img = love.graphics.newImage("gfx/planety/las.png"),
        nazwa = "Dzika puszcza",
        zablokowana = false,
        akcja = function()
            stanGry = stan.sople
        end
    },
    pustynia = {
        x = 620,
        y = 150,
        img = love.graphics.newImage("gfx/planety/pustynia.png"),
        nazwa = "Bezkresna pustynia",
        zablokowana = false,
        akcja = function()
            stanGry = stan.pustynia
            Pustynia.load()
        end
    },
    wulkan = {
        x = 1200,
        y = 200,
        img = love.graphics.newImage("gfx/planety/wulkan.png"),
        nazwa = "Groźny wulkan",
        zablokowana = true,
        akcja = function()
            stanGry = stan.sople
        end
    },
    jednorozce = {
        x = 620,
        y = 650,
        img = love.graphics.newImage("gfx/planety/jednorozce.png"),
        nazwa = "Wesoła kraina",
        zablokowana = false,
        akcja = function()
            stanGry = stan.sople
        end
    },
}
local drogi = {
    { start = planety.las,      koniec = planety.pustynia },
    { start = planety.pustynia, koniec = planety.wulkan },
    { start = planety.pustynia, koniec = planety.jednorozce },
    { start = planety.wulkan,   koniec = planety.jednorozce },
}

function Swiaty.draw()
    -- Rysowanie świata
    love.graphics.setColor(1, 1, 1)

    -- Rysowanie dróg między planetami
    for _, droga in ipairs(drogi) do
        Swiaty.droga(droga.start, droga.koniec)
    end

    -- Rysowanie planet
    for _, p in pairs(planety) do
        if UI.przycisk_swiat(p.x, p.y, p.img, p.nazwa, p.zablokowana) then
            Efekty.rozpocznijLadowanie(p.akcja)
        end
    end
end

function Swiaty.droga(a, b)
    local x1 = a.x + a.img:getWidth() / 2
    local y1 = a.y + a.img:getHeight() / 2 + 50
    local x2 = b.x + b.img:getWidth() / 2
    local y2 = b.y + b.img:getHeight() / 2 + 50
    love.graphics.setLineWidth(30)
    love.graphics.line(x1, y1, x2, y2)
    love.graphics.setLineWidth(1)
    local zablokowana = a.zablokowana or b.zablokowana
    if zablokowana then
        love.graphics.drawCentered(klodka, x1, y1, x2 - x1, y2 - y1)
    end
end

return Swiaty
