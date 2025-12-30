local Wyzwania = {}

function szansa(procent)
    return love.math.random(100) <= procent
end

local listawyzwan = {
    {
        nazwa = "kaktus",
        przeszkody = function()
            nowykaktus(love.math.random(200, 1000))
        end,
        szerokosc = 500
    },
    {
        nazwa = "kilka kaktusów",
        przeszkody = function()
            local baza = gracz.predkoscx * 49
            if szansa(50) then nowykaktus(love.math.random(0, baza)) end
            nowykaktus(baza * 2)
            if szansa(60) then nowykaktus(love.math.random(2.8 * baza, 3.5 * baza)) end
            if szansa(10) then nowykaktus(love.math.random(4.6 * baza)) end
        end,
        szerokosc = 1000
    },
    {
        nazwa = "kilka sępów",
        przeszkody = function()
            if szansa(60) then nowyptak(love.math.random(300, 700), love.math.random(400, 550)) end
            nowyptak(love.math.random(600, 700), love.math.random(160, 300))
            if szansa(50) then nowyptak(love.math.random(1600, 1900), love.math.random(180, 400)) end
        end,
        szerokosc = 300
    },
    {
        nazwa = "las kaktusów",
        przeszkody = function()
            local baza = gracz.predkoscx * 47
            if szansa(80) then nowykaktus(0) end
            if szansa(80) then nowykaktus(baza) end
            if szansa(80) then nowykaktus(baza * 2.1) end
            if szansa(80) then nowyszkielet(baza * 3.2) end
            if szansa(80) then nowykaktus(baza * 4.5) end
        end,
        szerokosc = 2500
    },
    {
        nazwa = "sęp",
        przeszkody = function()
            nowyptak(love.math.random(800, 1200), love.math.random(200, 500))
        end,
        szerokosc = 100
    },
    {
        nazwa = "wielbłąd",
        przeszkody = function()
            nowywielblad(200)
            if szansa(30) then nowykaktus(800) end
        end,
        szerokosc = 200
    },
    {
        nazwa = "dwa wielbłądy",
        przeszkody = function()
            local baza = gracz.predkoscx * 45
            if szansa(50) then nowykaktus(0) end
            nowywielblad(baza)
            if szansa(50) then
                nowyszkielet(baza * 2.5)
                if szansa(60) then nowywielblad(baza * 3.5) end
            else
                nowywielblad(love.math.random(baza * 2.5, baza * 3))
            end
        end,
        szerokosc = 1800
    },
    {
        nazwa = "sęp i kaktus",
        przeszkody = function()
            if szansa(100) then nowykaktus(0) end
            nowyptak(1800, love.math.random(300, 500))
            if szansa(100) then nowykaktus(1500) end
        end,
        szerokosc = 1500
    },
    {
        nazwa = "sklepik",
        przeszkody = function()
            nowysklepik(1000)
            if szansa(30) then nowyszkielet(1700) end
        end,
        szerokosc = 1000
    }
}

function Wyzwania.losuj()
    return listawyzwan[love.math.random(1, 9)]
    --return listawyzwan[love.math.random(#listawyzwan)]
end

return Wyzwania
