local UI = {}

local lewy_przycisk = {
    puszczony = true,
    wcisniety = false,
    klikniety = false,
}
local x, y = love.mouse.getPosition()

function UI.update()
    x, y = love.mouse.getPosition()

    lewy_przycisk.puszczony = not love.mouse.isDown(1)
    -- jesli teraz jest puszczony a wcześniej był wciśnięty, to kliknięty
    lewy_przycisk.klikniety = lewy_przycisk.puszczony and lewy_przycisk.wcisniety
    lewy_przycisk.wcisniety = love.mouse.isDown(1)
end

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
    love.graphics.printf(tekst, font, wymiary.x, wymiary.y + 5, wymiary.width, "center")
    love.graphics.setColor(r, g, b, a) -- przywracamy poprzedni kolor

    return mysz_na_przycisku and lewy_przycisk.klikniety
end

return UI
