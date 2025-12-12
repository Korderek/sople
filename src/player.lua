local Player = {}

local tekstura_standard = love.graphics.newImage("gfx/gracz-animacje.png")
local tekstura_spioszek = love.graphics.newImage("gfx/spioszek-animacje.png")
local animacje = { -- wymiary i położenie klatek animacji na teksturze
    standard = {
        stoi = love.graphics.newQuad(18, 18, 109, 235, tekstura_standard),
        zraniony = love.graphics.newQuad(131, 18, 113, 235, tekstura_standard),
        idzie = love.graphics.newQuad(244, 18, 122, 235, tekstura_standard),
        wslizg = love.graphics.newQuad(361, 18, 164, 235, tekstura_standard),
        radosny = love.graphics.newQuad(521, 18, 150, 235, tekstura_standard),
    },
    spioszek = {
        stoi = love.graphics.newQuad(15, 10, 134, 235, tekstura_spioszek),
        zraniony = love.graphics.newQuad(147, 10, 122, 235, tekstura_spioszek),
        idzie = love.graphics.newQuad(278, 10, 129, 235, tekstura_spioszek),
        wslizg = love.graphics.newQuad(407, 10, 133, 235, tekstura_spioszek),
        radosny = love.graphics.newQuad(547, 10, 145, 235, tekstura_spioszek),
    }
}


function Player.draw()
    local scale_x = gracz.kierunek == "prawo" and gracz.scale or -gracz.scale
    local scale_y = gracz.scale

    local tekstura = tekstura_standard
    local animacja = animacje.standard
    if gracz.skin == spioszekImg then
        tekstura = tekstura_spioszek
        animacja = animacje.spioszek
    end

    love.graphics.setColor(1, 1, 1)
    local poza = animacja.stoi
    if wslizg > 0 then
        poza = animacja.wslizg 
    elseif oberwal > 0 then
        poza = animacja.zraniony
    elseif radosny > 0 then
        poza = animacja.radosny
    elseif gracz.idzie == true and math.abs(gracz.predkosc) > 0.1 then
        poza = animacja.idzie
    end
    love.graphics.drawQuadCentered(tekstura, poza, gracz.x, gracz.y, gracz.width, gracz.height, scale_x, scale_y)
    love.graphics.rectangleDebug(gracz.x, gracz.y, gracz.width, gracz.height)
end

return Player
