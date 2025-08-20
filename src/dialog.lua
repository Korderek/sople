local Dialog = {}
local utf8 = require("utf8")
local fragment = function(s, i)
    i = math.min(i, utf8.len(s)) -- upewniamy się, że i nie przekracza długości tekstu
    return string.sub(s, 1, utf8.offset(s, i + 1) - 1)
end

Dialog.znaki_na_sekunde = 20
Dialog.znaki = 0
Dialog.czas = 0
Dialog.bohaterowie = {}
Dialog.kolejka = {}
Dialog.aktywny = nil

spacja = { wcisnieta = false, kliknieta = false }

-- Dodaje nowego bohatera o podanym imieniu
function Dialog.bohater(imie, nazwa_pliku)
    -- dodaje postać z grafiką do listy bohaterów
    if not Dialog.bohaterowie[imie] then
        local portret = love.graphics.newImage(nazwa_pliku)
        Dialog.bohaterowie[imie] = {
            imie = imie,
            portret = portret,
        }
    end
end

-- Czyści kolejkę wiadomości i zamyka aktywną wiadomość
function Dialog.wyczysc()
    Dialog.kolejka = {}
    Dialog.aktywny = nil
end

-- Wstawia nową wiadomość do kolejki wiadomości
function Dialog.wiadomosc(imie, tekst)
    -- dodaje wiadomość do kolejki
    table.insert(Dialog.kolejka, {
        imie = imie,
        tekst = tekst,
    })
end

-- Przechodzi do kolejnej wiadomości w kolejce
function Dialog.nastepna_wiadomosc()
    -- pobiera następną wiadomość z kolejki
    if #Dialog.kolejka > 0 then -- # to dlugosc kolejki
        Dialog.aktywny = table.remove(Dialog.kolejka, 1)
        Dialog.znaki = 0
        Dialog.czas = 0
    else
        Dialog.aktywny = nil
    end
end

function Dialog.update(dt)
    spacja.kliknieta = love.keyboard.isDown("space") and not spacja.wcisnieta
    spacja.wcisnieta = love.keyboard.isDown("space")

    -- aktualizuje dialog
    if not Dialog.aktywny then
        if #Dialog.kolejka > 0 then
            Dialog.nastepna_wiadomosc()
        end
    else
        Dialog.czas = Dialog.czas + dt
        Dialog.znaki = math.floor(Dialog.czas * Dialog.znaki_na_sekunde)

        if spacja.kliknieta then
            if Dialog.znaki >= utf8.len(Dialog.aktywny.tekst) then
                Dialog.nastepna_wiadomosc() -- jeśli wszystkie znaki zostały wyświetlone, przechodzimy do następnej wiadomości
            else
                Dialog.czas = 999999        -- jeśli spacja została wciśnięta, wyświetlamy cały tekst
            end
        end
    end
end

function Dialog.draw()
    if not Dialog.aktywny then return end                      -- jeśli nie ma aktywnej wiadomości, nic nie rysujemy

    local tekst = fragment(Dialog.aktywny.tekst, Dialog.znaki) -- wyświetlamy tylko tyle znaków, ile zostało przetworzonych

    local y = 50
    -- reset koloru
    love.graphics.setColor(1, 1, 1, 1)
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
    love.graphics.print(tekst, 70 + bohater.portret:getWidth(), y + 80)
end

return Dialog
