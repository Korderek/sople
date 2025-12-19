local json = require("plugins.json") -- Ładuje moduł JSON

local Zapis = {}

function Zapis.pusty()
    return { najlepszy_wynik = 0, monety = 0 }
end

-- Funkcja zapisująca stan do pliku zapis.json
function Zapis.zapisz(stan)
    local jsonDane = json.encode(stan)            -- Koduje stan do formatu JSON
    love.filesystem.write("zapis.json", jsonDane) -- Zapisuje dane do pliku
end

-- Funkcja wczytująca stan z pliku zapis.json
function Zapis.wczytaj()
    if love.filesystem.getInfo("zapis.json") then           -- Sprawdza czy plik istnieje
        local jsonDane = love.filesystem.read("zapis.json") -- Odczytuje dane z pliku
        return json.decode(jsonDane)                        -- Dekoduje dane JSON i zwraca
    else
        return Zapis.pusty()
    end
end

return Zapis -- Zwraca moduł
