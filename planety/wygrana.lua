local Wygrana = {}

function Wygrana.czy_wygral()
    return
end

function Wygrana.draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("WYGRAŁEŚ!!!!", font, 0, wysokosc / 2 - 20, szerokosc, "center")
    love.graphics.printf("Wynik: " .. wynik_koniec, font, 0, wysokosc / 2 + 40, szerokosc, "center")
    love.graphics.printf("Najlepszy wynik: " .. najlepszy_wynik, font, 0, wysokosc / 2 + 80, szerokosc, "center")
    love.graphics.printf("Monety: " .. zebraneMonety, font, 0, wysokosc / 2 + 120, szerokosc, "center")
end

return Wygrana
