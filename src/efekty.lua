local flux = require("plugins.flux")

local Efekty = {}

local ladowanieImg = love.graphics.newImage("gfx/ladowanie.png")
local ladowanie = { x = 10000, w_trakcie = false }

local latarkaImg = love.graphics.newImage("gfx/latarka.png")
local latarkaTex = love.graphics.newCanvas(love.graphics.getWidth() * 1.2, love.graphics.getHeight() * 1.2)

function Efekty.wstrzasyZMoca(moc)
    if wstrzasy > 0 then
        love.graphics.translate(love.math.random(-moc, moc), love.math.random(-moc, moc))
    end
end

function Efekty.koniecWstrzasow()
    love.graphics.origin()
end

function Efekty.latarka(x, y)
    -- wygeneruj teksturę dla latarki - ciemne tło z obrazkiem światła w miejscu gracza
    love.graphics.setCanvas(latarkaTex)
    do
        -- rysujemy teraz na latarkaTex
        love.graphics.clear(0.2, 0.2, 0.2, 1) -- jak ciemno ma być poza latarką?
        love.graphics.setBlendMode("add", "premultiplied")
        love.graphics.draw(latarkaImg, x - latarkaImg:getWidth() / 2 + 100, y - latarkaImg:getHeight() / 2 + 100)
    end -- wracamy do rysowania na głównym ekranie
    love.graphics.setCanvas()

    -- wyświetl teksturę w trybie 'multiply'
    love.graphics.setBlendMode("multiply", "premultiplied")
    love.graphics.draw(latarkaTex, -100, -100)
    love.graphics.setBlendMode("alpha")
end

function Efekty.rozpocznijLadowanie(akcja)
    if ladowanie.w_trakcie then
        return -- jeśli ładowanie już trwa, nie rozpoczynaj ponownie
    end
    ladowanie.w_trakcie = true
    ladowanie.x = szerokosc
    flux.to(ladowanie, 0.6, { x = -440 })                        -- zaciemnienie ekranu
        :after(ladowanie, 0.4, {})                               -- czarny ekran przez chwilę
        :oncomplete(akcja)                                       -- wywołanie akcji po zakończeniu ładowania
        :after(ladowanie, 0.7, { x = -ladowanieImg:getWidth() }) -- rozjasnienie ekranu
        :oncomplete(function() ladowanie.w_trakcie = false end)  -- zakończenie ładowania
end

function Efekty.rysujLadowanie()
    if ladowanie.w_trakcie then
        local skala = wysokosc / ladowanieImg:getHeight()
        love.graphics.draw(ladowanieImg, ladowanie.x * skala, 0, 0, skala, skala)
    end
end

return Efekty
