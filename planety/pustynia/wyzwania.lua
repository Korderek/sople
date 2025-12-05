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
        szerokosc = -100
    },
    {
        nazwa = "kilka kaktusów",
        przeszkody = function()
            if szansa(30) then nowykaktus(369) end
            nowykaktus(793)
            if szansa(50) then nowykaktus(1294) end
        end,
        szerokosc = -200
    },
    {
        nazwa = "kilka sępów",
        przeszkody = function()
            if szansa(50) then nowyptak(369, 500) end
            nowyptak(793, 150)
            if szansa(50) then nowyptak(1294, 480) end
        end,
        szerokosc = -200
    },
    {
        nazwa = "las kaktusów",
        przeszkody = function()
            if szansa(50) then nowykaktus(259) end
            if szansa(50) then nowykaktus(1037) end
            if szansa(50) then nowykaktus(1859) end
            if szansa(50) then nowyszkielet(2638) end
            if szansa(50) then nowykaktus(3925) end
        end,
        szerokosc = -200
    },
    {
        nazwa = "sęp",
        przeszkody = function()
            nowyptak(1037, 450)
        end,
        szerokosc = -200
    },
    {
        nazwa = "wielbłąd",
        przeszkody = function()
            nowywielblad(1500)
            if szansa(30) then nowykaktus(2638) end
        end,
        szerokosc = -200
    },
    {
        nazwa = "dwa wielbłądy",
        przeszkody = function()
            nowywielblad(1500)
            if szansa(10) then nowykaktus(2638) end
            nowywielblad(3500)
        end,
        szerokosc = -200
    },
    {
        nazwa = "sęp i kaktus",
        przeszkody = function()
            if szansa(30) then nowykaktus(1638) end
            nowyptak(2900, 150)
            if szansa(70) then nowykaktus(3638) end
        end,
        szerokosc = -200
    },
    {
        nazwa = "sklepik",
        przeszkody = function()
            nowysklepik(500)
        end,
        szerokosc = -1000
    }
}

function Wyzwania.losuj()
    return listawyzwan[6]
    --return listawyzwan[love.math.random(#listawyzwan)]
end

return Wyzwania
