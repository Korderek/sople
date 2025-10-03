local Pustynia = {}
local Player = require("src.player")
local listakaktusow = {}
local ziemia = {}

local kaktusImg = love.graphics.newImage("gfx/kaktus.png")
local ziemiaImg = love.graphics.newImage("gfx/ziemia.png")
local pustyniaImg = love.graphics.newImage("gfx/pustynia.png")

Pustynia.load = function()
    kaktus = {
        x = szerokosc + 100,
        y = 800,
    }

    gracz.y = 800
    gracz.x = 300

    ziemia = {
        x = szerokosc + 100,
        y = 800,
    }
end

Pustynia.update = function(dt)
    --gracz.y = gracz.y + 5
    kaktus.x = kaktus.x - 10
    if kaktus.x < -100 then
        kaktus.x = szerokosc + love.math.random(200, 800)
        table.insert(listakaktusow,
            { x = kaktus.x, y = kaktus.y, width = kaktusImg:getWidth(), height = kaktusImg:getHeight() })
    end
    ziemia.x = ziemia.x - 10
    if ziemia.x < -200 then
        ziemia.x = szerokosc + love.math.random(200, 800)
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
    love.graphics.drawStretched(ziemiaImg, ziemia.x, ziemia.y, 6182 * szerokosc, ziemiaImg:getHeight())
    love.graphics.drawCentered(kaktusImg, kaktus.x, kaktus.y, 1, 1)
    Player.draw()
end
return Pustynia
