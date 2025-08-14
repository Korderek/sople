local UI = {}

local lewy_przycisk = {
    puszczony = true,
    wcisniety = false,
    klikniety = false,
}
local x, y = love.mouse.getPosition()

-- Aktualizuje stan przycisków myszy
function UI.update()
    x, y = love.mouse.getPosition()

    lewy_przycisk.puszczony = not love.mouse.isDown(1)
    -- jesli teraz jest puszczony a wcześniej był wciśnięty, to kliknięty
    lewy_przycisk.klikniety = lewy_przycisk.puszczony and lewy_przycisk.wcisniety
    lewy_przycisk.wcisniety = love.mouse.isDown(1)
end

-- Rysuje przycisk z tekstem, zwraca true jeśli został kliknięty
function UI.przycisk(wymiary, tekst)
    local r, g, b, a = love.graphics.getColor() -- zapamiętujemy aktualny kolor
    local mysz_na_przycisku = kolizja({ x = x, y = y, width = 1, height = 1 }, wymiary)
    local tekst = tekst or ""

    -- rysujemy przycisk
    love.graphics.setColor(1, 1, 1, 1) -- przycisk normalny
    if mysz_na_przycisku then
        if lewy_przycisk.puszczony then
            love.graphics.setColor(0.8, 0.8, 0.8) -- przycisk najechany
        else
            love.graphics.setColor(0.7, 0.7, 0.7) -- przycisk wciśnięty
        end
    end
    love.graphics.rectangle("fill", wymiary.x, wymiary.y, wymiary.width, wymiary.height, 10)
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(tekst, font, wymiary.x, wymiary.y + wymiary.height / 2 - font:getHeight() / 2, wymiary.width,
        "center")
    love.graphics.setColor(r, g, b, a) -- przywracamy poprzedni kolor

    return mysz_na_przycisku and lewy_przycisk.klikniety
end

-- Rysuje serca w prawym górnym rogu ekranu
function UI.rysujSerca()
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

return UI
