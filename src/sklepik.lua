local UI = require("src.ui")
local Dialog = require("src.dialog")

local wyjscieImg = love.graphics.newImage("gfx/sklepik/wyjscie.png")

local Sklepik = {
    aktywny = false,
    aktualnaOferta = {}
}


Sklepik.oferty = {
    {
        nazwa = "Życie",
        grafika = love.graphics.newImage("gfx/sklepik/serce.png"),
        cena = 5,
        dostepna = function(self)
            return zebraneMonety >= self.cena and zycia < maxZycia
        end,
        akcja = function(self)
            zebraneMonety = zebraneMonety - self.cena
            zycia = zycia + 1
            self.cena = self.cena + 5
        end
    },
    {
        nazwa = "Puste Serce",
        grafika = love.graphics.newImage("gfx/sklepik/puste-serce.png"),
        cena = 10,
        dostepna = function(self)
            return zebraneMonety >= self.cena and maxZycia < 8
        end,
        akcja = function(self)
            zebraneMonety = zebraneMonety - self.cena
            maxZycia = maxZycia + 1
            self.cena = self.cena + 15
        end
    },
    {
        nazwa = "Szybkość",
        grafika = love.graphics.newImage("gfx/sklepik/szybkosc.png"),
        cena = 15,
        dostepna = function(self)
            return zebraneMonety >= self.cena
        end,
        akcja = function(self)
            zebraneMonety = zebraneMonety - self.cena
            gracz.przyspieszenie = gracz.przyspieszenie + 1
            self.cena = self.cena + 10
            if stanGry == stan.pustynia then
                gracz.predkoscx = gracz.predkoscx + 1
            end
        end
    },
    {
        nazwa = "Skin",
        grafika = love.graphics.newImage("gfx/sklepik/losowy-skin.png"),
        cena = 50,
        dostepna = function(self)
            return zebraneMonety >= self.cena
        end,
        akcja = function(self)
            zebraneMonety = zebraneMonety - self.cena
            gracz.skin = spioszekImg
            self.cena = self.cena + 20
        end
    },
    {
        nazwa = "Wślizg",
        grafika = love.graphics.newImage("gfx/sklepik/wslizg.png"),
        cena = 40,
        dostepna = function(self)
            return zebraneMonety >= self.cena and not wslizgAktywny
        end,
        akcja = function(self)
            zebraneMonety = zebraneMonety - self.cena
            wslizgAktywny = true
        end
    }
}

-- Losowanie 3 unikalnych ofert
function Sklepik.losujOferte()
    Sklepik.aktualnaOferta = {}
    local pool = {}
    for i = 1, #Sklepik.oferty do
        table.insert(pool, i)
    end
    for i = 1, 3 do
        if #pool == 0 then break end
        local index = table.remove(pool, love.math.random(1, #pool))
        table.insert(Sklepik.aktualnaOferta, Sklepik.oferty[index])
    end
end

function Sklepik.otworz()
    Sklepik.aktywny = true
    Sklepik.losujOferte()
    local powitanie = {
        "Witaj w sklepiku!",
        "Czego Ci potrzeba?",
        "Tanio i dobrze, rozejrzyj się!",
        "Witaj, mam dla Ciebie kilka nowości!"
    }
    Dialog.wyczysc()
    Dialog.wiadomosc("Sprzedawca", powitanie[love.math.random(1, #powitanie)])
end

function Sklepik.zamknij()
    Sklepik.aktywny = false
    Dialog.wyczysc()
end

function Sklepik.draw()
    if not Sklepik.aktywny then return end

    -- Tło
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.rectangle("fill", 0, 0, szerokosc, wysokosc)

    -- Okno
    local boxW, boxH = 600, 450
    local boxX, boxY = (szerokosc - boxW) / 2, (wysokosc - boxH) / 2
    love.graphics.setColor(0.2, 0.2, 0.2, 0.9)
    love.graphics.rectangle("fill", boxX, boxY, boxW, boxH)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", boxX, boxY, boxW, boxH)

    love.graphics.printf("Sklepik", boxX, boxY + 10, boxW, "center")

    -- Zamknięcie
    if UI.przycisk_sklepik({ x = boxX + boxW - 85, y = boxY + 15, width = 70, height = 70 }, wyjscieImg, "", false) then
        Sklepik.zamknij()
    end

    -- Liczba monet
    love.graphics.draw(stosMonet, boxX + 10, boxY + boxH - 64)
    love.graphics.print(zebraneMonety, boxX + 70, boxY + boxH - 69)

    -- Sloty
    local startX, startY = boxX + 55, boxY + 110
    local slotSize = 150
    local spacing = 20
    local kafelek = { x = startX, y = startY, width = slotSize, height = slotSize }

    for _, oferta in ipairs(Sklepik.aktualnaOferta) do
        local tekst = oferta.nazwa .. " (" .. oferta.cena .. ")"
        if UI.przycisk_sklepik(kafelek, oferta.grafika, tekst, not oferta:dostepna()) then
            oferta:akcja()
        end
        kafelek.x = kafelek.x + slotSize + spacing
    end
end

return Sklepik
