-- Import modułów
local Efekty = require("src.efekty")
local Monety = require("src.monety")
local Player = require("src.player")
local Sople = require("src.sople")
local UI = require("src.ui")
local Zapis = require("src.zapis")
local Sklepik = require("src.sklepik")
local Dialog = require("src.dialog")

local flux = require("plugins.flux")

---------------------
-- Wczytywanie gry
---------------------
function love.load()
    szerokosc, wysokosc = love.graphics.getDimensions()

    -- Teksty śmierci
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

    -- Ustawienia gry
    poziomy = { "Latwy", "Trudny", "Niemozliwy" }
    aktualny_poziom = 1
    szybkosci_dodawania = { 5, 3, 1 }
    szybkosci_tla = { 0.02, 0.05, 0.1 }
    czerwien = 0

    -- Grafiki
    sklepikImg = love.graphics.newImage("gfx/sklepik.png")
    font = love.graphics.newFont("assets/fonts/font.ttf", 40)
    serce = love.graphics.newImage("gfx/serce.png")
    pusteserce = love.graphics.newImage("gfx/pusteserce.png")
    playerImg = love.graphics.newImage("gfx/gracz.png")
    spioszekImg = love.graphics.newImage("gfx/spioszek.png")

    -- Bohaterowie dialogów
    Dialog.bohater("Narrator", "gfx/narrator.png")
    Dialog.bohater("Gracz", "gfx/player_face.png")
    Dialog.bohater("Sklepikarz", "gfx/shop.png")

    -- Dialog startowy (fabularne intro)
    Dialog.wiadomosc("Narrator", "Świat tonie w lodzie... Sople spadają z nieba, bez litości.")
    Dialog.wiadomosc("Narrator", "Jesteś jedynym, który może przetrwać i znaleźć przejście do nowych światów.")
    Dialog.wiadomosc("Gracz", "Serio? To brzmi jak głupi żart...")
    Dialog.wiadomosc("Narrator", "Zbieraj monety, kupuj ulepszenia i może... może uda ci się ujść z życiem.")

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

    sklepik = { x = love.math.random(0, szerokosc - 50), y = -100, width = 50, height = 50 }

    local ilosc_sopli = 5
    Sople.spawn(ilosc_sopli)

    local ilosc_monet = 3
    Monety.spawn(ilosc_monet)

    predkoscGracza = 3
    zycia = 1
    niesmiertelny = 0
    wstrzasy = 0
    czas = 0
    punkty = 0
    najlepszy_wynik = 0
    wynik_koniec = 0
    zebraneMonety = 0
    aktualnySwiat = "Zima" -- startowy świat

    zapisek = Zapis.wczytaj()
    najlepszy_wynik = zapisek.najlepszy_wynik
    zebraneMonety = zapisek.monety

    stan = { menu = {}, gra = {}, przegrana = {} }
    stanGry = stan.menu

    love.graphics.setFont(font)

    przyciskStart = { x = szerokosc / 2 - 100, y = wysokosc / 2, width = 200, height = 50 }
    przyciskTryb = { x = szerokosc / 2 - 100, y = wysokosc / 2 - 80, width = 200, height = 50 }
end

---------------------
-- Główna pętla gry
---------------------
function love.update(dt)
    if love.keyboard.isDown("escape") then love.event.quit() end

    Dialog.update(dt)

    -- Jeśli sklepik otwarty, pauzujemy grę
    if Sklepik.aktywny then
        UI.update()
        flux.update(dt)
        return
    end

    if stanGry == stan.gra then
        niesmiertelny = niesmiertelny - dt
        wstrzasy = wstrzasy - dt
        czerwien = math.min(1, czerwien + dt * szybkosci_tla[aktualny_poziom])

        if love.keyboard.isDown("a") then gracz.x = gracz.x - predkoscGracza end
        if love.keyboard.isDown("d") then gracz.x = gracz.x + predkoscGracza end

        gracz.x = math.max(0, math.min(szerokosc - gracz.width, gracz.x))

        if najlepszy_wynik < punkty then
            najlepszy_wynik = punkty
        end

        local spioszek = (gracz.skin == spioszekImg)
        Sople.update(dt, spioszek)
        Monety.update(dt)

        -- Ruch i kolizja sklepiku
        sklepik.y = sklepik.y + 2
        if sklepik.y > wysokosc then
            sklepik.y = -100
            sklepik.x = love.math.random(0, szerokosc - sklepik.width)
        end
        if kolizja(gracz, sklepik) then
            Sklepik.otworz()
            Dialog.wiadomosc("Sklepikarz", "Ej, ty! Mam towary, które ci pomogą.")
            Dialog.wiadomosc("Sklepikarz", "Życia, szybkość, a nawet nowe światy. Co wybierasz?")
            sklepik.y = -100
            sklepik.x = love.math.random(0, szerokosc - sklepik.width)
        end

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

        -- Tła zależne od świata
        if aktualnySwiat == "Zima" then
            love.graphics.clear(czerwien, 0.8, 1, 1)
        elseif aktualnySwiat == "Lato" then
            love.graphics.clear(0.4, 0.8, 0.2, 1)
        elseif aktualnySwiat == "Piekło" then
            love.graphics.clear(0.8, 0.2, 0.2, 1)
        end

        Efekty.wstrzasyZMoca(10)
        Sople.draw()
        Monety.draw()
        if not Sklepik.aktywny then
            love.graphics.draw(sklepikImg, sklepik.x, sklepik.y)
        end
        if gracz.skin == spioszekImg then
            Efekty.latarka(gracz.x + gracz.ox, gracz.y + gracz.oy)
        end
        Player.draw()
        Efekty.koniecWstrzasow()

        Efekty.rysujLadowanie()
        UI.rysujSerca()

        love.graphics.setColor(0, 0, 0)
        love.graphics.print("Punkty: " .. punkty, 10, 10)
        love.graphics.print("Najlepszy wynik: " .. najlepszy_wynik, 10, 50)
        love.graphics.print("Monety: " .. zebraneMonety, 10, 90)
        love.graphics.print("Świat: " .. aktualnySwiat, 10, 130)

        Sklepik.draw()
    elseif stanGry == stan.przegrana then
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(losowyTekst, font, 0, wysokosc / 2 - 20, szerokosc, "center")
        love.graphics.printf("Wynik: " .. wynik_koniec, font, 0, wysokosc / 2 + 40, szerokosc, "center")
        love.graphics.printf("Najlepszy wynik: " .. najlepszy_wynik, font, 0, wysokosc / 2 + 80, szerokosc, "center")
        love.graphics.printf("Monety: " .. zebraneMonety, font, 0, wysokosc / 2 + 120, szerokosc, "center")
        Efekty.rysujLadowanie()
    end

    -- Rysowanie dialogów
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
