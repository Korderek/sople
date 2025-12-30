local Pustynia = {}
local UI = require("src.ui")
local Player = require("src.player")
local Efekty = require("src.efekty")
local Wyzwania = require("planety.pustynia.wyzwania")
local Sklepik = require("src.sklepik")
local Sound = require("src.sound")

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

function Pustynia.load()
    dystans = 0
    czas = 0
    punkty = 0
    wynik_koniec = 0
    aktywne_wyzwanie = nil
    wslizg = 0
    na_ziemi = true
    krok = 0

    gracz.y = poziomZiemi
    gracz.x = 300
    gracz.height = 150
    gracz.predkoscx = 12
    gracz.predkoscy = 0
    gracz.predkosc_mnoznik = 1
    gracz.robi_krok = false
    gracz.idzie = true
end

function nowyptak(x, y)
    table.insert(listaprzeszkod, {
        x = szerokosc + (x or 0),
        y = poziomZiemi - (y or 0),
        tekstura = ptakImg,
        predkosc = love.math.random(7, 9),
        width = ptakImg:getWidth(),
        height = ptakImg:getHeight(),
        wave = love.math.random() * 2 * math.pi,
        po_kolizji = function(self)
            if wslizg > -0.3 and na_ziemi then
                -- unik
            else
                gracz.obrywa()
            end
        end
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
            y = poziomZiemi - love.math.random(50, 0),
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

local function nowywielbladprzod(x, w_prawo)
    table.insert(listaprzeszkod, {
        x = szerokosc + (x or 0),
        y = poziomZiemi - 200,
        sx = w_prawo and 1 or -1,
        tekstura = wielbladprzodImg,
        predkosc = 0,
        width = wielbladprzodImg:getWidth(),
        height = wielbladprzodImg:getHeight(),
        ponad_graczem = true,
        po_kolizji = function(self)
            if wslizg > -0.2 and na_ziemi then
                --unik
            else
                gracz.obrywa()
            end
        end
    })
end

local function nowywielbladtyl(x, w_prawo)
    table.insert(listaprzeszkod, {
        x = szerokosc + (x or 0),
        y = poziomZiemi - 200,
        sx = w_prawo and 1 or -1,
        tekstura = wielbladtylImg,
        predkosc = 0,
        width = wielbladtylImg:getWidth(),
        height = wielbladtylImg:getHeight(),
        po_kolizji = function() end
    })
end

function nowywielblad(x)
    local w_prawo = szansa(50)
    nowywielbladprzod(x, w_prawo)
    nowywielbladtyl(x, w_prawo)
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
    if wslizg < -0.3 and love.keyboard.isDown("s") then
        --rozpoczęcie wślizgu
        Sound.wslizg()
        wslizg = 0.5
    end
    gracz.predkosc_mnoznik = 1
    gracz.height = 150
    if wslizg > 0 then
        gracz.height = 80
        gracz.predkosc_mnoznik = 2
        if wslizg < 0.2 then
            gracz.predkosc_mnoznik = 0.9
        end
    end

    krok = krok - dt
    if krok < 0 and na_ziemi then
        Sound.kroki_piasek()
        gracz.robi_krok = not gracz.robi_krok
        krok = krok + 0.3 * 12 / gracz.predkoscx
    end

    gracz.predkoscx = gracz.predkoscx + 0.002
    local predkoscx = gracz.predkoscx * gracz.predkosc_mnoznik
    punkty = punkty + predkoscx * dt / 10
    czas = czas + dt
    dystans = dystans - predkoscx

    if not aktywne_wyzwanie then
        aktywne_wyzwanie = Wyzwania.losuj()
        aktywne_wyzwanie.przeszkody()
        aktywne_wyzwanie.odleglosc = -szerokosc
    else
        aktywne_wyzwanie.odleglosc = aktywne_wyzwanie.odleglosc + predkoscx
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
                gracz.obrywa()
            end
        end
        przeszkoda.x = przeszkoda.x - przeszkoda.predkosc - predkoscx
        if przeszkoda.wave then
            przeszkoda.y = przeszkoda.y + math.sin(czas + przeszkoda.wave)
        end
    end

    local przyspieszenie = 1.60
    if love.keyboard.isDown("w") and gracz.y == poziomZiemi then
        przyspieszenie = -39
        na_ziemi = false
        gracz.robi_krok = false
        Sound.skok_odbicie()
    end
    gracz.predkoscy = gracz.predkoscy + przyspieszenie
    gracz.y = gracz.y + gracz.predkoscy
    if gracz.y > poziomZiemi then
        gracz.y = poziomZiemi
        gracz.predkoscy = 0
        if not na_ziemi then
            Sound.skok_ladowanie()
            na_ziemi = true
            gracz.robi_krok = false
        end
    end
end

local function przeszkoda_draw(przeszkoda)
    local sx = przeszkoda.sx or 1
    local x = przeszkoda.x + (sx == -1 and przeszkoda.width or 0)
    love.graphics.draw(przeszkoda.tekstura, x, przeszkoda.y, 0, sx, 1)
    love.graphics.rectangleDebug(przeszkoda.x, przeszkoda.y, przeszkoda.width, przeszkoda.height)
end

function Pustynia.draw()
    love.graphics.drawStretched(pustyniaImg, 0, 0, szerokosc, wysokosc)
    love.graphics.setBackgroundColor(0.9, 0.8, 0.5)
    Efekty.wstrzasyZMoca(10)
    love.graphics.loopHorizontally(ziemiaImg, dystans, poziomZiemi + 20, 1, 1)
    for _, przeszkoda in ipairs(listaprzeszkod) do
        przeszkoda_draw(przeszkoda)
    end
    Player.draw()
    for _, przeszkoda in ipairs(listaprzeszkod) do
        if przeszkoda.ponad_graczem then
            przeszkoda_draw(przeszkoda)
        end
    end
    Sklepik.draw()
    UI.rysujSerca()
    love.graphics.print(math.floor(punkty), 10, 10)
end

return Pustynia
