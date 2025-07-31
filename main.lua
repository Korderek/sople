-- main.lua
local monety = require("src.monety")
local sople = require("src.sople")
local player = require("src.player")
local ui = require("src.ui")

function love.load()
    szerokosc, wysokosc = love.graphics.getDimensions()

    poziomy = { "Latwy", "Trudny", "Niemozliwy" }
    aktualny_poziom = 1
    szybkosci_dodawania = { 5, 3, 1 }
    szybkosci_tla = { 0.02, 0.05, 0.1 }
    czerwien = 0

    serce = love.graphics.newImage("gfx/serce.png")
    pusteserce = love.graphics.newImage("gfx/pusteserce.png")
    playerImg = love.graphics.newImage("gfx/gracz.png")
    spioszekImg = love.graphics.newImage("gfx/spioszek.png")

    gracz = {
        x = math.max(0, math.min(100, szerokosc - 50)),
        y = 970,
        width = 50,
        height = 100,
        scale = 2.0,
        ox = 25,
        oy = 100,
        skin = playerImg
    }

    local ilosc_sopli = 5
    sople.spawn(ilosc_sopli)

    local ilosc_monet = 3
    monety.spawn(ilosc_monet)

    zycia = 3
    niesmiertelny = 0
    wstrzasy = 0
    czas = 0
    punkty = 0
    wynik_koniec = 0
    zebraneMonety = 0

    stan = { menu = {}, gra = {}, przegrana = {} }
    stanGry = stan.menu

    font = love.graphics.newFont(40)
    love.graphics.setFont(font)

    przyciskStart = { x = szerokosc / 2 - 100, y = wysokosc / 2, width = 200, height = 50 }
    przyciskTryb = { x = szerokosc / 2 - 100, y = wysokosc / 2 - 80, width = 200, height = 50 }
end

function love.update(dt)
    if love.keyboard.isDown("escape") then love.event.quit() end
    ui.update()

    if stanGry == stan.gra then
        niesmiertelny = niesmiertelny - dt
        wstrzasy = wstrzasy - dt

        czerwien = math.min(1, czerwien + dt * szybkosci_tla[aktualny_poziom])
        punkty = math.floor(czas)

        if love.keyboard.isDown("a") then gracz.x = gracz.x - 3 end
        if love.keyboard.isDown("d") then gracz.x = gracz.x + 3 end

        gracz.x = math.max(0, math.min(szerokosc - gracz.width, gracz.x))

        -- Zmiana skina na śpioszka po zebraniu 5 monet
        if zebraneMonety >= 1 then
            gracz.skin = spioszekImg
        end

        -- Przekazujemy info o śpioszku do sopli
        local spioszek = (gracz.skin == spioszekImg)
        sople.update(dt, spioszek)
        monety.update(dt)

        if zycia < 1 and wstrzasy < 0 then
            wynik_koniec = punkty
            stanGry = stan.przegrana
        end
    end
end

function love.draw()
    if stanGry == stan.menu then
        love.graphics.setBackgroundColor(0.5, 0.8, 1, 1)
        if ui.przycisk(przyciskTryb, poziomy[aktualny_poziom]) then
            aktualny_poziom = aktualny_poziom % #poziomy + 1
        end
        if ui.przycisk(przyciskStart, "LECIMY") then
            stanGry = stan.gra
        end
    elseif stanGry == stan.gra then
        love.graphics.setColor(1, 1, 1)
        love.graphics.clear(czerwien, 0.8, 1, 1)
        if wstrzasy > 0 then
            love.graphics.translate(love.math.random(-10, 10), love.math.random(-10, 10))
        end
        rysujSerca()
        sople.draw()
        monety.draw()
        --jeżeli gracz jest śpioszkiem, to przyciemniamy ekran
        if gracz.skin == spioszekImg then
            love.graphics.stencil(function()
                love.graphics.circle("fill", gracz.x + gracz.ox, gracz.y + gracz.oy, 150)
            end, "replace", 1)
            love.graphics.setStencilTest("less", 1)
            love.graphics.setColor(0, 0, 0, 0.9)
            love.graphics.rectangle("fill", -szerokosc / 5, -wysokosc / 5, szerokosc * 5, wysokosc * 5)
            love.graphics.setColor(1, 1, 1, 0.25)
            love.graphics.setStencilTest()
        end
        player.draw()
        love.graphics.setColor(0, 0, 0)
        love.graphics.print("Punkty: " .. punkty, 10, 10)
        love.graphics.print("Monety: " .. zebraneMonety, 10, 50)
    elseif stanGry == stan.przegrana then
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf("Sople Cie pociely. Boli?", font, 0, wysokosc / 2 - 20, szerokosc, "center")
        love.graphics.printf("Wynik: " .. wynik_koniec, font, 0, wysokosc / 2 + 40, szerokosc, "center")
        love.graphics.printf("Monety: " .. zebraneMonety, font, 0, wysokosc / 2 + 80, szerokosc, "center")
    end
end

function kolizja(a, b)
    return a.x < b.x + b.width and a.x + a.width > b.x and a.y < b.y + b.height and a.y + a.height > b.y
end

function rysujSerca()
    local skala = 0.05
    local rozmiar = 555 * skala
    for i = 1, 3 do
        local x = szerokosc - i * (rozmiar + 5)
        local y = 10
        if i <= zycia then
            love.graphics.draw(serce, x, y, 0, skala, skala)
        else
            love.graphics.draw(pusteserce, x, y, 0, skala, skala)
        end
    end
end
