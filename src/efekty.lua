local flux = require("plugins.flux")

local Efekty = {}

local ladowanieImg = love.graphics.newImage("gfx/ladowanie-2.png")
local ladowanie = { x = 10000, w_trakcie = false }

function Efekty.wstrzasyZMoca(moc)
    if wstrzasy > 0 then
        love.graphics.translate(love.math.random(-moc, moc), love.math.random(-moc, moc))
    end
end

function Efekty.latarka(x, y)
    -- strzwórz szablon dla latarki, piksele białe nie zostaną zamalowane
    local szablon = function()
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.circle("fill", x, y, 150)
    end
    love.graphics.stencil(szablon, "replace", 1)

    -- wejdź w tryb szablonu
    love.graphics.setStencilTest("less", 1)
    -- zamaluj wszystko na czarno, szablon zablokuje okrąg wokół gracza
    love.graphics.setColor(0, 0, 0, 0.8)
    love.graphics.rectangle("fill", -szerokosc / 2, -wysokosc / 2, szerokosc * 2, wysokosc * 2)
    -- opuść tryb szablonu
    love.graphics.setStencilTest()
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
