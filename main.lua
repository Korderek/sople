-- Import modułów
local Efekty = require("src.efekty")
local Monety = require("src.monety")
local Player = require("src.player")
local Sople = require("src.sople")
local UI = require("src.ui")
local Zapis = require("src.zapis")


local flux = require("plugins.flux")

---------------------
-- Wczytywanie gry
---------------------
function love.load()
    szerokosc, wysokosc = love.graphics.getDimensions()

    teksty = {
        "Sople cię pocięły, boli?",
        "Sople: 1, Ty: 0. Chcesz się zrewanżować?",
        "W przyszłym życiu patrz więcej w górę.",
        "Ups, sopel znalazł twój łeb.",
        "To już koniec... znów przez sople.",
        "Nie zdążyłeś nawet krzyknąć 'ajć'.",
        "Kto by pomyślał, że lód może być tak śmiertelny?",
        "Sopel pozdrawia twoje czoło.",
        "A miałeś tak dobry plan...",
        "To był szybki koniec, gratulacje.",
        "Jak tam twoje unikanie sopli? Bo moje świetnie.",
        "I znowu lodowa porażka...",
        "Sopel trafił krytyka. Ty nie.",
        "Twoja głowa spotkała się z fizyką.",
        "Sople są zimne, ale ich intencje gorsze.",
        "No dobra, to może teraz bez dotykania lodu?",
        "Na szczęście to tylko gra... prawda?"
    }
    -- Inicjalizacja efektów
    poziomy = { "Latwy", "Trudny", "Niemozliwy" }
    aktualny_poziom = 1
    szybkosci_dodawania = { 5, 3, 1 }
    szybkosci_tla = { 0.02, 0.05, 0.1 }
    czerwien = 0

    font = love.graphics.newFont("assets/fonts/font.ttf", 40)
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
    Sople.spawn(ilosc_sopli)

    local ilosc_monet = 3
    Monety.spawn(ilosc_monet)

    zycia = 1
    niesmiertelny = 0
    wstrzasy = 0
    czas = 0
    punkty = 0
    najlepszy_wynik = 0
    wynik_koniec = 0
    zebraneMonety = 0

    zapisek = Zapis.wczytaj()
    najlepszy_wynik = zapisek.najlepszy_wynik
    zebraneMonety = zapisek.monety

    stan = { menu = {}, gra = {}, przegrana = {} }
    stanGry = stan.menu

    font = love.graphics.newFont(40)
    love.graphics.setFont(font)

    przyciskStart = { x = szerokosc / 2 - 100, y = wysokosc / 2, width = 200, height = 50 }
    przyciskTryb = { x = szerokosc / 2 - 100, y = wysokosc / 2 - 80, width = 200, height = 50 }
end

---------------------
-- Główna pętla gry
---------------------
function love.update(dt)
    -- zamknij grę po naciśnięciu escape
    if love.keyboard.isDown("escape") then love.event.quit() end

    if stanGry == stan.gra then
        niesmiertelny = niesmiertelny - dt
        wstrzasy = wstrzasy - dt

        czerwien = math.min(1, czerwien + dt * szybkosci_tla[aktualny_poziom])

        if love.keyboard.isDown("a") then gracz.x = gracz.x - 3 end
        if love.keyboard.isDown("d") then gracz.x = gracz.x + 3 end

        gracz.x = math.max(0, math.min(szerokosc - gracz.width, gracz.x))

        -- Zmiana skina na śpioszka po zebraniu 5 monet
        if zebraneMonety >= 1 then
            gracz.skin = spioszekImg
        end
        if najlepszy_wynik < punkty then
            najlepszy_wynik = punkty
        end

        -- Przekazujemy info o śpioszku do sopli
        local spioszek = (gracz.skin == spioszekImg)
        Sople.update(dt, spioszek)
        Monety.update(dt)

        if zycia < 1 and wstrzasy < 0 then
            wynik_koniec = punkty
            losowyTekst = teksty[love.math.random(#teksty)]
            Efekty.rozpocznijLadowanie(function() stanGry = stan.przegrana end)
        end
    end

    UI.update()
    flux.update(dt)
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
            Efekty.rozpocznijLadowanie(function() stanGry = stan.gra end)
        end
        Efekty.rysujLadowanie()
    elseif stanGry == stan.gra then
        love.graphics.setColor(1, 1, 1)
        love.graphics.clear(czerwien, 0.8, 1, 1)

        Efekty.wstrzasyZMoca(10)
        do -- wszystko co będzie rysowane później będzie pod wpływem wstrząsów
            Sople.draw()
            Monety.draw()
            --jeżeli gracz jest śpioszkiem, to przyciemniamy ekran
            if gracz.skin == spioszekImg then
                Efekty.latarka(gracz.x + gracz.ox, gracz.y + gracz.oy)
            end
            Player.draw()
        end -- kończymy wstrząsy, żeby nie wpływały na rysowanie UI
        Efekty.koniecWstrzasow()

        Efekty.rysujLadowanie()
        UI.rysujSerca()
        love.graphics.setColor(0, 0, 0)
        if gracz.skin == spioszekImg then
            love.graphics.setColor(1, 1, 1)
        end

        love.graphics.print("Punkty: " .. punkty, 10, 10)
        love.graphics.print("Najlepszy wynik: " .. najlepszy_wynik, 10, 50)
        love.graphics.print("Monety: " .. zebraneMonety, 10, 90)
    elseif stanGry == stan.przegrana then
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(losowyTekst, font, 0, wysokosc / 2 - 20, szerokosc, "center")
        love.graphics.printf("Wynik: " .. wynik_koniec, font, 0, wysokosc / 2 + 40, szerokosc, "center")
        love.graphics.printf("Najlepszy wynik: " .. najlepszy_wynik, font, 0, wysokosc / 2 + 80, szerokosc, "center")
        love.graphics.printf("Monety: " .. zebraneMonety, font, 0, wysokosc / 2 + 120, szerokosc, "center")
        Efekty.rysujLadowanie()
    end
end

function love.quit()
    Zapis.zapisz({ najlepszy_wynik = najlepszy_wynik, monety = zebraneMonety })
end

-----------------------
-- Funkcje pomocnicze
-----------------------

-- Sprawdzenie kolizji dwóch prostokątów
function kolizja(a, b)
    return a.x < b.x + b.width and a.x + a.width > b.x and a.y < b.y + b.height and a.y + a.height > b.y
end
