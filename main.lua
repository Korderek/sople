-- main.lua
require("player")
local sople2 = require("src.sople")

function love.load()
    szerokosc, wysokosc = love.graphics.getDimensions()

    ilosc_sopli = 5
    czas_dodawania_sopli = 5
    czas_ostatniego_dodania = 0

    poziomy = { "Latwy", "Trudny", "Niemozliwy" }
    aktualny_poziom = 1
    szybkosci_dodawania = { 5, 3, 1 }
    szybkosci_tla = { 0.02, 0.05, 0.1 }
    czerwien = 0

    sopelImg = love.graphics.newImage("gfx/sopel.png")
    serce = love.graphics.newImage("gfx/serce.png")
    pusteserce = love.graphics.newImage("gfx/pusteserce.png")
    monetaImg = love.graphics.newImage("gfx/moneta.png")
    playerImg = love.graphics.newImage("gfx/gracz.png")

    gracz = {
        x = math.max(0, math.min(100, szerokosc - 50)),
        y = 970,
        width = 50,
        height = 100,
        scale = 2.0,
        ox = 25,
        oy = 100
    }

    sople = {}
    for i = 1, ilosc_sopli do
        table.insert(sople, sople2.losowy())
    end

    monety = {}
    for i = 1, 3 do
        table.insert(monety, losowaMoneta())
    end

    zycia = 3
    niesmiertelny = 0
    wstrzasy = 0
    czas = 0
    punkty = 0
    zebraneMonety = 0
    wynik_koniec = 0

    stan = { menu = {}, gra = {}, przegrana = {} }
    stanGry = stan.menu

    font = love.graphics.newFont(40)
    przyciskStart = { x = szerokosc / 2 - 100, y = wysokosc / 2, width = 200, height = 50 }
    przyciskTryb = { x = szerokosc / 2 - 100, y = wysokosc / 2 - 80, width = 200, height = 50 }
end

function losowaMoneta()
    return {
        x = love.math.random(0, szerokosc - 32),
        y = love.math.random(-400, -50),
        width = 32,
        height = 32
    }
end

function kolizja(a, b)
    return a.x < b.x + b.width and a.x + a.width > b.x and a.y < b.y + b.height and a.y + a.height > b.y
end

function love.update(dt)
    if stanGry ~= stan.gra then return end

    czas = czas + dt
    niesmiertelny = niesmiertelny - dt
    wstrzasy = wstrzasy - dt

    czerwien = math.min(1, czerwien + dt * szybkosci_tla[aktualny_poziom])
    punkty = math.floor(czas)

    if czas - czas_ostatniego_dodania >= szybkosci_dodawania[aktualny_poziom] then
        table.insert(sople, sople2.losowy())
        czas_ostatniego_dodania = czas
    end

    if love.keyboard.isDown("a") then gracz.x = gracz.x - 3 end
    if love.keyboard.isDown("d") then gracz.x = gracz.x + 3 end

    if love.keyboard.isDown("escape") then love.event.quit() end

    gracz.x = math.max(0, math.min(szerokosc - gracz.width, gracz.x))

    sople2.update()

    for _, m in ipairs(monety) do
        m.y = m.y + 2
        if m.y > wysokosc then
            m.y = -50
            m.x = love.math.random(0, szerokosc - m.width)
        end
        if kolizja(gracz, m) then
            zebraneMonety = zebraneMonety + 1
            m.y = -50
            m.x = love.math.random(0, szerokosc - m.width)
        end
    end

    if zycia < 1 and wstrzasy < 0 then
        wynik_koniec = punkty
        stanGry = stan.przegrana
    end
end

function love.mousepressed(x, y, button)
    if button == 1 and stanGry == stan.menu then
        if kolizja({ x = x, y = y, width = 1, height = 1 }, przyciskStart) then
            stanGry = stan.gra
        elseif kolizja({ x = x, y = y, width = 1, height = 1 }, przyciskTryb) then
            aktualny_poziom = aktualny_poziom % #poziomy + 1
        end
    end
end

function love.draw()
    if stanGry == stan.menu then
        love.graphics.setBackgroundColor(0.5, 0.8, 1, 1)
        love.graphics.setFont(font)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", przyciskTryb.x, przyciskTryb.y, przyciskTryb.width, przyciskTryb.height, 10)
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(poziomy[aktualny_poziom], font, przyciskTryb.x, przyciskTryb.y + 5, przyciskTryb.width,
            "center")
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", przyciskStart.x, przyciskStart.y, przyciskStart.width, przyciskStart.height, 10)
        love.graphics.printf("LECIMY", font, przyciskStart.x, przyciskStart.y + 5, przyciskStart.width, "center")
    elseif stanGry == stan.gra then
        love.graphics.setColor(1, 1, 1)
        love.graphics.clear(czerwien, 0.8, 1, 1)
        if wstrzasy > 0 then
            love.graphics.translate(love.math.random(-10, 10), love.math.random(-10, 10))
        end
        rysujSerca()
        sople2.draw()
        player.draw()
        for _, m in ipairs(monety) do
            love.graphics.draw(monetaImg, m.x, m.y)
        end
        love.graphics.setColor(0, 0, 0)
        love.graphics.print("Punkty: " .. punkty, 10, 10)
        love.graphics.print("Monety: " .. zebraneMonety, 10, 50)
    elseif stanGry == stan.przegrana then
        love.graphics.setFont(font)
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf("Sople Cie pociely. Boli?", font, 0, wysokosc / 2 - 20, szerokosc, "center")
        love.graphics.printf("Wynik: " .. wynik_koniec, font, 0, wysokosc / 2 + 40, szerokosc, "center")
        love.graphics.printf("Monety: " .. zebraneMonety, font, 0, wysokosc / 2 + 80, szerokosc, "center")
    end
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
