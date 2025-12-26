local Jaskinia = {}

-- Import niezbędnych modułów
local Efekty = require("src.efekty")
local Player = require("src.player")
local Sople = require("src.sople")
local Boss = require("planety.jaskinia.boss")
local Monety = require("src.monety")
local Sklepik = require("src.sklepik")
local UI = require("src.ui")

function Jaskinia.load()
    -- Inicjalizacja zmiennych specyficznych dla jaskini
end

function Jaskinia.update(dt)
    czerwien = math.min(1, czerwien + dt * szybkosci_tla[aktualny_poziom])
    krok = krok - dt
    if krok < 0 then
        gracz.idzie = not gracz.idzie
        krok = krok + 0.3
    end
    local przyspieszenie = 0
    if wslizg < -1 and love.keyboard.isDown("s") and wslizgAktywny then
        --rozpoczęcie wślizgu
        wslizg = 0.4
    end
    if wslizg < 0 then
        if love.keyboard.isDown("a") then
            gracz.kierunek = "lewo"
            przyspieszenie = -gracz.przyspieszenie
        end
        if love.keyboard.isDown("d") then
            gracz.kierunek = "prawo"
            przyspieszenie = gracz.przyspieszenie
        end
    end
    if wslizg > 0 then
        if gracz.kierunek == "lewo" then
            przyspieszenie = -gracz.przyspieszenie
        else
            przyspieszenie = gracz.przyspieszenie
        end
        if wslizg < 0.2 then
            przyspieszenie = przyspieszenie * 0.8
        else
            przyspieszenie = przyspieszenie * 2.5
        end
    end
    if przyspieszenie == 0 then
        gracz.idzie = false
        krok = 0
    end
    gracz.predkosc = gracz.predkosc * tarcie + przyspieszenie
    gracz.x = gracz.x + gracz.predkosc

    gracz.x = math.max(0, math.min(szerokosc - gracz.width, gracz.x))


    if najlepszy_wynik < punkty then
        najlepszy_wynik = punkty
    end

    Sople.update(dt)
    Monety.update(dt)

    -- Ruch i kolizja sklepiku
    sklepik.y = sklepik.y + 2
    if sklepik.y > wysokosc then
        sklepik.y = -sklepikImg:getHeight()
        sklepik.x = love.math.random(0, szerokosc - sklepik.width)
    end
    if kolizja(gracz, sklepik) then
        Sklepik.otworz()
        sklepik.y = -sklepikImg:getHeight()
        sklepik.x = love.math.random(0, szerokosc - sklepik.width)
    end
end

function Jaskinia.draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.drawStretched(jaskiniaImg, 0, 0, szerokosc, wysokosc)
    love.graphics.setColor(czerwien, 0.8, 1, 0.3)
    love.graphics.rectangle("fill", 0, 0, szerokosc, wysokosc)
    love.graphics.setColor(1, 1, 1, 1)

    Efekty.wstrzasyZMoca(10)
    Boss.draw()
    Sople.draw()
    Monety.draw()
    if not Sklepik.aktywny then
        love.graphics.drawCentered(sklepikImg, sklepik.x, sklepik.y, sklepik.width, sklepik.height)
        love.graphics.rectangleDebug(sklepik.x, sklepik.y, sklepik.width, sklepik.height)
    end
    if gracz.skin == spioszekImg then
        Efekty.latarka(gracz.x + gracz.width / 2, gracz.y + gracz.height / 2)
    end
    Player.draw()
    Efekty.koniecWstrzasow()
    UI.rysujSerca()

    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Punkty: " .. punkty, 10, 10)
    love.graphics.print("Najlepszy wynik: " .. najlepszy_wynik, 10, 65)
    love.graphics.print(zebraneMonety, 75, 120)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(stosMonet, 10, 125)
end

return Jaskinia
