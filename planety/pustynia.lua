local Pustynia = {}
local UI = require("src.ui")
local Player = require("src.player")
local Efekty = require("src.efekty")
local listaziemi = {}
local listaprzeszkod = {}


local kaktusImg = love.graphics.newImage("gfx/kaktus.png")
local ziemiaImg = love.graphics.newImage("gfx/ziemia.png")
local pustyniaImg = love.graphics.newImage("gfx/pustynia.png")

Pustynia.load = function()
    kaktus = {
        x = szerokosc + 100,
        y = 800,
        tekstura = kaktusImg,
        predkosc = 10,
        width = kaktusImg:getWidth(),
        height = kaktusImg:getHeight()
    }
    ptak = {
        x = szerokosc + 150,
        y = 480,
        tekstura = kaktusImg,
        predkosc = 15,
        width = kaktusImg:getWidth(),
        height = kaktusImg:getHeight()
    }
    table.insert(listaprzeszkod, kaktus)
    table.insert(listaprzeszkod, ptak)
    gracz.y = 800
    gracz.x = 300


    for i = 0, 2 do
        table.insert(listaziemi, {
            x = i * ziemiaImg:getWidth(),
            y = 800,
        })
    end
end

function Pustynia.update(dt)
    --gracz.y = gracz.y + 5
    for _, przeszkoda in ipairs(listaprzeszkod) do
        if niesmiertelny < 0 and kolizja(gracz, przeszkoda) then
            zycia = zycia - 1
            niesmiertelny = 2
            wstrzasy = 0.3
            oberwal = 1
        end
        przeszkoda.x = przeszkoda.x - przeszkoda.predkosc
        if przeszkoda.x < -100 then
            przeszkoda.x = szerokosc + love.math.random(186, 1200)
        end
    end

    for _, z in ipairs(listaziemi) do
        z.x = z.x - 10
        if z.x < -ziemiaImg:getWidth() then
            z.x = szerokosc
        end
    end

    local przyspieszenie = 0
    if love.keyboard.isDown("w") and gracz.y == 800 then
        przyspieszenie = -37
    end
    przyspieszenie = przyspieszenie + 1.56
    gracz.predkosc = gracz.predkosc + przyspieszenie
    gracz.y = gracz.y + gracz.predkosc
    if gracz.y > 800 then
        gracz.y = 800
        gracz.predkosc = 0
    end
end

Pustynia.draw = function()
    love.graphics.drawStretched(pustyniaImg, 0, 0, szerokosc, wysokosc)
    love.graphics.setBackgroundColor(0.9, 0.8, 0.5)
    Efekty.wstrzasyZMoca(10)
    for _, z in ipairs(listaziemi) do
        love.graphics.drawStretched(ziemiaImg, z.x, z.y, ziemiaImg:getWidth(), ziemiaImg:getHeight())
    end
    for _, przeszkoda in ipairs(listaprzeszkod) do
        love.graphics.drawCentered(przeszkoda.tekstura, przeszkoda.x, przeszkoda.y, 1, 1)
    end
    Player.draw()

    UI.rysujSerca()
    love.graphics.print(niesmiertelny, 10, 10)
end
return Pustynia
