local Dialog = {}

Dialog.znaki_na_sekunde = 20
Dialog.znaki = 0
Dialog.czas = 0
Dialog.bohaterowie = {}
Dialog.kolejka = {}
Dialog.aktywny = nil

function Dialog.bohater(imie, nazwa_pliku)
    -- dodaje postać z grafiką
end

function Dialog.wiadomosc(imie, tekst)
    -- dodaje wiadomość do kolejki
end

function Dialog.update(dt)
    -- aktualizuje dialog
end

function Dialog.draw()
    local y = 50
    -- rysuje portret bohatera
    local bohater = Dialog.bohaterowie[Dialog.aktywny.imie]
    if bohater and bohater.portret then
        love.graphics.draw(bohater.portret, 50, y)
    end
    -- tło
    love.graphics.rectangle("fill", 50 + bohater.portret:getWidth(), y, font:getWidth(Dialog.aktywny.tekst) + 50, 150)
    -- tekst
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(bohater.imie .. ":", 70 + bohater.portret:getWidth(), y + 20)
    love.graphics.print(Dialog.aktywny.tekst, 70 + bohater.portret:getWidth(), y + 80)
end

return Dialog
