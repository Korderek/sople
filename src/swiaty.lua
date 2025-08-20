local Swiaty = {}
local UI = require("src.ui")
local planetafacet = love.graphics.newImage("gfx/gracz.png")
function Swiaty.draw()
    -- Rysowanie świata
    love.graphics.setColor(1, 1, 1)

    -- Rysowanie planet
    if UI.przycisk_swiat(310, 310, planetafacet, "Przycisk Świata") then
        stanGry = stan.menu
    end
    if UI.przycisk_swiat(620, 310, planetafacet, "Przycisk Świata  v2") then
        stanGry = stan.menu
    end
    -- Tutaj można dodać logikę, co się stanie po kliknięciu
end

return Swiaty
