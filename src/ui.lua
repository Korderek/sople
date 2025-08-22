local UI = {}
local Shader = require("src.shader")

local lewy_przycisk = {
    puszczony = true,
    wcisniety = false,
    klikniety = false,
}
local mysz_x, mysz_y = love.mouse.getPosition()

-- Aktualizuje stan przycisków myszy
function UI.update()
    mysz_x, mysz_y = love.mouse.getPosition()

    lewy_przycisk.puszczony = not love.mouse.isDown(1)
    -- jesli teraz jest puszczony a wcześniej był wciśnięty, to kliknięty
    lewy_przycisk.klikniety = lewy_przycisk.puszczony and lewy_przycisk.wcisniety
    lewy_przycisk.wcisniety = love.mouse.isDown(1)
end

-- Rysuje przycisk z tekstem, zwraca true jeśli został kliknięty
function UI.przycisk(wymiary, tekst)
    local r, g, b, a = love.graphics.getColor() -- zapamiętujemy aktualny kolor
    local mysz_na_przycisku = czy_mysz_na_przycisku(wymiary)
    local tekst = tekst or ""

    local kolor_tla = { 1, 1, 1, 1 }
    local kolor_tekstu = { 0, 0, 0, 1 }
    if mysz_na_przycisku and lewy_przycisk.puszczony then
        kolor_tla = { 0.8, 0.8, 0.8 }
    elseif mysz_na_przycisku and lewy_przycisk.wcisniety then
        kolor_tla = { 0.7, 0.7, 0.7 }
    end

    -- rysujemy przycisk
    love.graphics.setColor(kolor_tla)
    love.graphics.rectangle("fill", wymiary.x, wymiary.y, wymiary.width, wymiary.height, 10)
    love.graphics.setColor(kolor_tekstu)
    love.graphics.printCentered(tekst, font, wymiary.x, wymiary.y, wymiary.width, wymiary.height)

    love.graphics.setColor(r, g, b, a) -- przywracamy poprzedni kolor
    return mysz_na_przycisku and lewy_przycisk.klikniety
end

-- Rysuje przycisk z tekstem, zwraca true jeśli został kliknięty
function UI.przycisk_sklepik(wymiary, tekst, zablokowany)
    local r, g, b, a = love.graphics.getColor() -- zapamiętujemy aktualny kolor

    local mysz_na_przycisku = czy_mysz_na_przycisku(wymiary)
    local tekst = tekst or ""

    -- ustawiamy kolor tła i tekstu
    local kolor_tla = { 1, 1, 1, 1 }
    local kolor_tekstu = { 0, 0, 0, 1 }
    if zablokowany then
        kolor_tla = { .5, .5, .5, 1 }
        kolor_tekstu = { .3, .3, .3, 1 }
    elseif mysz_na_przycisku and lewy_przycisk.puszczony then
        kolor_tla = { .8, .8, .8, 1 }
    elseif mysz_na_przycisku and lewy_przycisk.wcisniety then
        kolor_tla = { .7, .7, .7, 1 }
    end

    -- rysujemy przycisk
    love.graphics.setColor(kolor_tla)
    love.graphics.rectangle("fill", wymiary.x, wymiary.y, wymiary.width, wymiary.height, 10)
    love.graphics.setColor(kolor_tekstu)
    love.graphics.printCentered(tekst, font_small, wymiary.x, wymiary.y, wymiary.width, wymiary.height)

    love.graphics.setColor(r, g, b, a) -- przywracamy poprzedni kolor
    return not zablokowany and mysz_na_przycisku and lewy_przycisk.klikniety
end

function UI.przycisk_swiat(x, y, grafika, nazwa)
    local r, g, b, a = love.graphics.getColor() -- zapamiętujemy aktualny kolor

    local wymiary = {
        x = x,
        y = y,
        width = grafika:getWidth(),
        height = grafika:getHeight()
    }
    local mysz_na_przycisku = czy_mysz_na_przycisku(wymiary)
    local nazwa = nazwa or ""

    local kolor_tekstu = { 0, 0, 0, 1 }
    local kolor_obramowania = { 1, 1, 1, 1 }
    local grubosc_obramowania = 0
    if mysz_na_przycisku and lewy_przycisk.puszczony then
        grubosc_obramowania = 30
    elseif mysz_na_przycisku and lewy_przycisk.wcisniety then
        grubosc_obramowania = 50
    end

    -- rysujemy grafikę
    Shader.obramowanie(grubosc_obramowania, kolor_obramowania) -- rysuj grafikę z obwódką
    love.graphics.drawCentered(grafika, wymiary.x, wymiary.y, wymiary.width, wymiary.height)
    Shader.koniec()                                            -- wyłącz rysowanie obwódki
    -- wyświetlamy nazwę pod grafiką
    love.graphics.setColor(kolor_tekstu)
    love.graphics.printf(nazwa, font, wymiary.x, wymiary.y + wymiary.height + font:getHeight() / 2, wymiary.width,
        "center")

    love.graphics.setColor(r, g, b, a) -- przywracamy poprzedni kolor

    return mysz_na_przycisku and lewy_przycisk.klikniety
end

-- Rysuje serca w prawym górnym rogu ekranu
function UI.rysujSerca()
    local skala = 1.0
    local rozmiar = skala * serce:getWidth()
    local x = szerokosc - 5
    for i = 1, 3 do
        x = x - rozmiar - 5
        local y = 10
        if i <= zycia then
            love.graphics.draw(serce, x, y, 0, skala, skala)
        else
            love.graphics.draw(pusteserce, x, y, 0, skala, skala)
        end
    end
end

-----------------------
-- Funkcje pomocnicze
-----------------------
function czy_mysz_na_przycisku(wymiary)
    return kolizja({ x = mysz_x, y = mysz_y, width = 1, height = 1 }, wymiary)
end

return UI
