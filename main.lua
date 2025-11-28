-- Import modułów
local Efekty = require("src.efekty")
local Monety = require("src.monety")
local Player = require("src.player")
local Sople = require("src.sople")
local UI = require("src.ui")
local Zapis = require("src.zapis")
local Sklepik = require("src.sklepik")
local Dialog = require("src.dialog")
local Swiaty = require("src.swiaty")
local Pustynia = require("planety.pustynia.pustynia")

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
        "Na szczęście to tylko gra... prawda?",
        "Gdyby sopel miał poczucie humoru, to by się przedstawił.",
        "Okrzyk bojowy: 'Nie patrz w sufit!'",
        "Sople 2. Ty 0. Remis nie wchodzi w grę.",
        "Zimowa niespodzianka prosto na głowę.",
        "Może kup sobie kask z owczej wełny?",
        "Kolejna mikrowyprawa na lód zakończona sukcesem... dla sopla.",
        "Zapomniano dopisać 'nie dotykać'.",
        "Twoje włosy już wiedzą, że to koniec.",
        "Przynajmniej był efektowny upadek.",
        "Wygląda na to, że sopel miał lepszy timing niż ty.",
        "Znowu zaskoczony. Cóż za innowacja.",
        "Chwileczkę, czy sopel miał profil na Instagramie?",
        "Darmowy masaż głowy od natury.",
        "Sople: naturalne trampki dla głów.",
        "Chyba zasłużyłeś na medalik 'Ofiara Sopla'.",
        "Nie martw się, to tylko liść... z lodu.",
        "Może następnym razem załóż parasol?",
        "Gratulacje, właśnie wygrałeś lodową loterię.",
        "Twoja głowa osiągnęła nowe temperatury.",
        "Sople: twarde, zimne, bezlitosne.",
        "Zimowy zespół kryształów wykazał aktywność.",
        "Sople – naturalni testerzy wytrzymałości czaszki.",
        "Następnym razem uśmiechnij się do sufitu.",
        "Śnieg poszedł w ruch, ty nie.",
        "Może spróbuj uczyć się od pingwinów?",
        "Sopel polecił ci swoją listę przebojów.",
        "To nie była porażka, to spektakl w trzech aktach.",
        "Trochę lodu nigdy nie zaszkodzi... chyba że na głowie.",
        "Zimowe powitanie było zbyt entuzjastyczne.",
        "Sople miały plan i go wykonały.",
        "Twoja głowa zgłosiła się na ochotnika.",
        "Pomyśl o tym jako o szybkim schłodzeniu.",
        "Sople nie znają pojęcia 'przepraszam'.",
        "Chyba ktoś zapomniał zaprosić cię na imprezę sufitu.",
        "To był szybki kontakt z naturą.",
        "Głowa vs sopel — wynik przewidywalny.",
        "Następnym razem weź kask i sense.",
        "Tak kończą ciekawscy.",
        "Sople: bo świat potrzebuje dramatu.",
        "Twoje plany na dziś: uniknąć spadającego lodu.",
        "Sople mają swoje priorytety.",
        "To nie jest porażka, to epicka historia.",
        "Twarde lądowanie z nutką lodu.",
        "Mogłeś przynajmniej zadzwonić, zanim cię dotknął.",
        "Sopel wykonał idealny obrót.",
        "Twoje życie w kilku kiepskich klatkach.",
        "Głowa nie jest przystosowana do sopli.",
        "Kolejna lekcja: sufit nie jest przyjacielem.",
        "Przynajmniej był efekt świetlny.",
        "Sople zrobiły ci psikusa i wygrały.",
        "Wygląda na to, że przegrywasz z meteorologią.",
        "Nie oceniaj książki po okładce, ale sufit po wyglądzie.",
        "Sople: łączymy ludzi z podłogą od wieków.",
        "Może zacznij biegać szybciej, albo wolniej?",
        "Lód robi swoje — bez litości.",
        "Twoja głowa jest teraz ładnie udekorowana.",
        "Sople miały lepsze plany weekendowe.",
        "Zimowy upadek z darmowym efektem dźwiękowym.",
        "Wygląda na to, że sufit miał dla ciebie komunikat.",
        "Kolejny dzień, kolejna lodowa przygoda.",
        "Nigdy nie ufaj temu, co zwisa z góry.",
        "Sople są jak teściowa — niespodziewane i ostre.",
        "Przyszłość przewiduje lód i dużo bandaży.",
        "Może spróbuj porozumieć się z soplami?",
        "Głowa na linii frontu — dosłownie.",
        "Sople mają preferencje smakowe: twoja głowa.",
        "Powinieneś założyć GPS na sufit.",
        "Zimowy anioł zrobił ci krzywdę.",
        "Sopel: mały, zimny, PRZECIWKO tobie.",
        "Twoja pozycja w rankingu: ofiara dnia.",
        "Sople wystawiły ci rachunek.",
        "Nie martw się, opowiesz to wnukom... jeśli będą słuchać.",
        "Może to był test odwagi? Nie zdałeś.",
        "Cóż, przynajmniej było zabawnie... dla sopla.",
        "Uwaga: lokalne sople w natarciu.",
        "Twoja głowa przeszła w tryb 'lodowy'.",
        "Sople mają własne poczucie stylu: twój łeb.",
        "Zimna lekcja o grawitacji.",
        "Sople i ty — historia zatoczyła krąg.",
        "Kolejny poziom: 'Dotyk sopla' — pogratulować?",
        "Twoje plany vs natura: sumarycznie natura 1.",
        "Sople napisały ci wiadomość: 'pa!'",

        -- Dodatki z pustynią
        "Pustynia cię spaliła — piasek wszędzie.",
        "Słońce pali, może przyda się woda?",
        "Burza piaskowa przyniosła szybkie pożegnanie.",
        "Twoja głowa czuje się jak wydma.",
        "Oaza miała inne plany.",
        "Gorący piasek i zimny lód — fatalne połączenie.",
        "Skały pustyni nie wybaczają błędów.",
        "Zamiast sopla dostałeś kamień i kurz.",
        "Pustynny upadek — brak śniegu, więcej pyłu.",
        "Może następnym razem weź ze sobą butelkę wody.",
    }

    -- Ustawienia gry
    poziomy = { "Latwy", "Trudny", "Niemozliwy" }
    aktualny_poziom = 1
    szybkosci_dodawania = { 5, 3, 1 }
    szybkosci_tla = { 0.02, 0.05, 0.1 }
    czerwien = 0

    debug = true -- włącz debugowanie

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

    sklepik = { x = love.math.random(0, szerokosc - 50), y = -100, width = 100, height = 100 }

    local ilosc_sopli = 5
    Sople.spawn(ilosc_sopli)

    local ilosc_monet = 3
    Monety.spawn(ilosc_monet)

    krok = 0
    radosny = 0
    oberwal = 0
    wslizg = 0
    tarcie = 0.74
    zycia = 3
    maxZycia = zycia
    wslizgAktywny = false
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

    stan = { menu = {}, gra = {}, przegrana = {}, swiaty = {}, pustynia = {} }
    stanGry = stan.menu

    love.graphics.setFont(font)

    przyciskStart = { x = szerokosc / 2 - 100, y = wysokosc / 2, width = 200, height = 50 }
    przyciskTryb = { x = szerokosc / 2 - 100, y = wysokosc / 2 - 80, width = 200, height = 50 }
end

---------------------
-- Główna pętla gry
---------------------
function love.update(dt)
    if zycia < 1 and wstrzasy < 0 and (stanGry == stan.gra or stanGry == stan.pustynia) then
        wynik_koniec = punkty
        losowyTekst = teksty[love.math.random(#teksty)]
        Efekty.rozpocznijLadowanie(function() stanGry = stan.przegrana end)
    end
    if love.keyboard.isDown("escape") then love.event.quit() end

    Dialog.update(dt)
    UI.update()
    flux.update(dt)
    niesmiertelny = niesmiertelny - dt
    radosny = radosny - dt
    oberwal = oberwal - dt
    wslizg = wslizg - dt
    wstrzasy = wstrzasy - dt

    -- Jeśli sklepik otwarty, nie aktualizujemy gry
    if Sklepik.aktywny then
        return
    end

    if stanGry == stan.gra then
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
    if stanGry == stan.pustynia then
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
    elseif stanGry == stan.gra then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.drawStretched(jaskiniaImg, 0, 0, szerokosc, wysokosc)
        love.graphics.setColor(czerwien, 0.8, 1, 0.3)
        love.graphics.rectangle("fill", 0, 0, szerokosc, wysokosc)
        love.graphics.setColor(1, 1, 1, 1)

        Efekty.wstrzasyZMoca(10)
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

        Sklepik.draw()
    elseif stanGry == stan.przegrana then
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(losowyTekst, font, 0, wysokosc / 2 - 20, szerokosc, "center")
        love.graphics.printf("Wynik: " .. wynik_koniec, font, 0, wysokosc / 2 + 40, szerokosc, "center")
        love.graphics.printf("Najlepszy wynik: " .. najlepszy_wynik, font, 0, wysokosc / 2 + 80, szerokosc, "center")
        love.graphics.printf("Monety: " .. zebraneMonety, font, 0, wysokosc / 2 + 120, szerokosc, "center")
    elseif stanGry == stan.swiaty then
        love.graphics.setColor(1, 1, 1)
        love.graphics.clear(0.5, 0.8, 1, 1)
        Swiaty.draw()
    elseif stanGry == stan.pustynia then
        Pustynia.draw()
        love.graphics.setColor(1, 1, 1)
    end


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
