local Boss = {}
local Sound = require("src.sound")

local Faza = { nieaktywny = {}, wejscie = {}, prawoLewo = {} }
Boss.faza = Faza.nieaktywny

function Boss.przywolaj()
    if Boss.faza == Faza.nieaktywny then
        Bossimg = love.graphics.newImage("gfx/boss.png")
        Boss.faza = Faza.wejscie
        Boss.x = szerokosc / 2
        Boss.y = -wysokosc
        Boss.predkoscX = 10
        Boss.WPrawo = True
        Boss.ryk = 1
        Sound.boss_przygotuj_sie()
    end
end

function Boss.update(dt)
    if Boss.faza == Faza.wejscie then
        if Boss.ryk >= 0 and Boss.ryk - dt < 0 then
            Sound.boss_wejscie()
        end
        Boss.ryk = Boss.ryk - dt
        -- kiedy wchodzi
        if Boss.y < 100 then
            Boss.y = Boss.y + 10
        end
        if Boss.y >= 100 then
            Boss.faza = Faza.prawoLewo
            Sound.boss_smiech()
        end
    end
    if Boss.faza == Faza.prawoLewo then
        if Boss.WPrawo then
            Boss.x = Boss.x + Boss.predkoscX
        else
            Boss.x = Boss.x - Boss.predkoscX
        end
        -- Odbijanie od krawędzi ekranu
        if Boss.x <= 0 or Boss.x + Bossimg:getWidth() >= szerokosc then
            Boss.WPrawo = not Boss.WPrawo
        end
    end
end

function Boss.draw()
    if Boss.faza ~= Faza.nieaktywny then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(Bossimg, Boss.x, Boss.y)
    end
end

return Boss
