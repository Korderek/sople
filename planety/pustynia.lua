local Pustynia = {}
local Player = require("src.player")
local listakaktusow = {}
local kaktusImg = love.graphics.newImage("gfx/gracz.png")
Pustynia.load = function()
    kaktus = {
        x = szerokosc + 100,
        y = 800,
    }

    gracz.y = 800
    gracz.x = 300
end

Pustynia.update = function(dt)
    --gracz.y = gracz.y + 5
    kaktus.x = kaktus.x - 10
    if kaktus.x < -100 then
        kaktus.x = szerokosc + love.math.random(200, 800)
        table.insert(listakaktusow,
            { x = kaktus.x, y = kaktus.y, width = kaktusImg:getWidth(), height = kaktusImg:getHeight() })
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
    love.graphics.drawCentered(kaktusImg, kaktus.x, kaktus.y, 1, 1)
    Player.draw()
    love.graphics.setBackgroundColor(0.9, 0.8, 0.5)
end
return Pustynia
