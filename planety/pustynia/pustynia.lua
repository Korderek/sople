local Pustynia = {}
local UI = require("src.ui")
local Player = require("src.player")
local Efekty = require("src.efekty")
local Wyzwania = require("planety.pustynia.wyzwania")


local listaziemi = {}
local listaprzeszkod = {}

local poziomZiemi = 400


local kaktusImg = love.graphics.newImage("gfx/kaktus.png")
local ziemiaImg = love.graphics.newImage("gfx/ziemia.png")
local pustyniaImg = love.graphics.newImage("gfx/pustynia.png")
local ptakImg = love.graphics.newImage("gfx/sep.png")
local szkieletImg = love.graphics.newImage("gfx/szkielet.png")
local wielbladprzodImg = love.graphics.newImage("gfx/wielblad-przod.png")
local wielbladtylImg = love.graphics.newImage("gfx/wielblad-tyl.png")

Pustynia.load = function()
    czas = 0
    punkty = 0
    wynik_koniec = 0
    aktywne_wyzwanie = nil

    gracz.y = 800
    gracz.x = 300
    gracz.predkoscx = 10
    gracz.predkoscy = 0


    for i = 0, 2 do
        table.insert(listaziemi, {
            x = i * ziemiaImg:getWidth(),
            y = 800,
        })
    end
end
function nowyptak(x, y)
    table.insert(listaprzeszkod, {
        x = szerokosc + (x or 0),
        y = poziomZiemi + (y or 0),
        tekstura = ptakImg,
        predkosc = 15,
        width = ptakImg:getWidth(),
        height = ptakImg:getHeight()
    })
end

function nowykaktus(x)
    table.insert(listaprzeszkod, {
        x = szerokosc + (x or 0),
        y = 800,
        tekstura = kaktusImg,
        predkosc = 0,
        width = kaktusImg:getWidth(),
        height = kaktusImg:getHeight()
    })
end

function nowyszkielet(x)
    table.insert(listaprzeszkod, {
        x = szerokosc + (x or 0),
        y = 800,
        tekstura = szkieletImg,
        predkosc = 0,
        width = szkieletImg:getWidth(),
        height = szkieletImg:getHeight()
    })
end

function nowywielbladprzod(x)
    table.insert(listaprzeszkod, {
        x = szerokosc + (x or 0),
        y = 800,
        tekstura = wielbladprzodImg,
        predkosc = 0,
        width = wielbladprzodImg:getWidth(),
        height = wielbladprzodImg:getHeight()
    })
end

function nowywielbladtyl(x)
    table.insert(listaprzeszkod, {
        x = szerokosc + (x or 0),
        y = 800,
        tekstura = wielbladtylImg,
        predkosc = 0,
        width = wielbladtylImg:getWidth(),
        height = wielbladtylImg:getHeight()
    })
end

function Pustynia.update(dt)
    gracz.predkoscx = gracz.predkoscx + 0.001
    punkty = punkty + gracz.predkoscx * dt / 10
    czas = czas + dt

    if not aktywne_wyzwanie then
        aktywne_wyzwanie = Wyzwania.losuj()
        aktywne_wyzwanie.przeszkody()
        aktywne_wyzwanie.odleglosc = -szerokosc
    else
        aktywne_wyzwanie.odleglosc = aktywne_wyzwanie.odleglosc + gracz.predkoscx
        if aktywne_wyzwanie.odleglosc >= aktywne_wyzwanie.szerokosc then
            aktywne_wyzwanie = nil
            przeszkody = {}
        end
    end

    for _, przeszkoda in ipairs(listaprzeszkod) do
        --Gdy gracz trafiony
        if niesmiertelny < 0 and kolizja(gracz, przeszkoda) then
            zycia = zycia - 1
            niesmiertelny = 2
            wstrzasy = 0.3
            oberwal = 1
        end
        przeszkoda.x = przeszkoda.x - przeszkoda.predkosc - gracz.predkoscx
    end

    for _, z in ipairs(listaziemi) do
        z.x = z.x - gracz.predkoscx
        if z.x < -ziemiaImg:getWidth() then
            z.x = szerokosc
        end
    end

    local przyspieszenie = 0
    if love.keyboard.isDown("w") and gracz.y == 800 then
        przyspieszenie = -37
    end
    przyspieszenie = przyspieszenie + 1.56
    gracz.predkoscy = gracz.predkoscy + przyspieszenie
    gracz.y = gracz.y + gracz.predkoscy
    if gracz.y > 800 then
        gracz.y = 800
        gracz.predkoscy = 0
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
    love.graphics.print(punkty, 10, 10)
end
return Pustynia
