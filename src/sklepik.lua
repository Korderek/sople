local UI = require("src.ui")
local Dialog = require("src.dialog")

local Sklepik = {
    aktywny = false,
    ceny = {
        zycie = 10,
        predkosc = 15,
        skin = 0
    }
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

    -- Życie +1
    if UI.przycisk({
            x = startX,
            y = startY,
            width = slotSize,
            height = 50
        }, "Życie +" .. Sklepik.ceny.zycie) then
        if zycia < 3 and zebraneMonety >= Sklepik.ceny.zycie then
            zebraneMonety = zebraneMonety - Sklepik.ceny.zycie
            zycia = zycia + 1
            Sklepik.ceny.zycie = Sklepik.ceny.zycie + 5
        elseif zycia >= 3 then
            zebraneMonety = zebraneMonety + Sklepik.ceny.zycie
        end
    end

    -- Szybkość +
    if UI.przycisk({
            x = startX + slotSize + spacing,
            y = startY,
            width = slotSize,
            height = 50
        }, "Szybkość +" .. Sklepik.ceny.predkosc) then
        if zebraneMonety >= Sklepik.ceny.predkosc then
            zebraneMonety = zebraneMonety - Sklepik.ceny.predkosc
            predkoscGracza = predkoscGracza + 1
            Sklepik.ceny.predkosc = Sklepik.ceny.predkosc + 5
        end
    end

    -- Lepszy skin
    if UI.przycisk({
            x = startX + (slotSize + spacing) * 2,
            y = startY,
            width = slotSize,
            height = 50
        }, "Skin " .. Sklepik.ceny.skin) then
        if zebraneMonety >= Sklepik.ceny.skin then
            zebraneMonety = zebraneMonety - Sklepik.ceny.skin
            gracz.skin = spioszekImg -- zmiana skina
            Sklepik.ceny.skin = Sklepik.ceny.skin + 20
        end
    end
end

return Sklepik
