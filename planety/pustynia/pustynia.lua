local Pustynia = {}
local UI = require("src.ui")
local Player = require("src.player")
local Efekty = require("src.efekty")
local Wyzwania = require("planety.pustynia.wyzwania")
local Sklepik = require("src.sklepik")

local listaprzeszkod = {}

local poziomZiemi = 730


local kaktusImg = love.graphics.newImage("gfx/kaktus.png")
local kaktusImg2 = love.graphics.newImage("gfx/maly-kaktus.png")
local straganImg = love.graphics.newImage("gfx/stragan.png")
local ziemiaImg = love.graphics.newImage("gfx/ziemia.png")
local pustyniaImg = love.graphics.newImage("gfx/pustynia.png")
local ptakImg = love.graphics.newImage("gfx/sep.png")
local szkieletImg = love.graphics.newImage("gfx/szkielet.png")
local wielbladprzodImg = love.graphics.newImage("gfx/wielblad-przod.png")
local wielbladtylImg = love.graphics.newImage("gfx/wielblad-tyl.png")

Pustynia.load = function()
    dystans = 0
    czas = 0
    punkty = 0
    wynik_koniec = 0
    aktywne_wyzwanie = nil

    gracz.y = poziomZiemi
    gracz.x = 300
    gracz.predkoscx = 10
    gracz.predkoscy = 0
end

function nowyptak(x, y)
    table.insert(listaprzeszkod, {
        x = szerokosc + (x or 0),
        y = poziomZiemi - (y or 0),
        tekstura = ptakImg,
        predkosc = 8,
        width = ptakImg:getWidth(),
        height = ptakImg:getHeight(),
    })
end

function nowykaktus(x)
    if szansa(50) then
        table.insert(listaprzeszkod, {
            x = szerokosc + (x or 0),
            y = poziomZiemi - love.math.random(70, 110),
            tekstura = kaktusImg,
            predkosc = 0,
            width = kaktusImg:getWidth(),
            height = kaktusImg:getHeight()
        })
    else
        table.insert(listaprzeszkod, {
            x = szerokosc + (x or 0),
            y = poziomZiemi - love.math.random(70, 0),
            tekstura = kaktusImg2,
            predkosc = 0,
            width = kaktusImg:getWidth(),
            height = kaktusImg:getHeight()
        })
    end
end

function nowyszkielet(x)
    table.insert(listaprzeszkod, {
        x = szerokosc + (x or 0),
        y = poziomZiemi,
        tekstura = szkieletImg,
        predkosc = 0,
        width = szkieletImg:getWidth(),
        height = szkieletImg:getHeight()
    })
end

function nowywielbladprzod(x)
    table.insert(listaprzeszkod, {
        x = szerokosc + (x or 0),
        y = poziomZiemi - 200,
        tekstura = wielbladprzodImg,
        predkosc = 0,
        width = wielbladprzodImg:getWidth(),
        height = wielbladprzodImg:getHeight()
    })
end

function nowywielbladtyl(x)
    table.insert(listaprzeszkod, {
        x = szerokosc + (x or 0),
        y = poziomZiemi - 200,
        tekstura = wielbladtylImg,
        predkosc = 0,
        width = wielbladtylImg:getWidth(),
        height = wielbladtylImg:getHeight()
    })
end

function nowysklepik(x)
    table.insert(listaprzeszkod, {
        x = szerokosc + (x or 0),
        y = poziomZiemi - 200,
        tekstura = straganImg,
        predkosc = 0,
        width = straganImg:getWidth(),
        height = straganImg:getHeight(),
        aktywny = true,
        po_kolizji = function(self)
            if self.aktywny then
                Sklepik.otworz()
                self.aktywny = false
            end
        end
    })
end

function Pustynia.update(dt)
    gracz.predkoscx = gracz.predkoscx + 0.001
    punkty = punkty + gracz.predkoscx * dt / 10
    czas = czas + dt
    dystans = dystans - gracz.predkoscx

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
            if przeszkoda.po_kolizji then
                przeszkoda:po_kolizji()
            else
                zycia = zycia - 1
                niesmiertelny = 2
                wstrzasy = 0.3
                oberwal = 1
            end
        end
        przeszkoda.x = przeszkoda.x - przeszkoda.predkosc - gracz.predkoscx
    end

    local przyspieszenie = 0
    if love.keyboard.isDown("w") and gracz.y == poziomZiemi then
        przyspieszenie = -37
    end
    przyspieszenie = przyspieszenie + 1.56
    gracz.predkoscy = gracz.predkoscy + przyspieszenie
    gracz.y = gracz.y + gracz.predkoscy
    if gracz.y > poziomZiemi then
        gracz.y = poziomZiemi
        gracz.predkoscy = 0
    end
end

Pustynia.draw = function()
    love.graphics.drawStretched(pustyniaImg, 0, 0, szerokosc, wysokosc)
    love.graphics.setBackgroundColor(0.9, 0.8, 0.5)
    Efekty.wstrzasyZMoca(10)
    love.graphics.loopHorizontally(ziemiaImg, dystans, poziomZiemi + 20, 1, 1)
    for _, przeszkoda in ipairs(listaprzeszkod) do
        love.graphics.draw(przeszkoda.tekstura, przeszkoda.x, przeszkoda.y)
        love.graphics.rectangleDebug(przeszkoda.x, przeszkoda.y, przeszkoda.width, przeszkoda.height)
    end
    Player.draw()
    Sklepik.draw()
    UI.rysujSerca()
    love.graphics.print(math.floor(punkty), 10, 10)
end
return Pustynia
