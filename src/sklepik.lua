local UI = require("src.ui")
local Dialog = require("src.dialog")

local Sklepik = {
    aktywny = false,
    aktualnaOferta = {}
}

Sklepik.oferty = {
    {
        nazwa = "Życie+",
        cena = 10,
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
        cena = 30,
        dostepna = function(self)
            return zebraneMonety >= self.cena
        end,
        akcja = function(self)
            zebraneMonety = zebraneMonety - self.cena
            maxZycia = maxZycia + 1
            zycia = zycia + 1
            self.cena = self.cena + 20
        end
    },
    {
        nazwa = "Szybkość+",
        cena = 15,
        dostepna = function(self)
            return zebraneMonety >= self.cena
        end,
        akcja = function(self)
            zebraneMonety = zebraneMonety - self.cena
            gracz.przyspieszenie = gracz.przyspieszenie + 1
            self.cena = self.cena + 5
        end
    },
    {
        nazwa = "Skin",
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
        cena = 40,
        dostepna = function(self)
            return zebraneMonety >= self.cena and not wslizgAktywny
        end,
        akcja = function(self)
            zebraneMonety = zebraneMonety - self.cena
            wslizgAktywny = true
            self.cena = self.cena + 30
        end
    }
}

-- Losowanie 3 unikalnych ofert
function Sklepik.losujOferte()
    Sklepik.aktualnaOferta = {}
    local pool = { table.unpack(Sklepik.oferty) }
    for i = 1, 3 do
        if #pool == 0 then break end
        local index = love.math.random(1, #pool)
        table.insert(Sklepik.aktualnaOferta, pool[index])
        table.remove(pool, index)
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
    local boxW, boxH = 600, 400
    local boxX, boxY = (szerokosc - boxW) / 2, (wysokosc - boxH) / 2
    love.graphics.setColor(0.2, 0.2, 0.2, 0.9)
    love.graphics.rectangle("fill", boxX, boxY, boxW, boxH)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", boxX, boxY, boxW, boxH)

    love.graphics.printf("Sklepik", boxX, boxY + 10, boxW, "center")

    -- Zamknięcie
    if UI.przycisk({
        x = boxX + boxW - 40, y = boxY + 10, width = 30, height = 30
    }, "X") then
        Sklepik.zamknij()
    end

    -- Sloty
    local startX, startY = boxX + 40, boxY + 80
    local slotSize = 150
    local spacing = 20
    local kafelek = { x = startX, y = startY, width = slotSize, height = slotSize }

    for _, oferta in ipairs(Sklepik.aktualnaOferta) do
        local tekst = oferta.nazwa .. " (" .. oferta.cena .. ")"
        if UI.przycisk(kafelek, tekst) and oferta:dostepna() then
            oferta:akcja()
        end
        kafelek.x = kafelek.x + slotSize + spacing
    end
end

return Sklepik
