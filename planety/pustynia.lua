local Pustynia = {}
local Player = require("src.player")

Pustynia.load = function()
    gracz.y = 800
    gracz.x = 300
end
Pustynia.update = function(dt)
    if love.keyboard.isDown("w") then
        gracz.y = gracz.y + 100
    end
end
Pustynia.draw = function()
    Player.draw()
    love.graphics.setBackgroundColor(0.9, 0.8, 0.5)
end
return Pustynia