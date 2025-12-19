-- Import modułów
local Boss = require("planety.jaskinia.boss")
local Dialog = require("src.dialog")
local Efekty = require("src.efekty")
local Monety = require("src.monety")
local Player = require("src.player")
local Przegrana = require("planety.przegrana")
local Pustynia = require("planety.pustynia.pustynia")
local Sklepik = require("src.sklepik")
local Sople = require("src.sople")
local Swiaty = require("src.swiaty")
local UI = require("src.ui")
local Wygrana = require("planety.wygrana")
local Zapis = require("src.zapis")
local Jaskinia = require("planety.jaskinia.jaskinia")


local flux = require("plugins.flux")

---------------------
-- Wczytywanie gry
---------------------
function love.load()
    szerokosc, wysokosc = love.graphics.getDimensions()

    -- Ustawienia gry
    poziomy = { "Latwy", "Trudny", "Niemozliwy" }
    aktualny_poziom = 1
    szybkosci_dodawania = { 5, 3, 1 }
    szybkosci_tla = { 0.02, 0.05, 0.1 }
    czerwien = 0

    debug = false -- włącz debugowanie

    -- Fonty
    font = love.graphics.newFont("assets/fonts/font.ttf", 40)
    font_small = love.graphics.newFont("assets/fonts/font.ttf", 28)

    -- Grafiki
    sklepikImg = love.graphics.newImage("gfx/sklepik.png")
    serce = love.graphics.newImage("gfx/serce.png")
    pusteserce = love.graphics.newImage("gfx/pusteserce.png")
    stosMonet = love.graphics.newImage("gfx/stos-monet.png")
    playerImg = love.graphics.newImage("gfx/gracz.png")
    spioszekImg = love.graphics.newImage("gfx/spioszek.png")
    jaskiniaImg = love.graphics.newImage("gfx/jaskinia.png")

    -- Portrety do dialogów
    Dialog.bohater("Janusz", "gfx/portrety/facet.png")
    Dialog.bohater("Michał", "gfx/portrety/dziecko.png")
    Dialog.bohater("Sprzedawca", "gfx/portrety/sprzedawca.png")

    -- Dialog początkowy
    Dialog.wiadomosc("Janusz", "Daj 2 złote na Harnasia")
    Dialog.wiadomosc("Michał", "Nie mam, ale mogę dać 1 złoty")
    Dialog.wiadomosc("Janusz", "Daj 2 złote mistrzu")
    Dialog.wiadomosc("Janusz", "miłego dnia")
    Dialog.wyczysc()

    gracz = {
        x = math.max(0, math.min(100, szerokosc - 50)),
        y = 900,
        width = 50,
        height = 80,
        scale = 1.0,
        skin = playerImg,
        kierunek = "prawo",
        przyspieszenie = 2.18,
        predkosc = 0,
        idzie = true
    }
    function gracz.obrywa()
        zycia = zycia - 1
        niesmiertelny = 2
        wstrzasy = 0.3
        oberwal = 1
    end

    sklepik = { x = love.math.random(0, szerokosc - 50), y = -100, width = 100, height = 100 }

    local ilosc_sopli = 5
    Sople.spawn(ilosc_sopli)

    local ilosc_monet = 3
    Monety.spawn(ilosc_monet)

    -- Timery
    krok = 0
    radosny = 0
    oberwal = 0
    wslizg = 0
    niesmiertelny = 0
    wstrzasy = 0
    czas_gry = 0
    czas = 0

    -- Inne zmienne gry
    tarcie = 0.74
    zycia = 3
    maxZycia = zycia
    wslizgAktywny = false
    punkty = 0
    najlepszy_wynik = 0
    wynik_koniec = 0
    zebraneMonety = 0
    czas_bossa = 3

    fps_reszta = 0

    zapisek = Zapis.wczytaj()
    najlepszy_wynik = zapisek.najlepszy_wynik
    zebraneMonety = zapisek.monety

    stan = { menu = {}, sople = {}, przegrana = {}, swiaty = {}, pustynia = {}, wygrana = {} }
    stanGry = stan.sople
    Pustynia.load()

    love.graphics.setFont(font)

    przyciskStart = { x = szerokosc / 2 - 100, y = wysokosc / 2, width = 200, height = 50 }
    przyciskTryb = { x = szerokosc / 2 - 100, y = wysokosc / 2 - 80, width = 200, height = 50 }
end

---------------------
-- Główna pętla gry
---------------------
function love.update(dt)
    fps_reszta = fps_reszta + dt
    if fps_reszta < 1 / 60 then
        return
    end

    fps_reszta = fps_reszta - 1 / 60
    dt = 1 / 60

    -- Szybkie zamykanie gry pod ESC
    if love.keyboard.isDown("escape") then love.event.quit() end

    -- Czy gracz dotarł do bossa?
    if czas_gry > czas_bossa and (stanGry == stan.sople or stanGry == stan.pustynia) then
        Dialog.wyczysc()
        Boss.przywolaj()
    end

    -- Czy gracz przegrał grę?
    if zycia < 1 and wstrzasy < 0 and (stanGry == stan.sople or stanGry == stan.pustynia) then
        Przegrana.load()
    end

    -- Uruchomienie podsystemów
    Dialog.update(dt)
    Boss.update(dt)
    UI.update()
    flux.update(dt)

    -- Timery
    niesmiertelny = niesmiertelny - dt
    radosny = radosny - dt
    oberwal = oberwal - dt
    wslizg = wslizg - dt
    wstrzasy = wstrzasy - dt
    if (stanGry == stan.sople or stanGry == stan.pustynia) and not Sklepik.aktywny then
        czas_gry = czas_gry + dt
    end

    -- Jeśli sklepik otwarty, nie aktualizujemy gry
    if Sklepik.aktywny then
        return
    end

    if stanGry == stan.sople then
        Jaskinia.update(dt)
    elseif stanGry == stan.pustynia then
        Pustynia.update(dt)
    end
end

---------------------
-- Rysowanie gry
---------------------
function love.draw()
    if stanGry == stan.menu then
        love.graphics.setBackgroundColor(0.5, 0.8, 1, 1)
        if UI.przycisk(przyciskTryb, poziomy[aktualny_poziom]) then
            aktualny_poziom = aktualny_poziom % #poziomy + 1
        end
        if UI.przycisk(przyciskStart, "LECIMY") then
            Efekty.rozpocznijLadowanie(function() stanGry = stan.swiaty end)
        end
    elseif stanGry == stan.sople then
        Jaskinia.draw()
    elseif stanGry == stan.przegrana then
        Przegrana.draw()
    elseif stanGry == stan.wygrana then
        Wygrana.draw()
    elseif stanGry == stan.swiaty then
        Swiaty.draw()
    elseif stanGry == stan.pustynia then
        Pustynia.draw()
    end

    love.graphics.setColor(1, 1, 1)
    Sklepik.draw()
    Efekty.rysujLadowanie()
    Dialog.draw()
end

function love.quit()
    Zapis.zapisz({ najlepszy_wynik = najlepszy_wynik, monety = zebraneMonety })
end

-----------------------
-- Funkcje pomocnicze
-----------------------
function kolizja(a, b)
    return a.x < b.x + b.width and
        a.x + a.width > b.x and
        a.y < b.y + b.height and
        a.y + a.height > b.y
end

-- Rysuje obrazek na środku prostokąta
function love.graphics.drawCentered(image, x, y, width, height, scaleX, scaleY)
    local ox = image:getWidth() / 2
    local oy = image:getHeight() / 2
    love.graphics.draw(image, x + width / 2, y + height / 2, 0, scaleX or 1, scaleY or 1, ox, oy)
end

-- Rysuje quad na środku prostokąta
function love.graphics.drawQuadCentered(image, quad, x, y, width, height, scaleX, scaleY)
    local _, _, quad_w, quad_h = quad:getViewport()
    local ox = quad_w / 2
    local oy = quad_h / 2
    love.graphics.draw(image, quad, x + width / 2, y + height / 2, 0, scaleX or 1, scaleY or 1, ox, oy)
end

-- Wyświetla tekst na środku prostokąta
function love.graphics.printCentered(text, font, x, y, width, height)
    love.graphics.printf(text, font, x, y + height / 2 - font:getHeight() / 2, width, "center")
end

-- Rysuje prostokąt jeśli debugowanie jest włączone
function love.graphics.rectangleDebug(x, y, width, height)
    if debug then
        local r, g, b, a = love.graphics.getColor()
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle("line", x, y, width, height)
        love.graphics.setColor(r, g, b, a) -- przywracamy poprzedni kolor
    end
end

-- Rysuje grafikę tak, aby wypełniła podany prostokąt
function love.graphics.drawStretched(drawable, x, y, width, height)
    local sx = width / drawable:getWidth()
    local sy = height / drawable:getHeight()
    love.graphics.draw(drawable, x, y, 0, sx, sy)
end

-- Rysuje grafikę z zapętleniem w poziomie
function love.graphics.loopHorizontally(drawable, x, y, sx, sy)
    local w = drawable:getWidth() * sx
    local startX = x % w
    local startY = y
    if startX > 0 then
        startX = startX - w
    end
    while startX < szerokosc do
        love.graphics.draw(drawable, startX, startY, 0, sx, sy)
        startX = startX + w
    end
end
