local UI = require("src.ui")
local Dialog = require("src.dialog")

local Sklepik = {
    aktywny = false,
}

Sklepik.oferta = {
    zycie = {
        nazwa = "Życie+",
        cena = 10,
        dostepna = function(towar)
            return zebraneMonety >= towar.cena and zycia < 3
        end,
        akcja = function(towar)
            zebraneMonety = zebraneMonety - towar.cena
            zycia = zycia + 1
            towar.cena = towar.cena + 5
        end,
    },
    predkosc = {
        nazwa = "Szybkość+",
        cena = 10,
        dostepna = function(towar)
            return zebraneMonety >= towar.cena
        end,
        akcja = function(towar)
            zebraneMonety = zebraneMonety - towar.cena
            predkoscGracza = predkoscGracza + 1
            towar.cena = towar.cena + 5
        end,
    },
    skin = {
        nazwa = "Skin",
        cena = 0,
        dostepna = function(towar)
            return zebraneMonety >= towar.cena
        end,
        akcja = function(towar)
            zebraneMonety = zebraneMonety - towar.cena
            gracz.skin = spioszekImg -- zmiana skina
            towar.cena = towar.cena + 20
        end,
    },
}

function Sklepik.otworz()
    Sklepik.aktywny = true

    local powitanie = {
        "Witaj w sklepiku!",
        "Czego Ci potrzeba?",
        "Tanio i dobrze, rozejrzyj się i kupuj!",
        "Witaj, mam dla Ciebie kilka nowości!",
    }
    Dialog.wyczysc() -- zamykamy wyświetlone wiadomości
    Dialog.wiadomosc("Sprzedawca", powitanie[love.math.random(1, #powitanie)])
end

function Sklepik.zamknij()
    Sklepik.aktywny = false
    Dialog.wyczysc()
end

function Sklepik.draw()
    if not Sklepik.aktywny then return end

    -- półprzezroczyste tło na cały ekran
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.rectangle("fill", 0, 0, szerokosc, wysokosc)

    -- ramka sklepu (środek ekranu)
    local boxW, boxH = 600, 400
    local boxX, boxY = (szerokosc - boxW) / 2, (wysokosc - boxH) / 2
    love.graphics.setColor(0.2, 0.2, 0.2, 0.9)
    love.graphics.rectangle("fill", boxX, boxY, boxW, boxH)
    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", boxX, boxY, boxW, boxH)

    -- tytuł
    love.graphics.setFont(font)
    love.graphics.printf("Sklepik", boxX, boxY + 10, boxW, "center")

    -- przycisk zamknięcia (prawy górny róg sklepu)
    if UI.przycisk({
            x = boxX + boxW - 40,
            y = boxY + 10,
            width = 30,
            height = 30
        }, "X") then
        Sklepik.zamknij()
    end

    -- przyciski ofert (w siatce jak w Minecraft)
    local startX, startY = boxX + 40, boxY + 80
    local slotSize = 150
    local spacing = 20
    local kafelek = { x = startX, y = startY, width = slotSize, height = slotSize }

    local aktualnaOferta = {
        Sklepik.oferta.zycie,
        Sklepik.oferta.skin,
        Sklepik.oferta.predkosc,
    }

    for _, oferta in ipairs(aktualnaOferta) do
        local tekst = oferta.nazwa .. " " .. oferta.cena
        if UI.przycisk_sklepik(kafelek, tekst, not oferta:dostepna()) and oferta:dostepna() then
            oferta:akcja()
        end
        kafelek.x = kafelek.x + slotSize + spacing
    end
end

return Sklepik
