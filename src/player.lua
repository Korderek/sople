local Player = {}

local tekstura = love.graphics.newImage("gfx/gracz-animacje.png")
local tekstura_spioszek = love.graphics.newImage("gfx/spioszek-animacje.png")
local animacja = { -- wymiary i położenie klatek animacji na teksturze
    standard = {
        stoi = love.graphics.newQuad(18, 18, 109, 235, tekstura),
        zraniony = love.graphics.newQuad(131, 18, 113, 235, tekstura),
        idzie = love.graphics.newQuad(244, 18, 122, 235, tekstura),
        wslizg = love.graphics.newQuad(361, 18, 164, 235, tekstura),
        radosny = love.graphics.newQuad(521, 18, 150, 235, tekstura),
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

    love.graphics.setColor(1, 1, 1)
    love.graphics.drawCentered(gracz.skin, gracz.x, gracz.y, gracz.width, gracz.height, scale_x, scale_y)
    love.graphics.rectangleDebug(gracz.x, gracz.y, gracz.width, gracz.height)
end

return Player
