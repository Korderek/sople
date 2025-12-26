local Przegrana = {}

local teksty = {
    sople = { "Sople cię pocięły, boli?",
        "Sople: 1, Ty: 0. Chcesz się zrewanżować?",
        "W przyszłym życiu patrz więcej w górę.",
        "Ups, sopel znalazł twój łeb.",
        "To już koniec... znów przez sople.",
        "Nie zdążyłeś nawet krzyknąć 'ajć'.",
        "Kto by pomyślał, że lód może być tak śmiertelny?",
        "Sopel pozdrawia twoje czoło.",
        "A miałeś tak dobry plan...",
        "To był szybki koniec, gratulacje.",
        "Jak tam twoje unikanie sopli? Bo moje świetnie.",
        "I znowu lodowa porażka...",
        "Sopel trafił krytyka. Ty nie.",
        "Twoja głowa spotkała się z fizyką.",
        "Sople są zimne, ale ich intencje gorsze.",
        "No dobra, to może teraz bez dotykania lodu?",
        "Na szczęście to tylko gra... prawda?",
        "Gdyby sopel miał poczucie humoru, to by się przedstawił.",
        "Okrzyk bojowy: 'Nie patrz w sufit!'",
        "Sople 2. Ty 0. Remis nie wchodzi w grę.",
        "Zimowa niespodzianka prosto na głowę.",
        "Może kup sobie kask z owczej wełny?",
        "Kolejna mikrowyprawa na lód zakończona sukcesem... dla sopla.",
        "Zapomniano dopisać 'nie dotykać'.",
        "Twoje włosy już wiedzą, że to koniec.",
        "Przynajmniej był efektowny upadek.",
        "Wygląda na to, że sopel miał lepszy timing niż ty.",
        "Znowu zaskoczony. Cóż za innowacja.",
        "Chwileczkę, czy sopel miał profil na Instagramie?",
        "Darmowy masaż głowy od natury.",
        "Sople: naturalne trampki dla głów.",
        "Chyba zasłużyłeś na medalik 'Ofiara Sopla'.",
        "Nie martw się, to tylko liść... z lodu.",
        "Może następnym razem załóż parasol?",
        "Gratulacje, właśnie wygrałeś lodową loterię.",
        "Twoja głowa osiągnęła nowe temperatury.",
        "Sople: twarde, zimne, bezlitosne.",
        "Zimowy zespół kryształów wykazał aktywność.",
        "Sople – naturalni testerzy wytrzymałości czaszki.",
        "Następnym razem uśmiechnij się do sufitu.",
        "Śnieg poszedł w ruch, ty nie.",
        "Może spróbuj uczyć się od pingwinów?",
        "Sopel polecił ci swoją listę przebojów.",
        "To nie była porażka, to spektakl w trzech aktach.",
        "Trochę lodu nigdy nie zaszkodzi... chyba że na głowie.",
        "Zimowe powitanie było zbyt entuzjastyczne.",
        "Sople miały plan i go wykonały.",
        "Twoja głowa zgłosiła się na ochotnika.",
        "Pomyśl o tym jako o szybkim schłodzeniu.",
        "Sople nie znają pojęcia 'przepraszam'.",
        "Chyba ktoś zapomniał zaprosić cię na imprezę sufitu.",
        "To był szybki kontakt z naturą.",
        "Głowa vs sopel — wynik przewidywalny.",
        "Następnym razem weź kask i sense.",
        "Tak kończą ciekawscy.",
        "Sople: bo świat potrzebuje dramatu.",
        "Twoje plany na dziś: uniknąć spadającego lodu.",
        "Sople mają swoje priorytety.",
        "To nie jest porażka, to epicka historia.",
        "Twarde lądowanie z nutką lodu.",
        "Mogłeś przynajmniej zadzwonić, zanim cię dotknął.",
        "Sopel wykonał idealny obrót.",
        "Twoje życie w kilku kiepskich klatkach.",
        "Głowa nie jest przystosowana do sopli.",
        "Kolejna lekcja: sufit nie jest przyjacielem.",
        "Przynajmniej był efekt świetlny.",
        "Sople zrobiły ci psikusa i wygrały.",
        "Wygląda na to, że przegrywasz z meteorologią.",
        "Nie oceniaj książki po okładce, ale sufit po wyglądzie.",
        "Sople: łączymy ludzi z podłogą od wieków.",
        "Może zacznij biegać szybciej, albo wolniej?",
        "Lód robi swoje — bez litości.",
        "Twoja głowa jest teraz ładnie udekorowana.",
        "Sople miały lepsze plany weekendowe.",
        "Zimowy upadek z darmowym efektem dźwiękowym.",
        "Wygląda na to, że sufit miał dla ciebie komunikat.",
        "Kolejny dzień, kolejna lodowa przygoda.",
        "Nigdy nie ufaj temu, co zwisa z góry.",
        "Sople są jak teściowa — niespodziewane i ostre.",
        "Przyszłość przewiduje lód i dużo bandaży.",
        "Może spróbuj porozumieć się z soplami?",
        "Głowa na linii frontu — dosłownie.",
        "Sople mają preferencje smakowe: twoja głowa.",
        "Powinieneś założyć GPS na sufit.",
        "Zimowy anioł zrobił ci krzywdę.",
        "Sopel: mały, zimny, PRZECIWKO tobie.",
        "Twoja pozycja w rankingu: ofiara dnia.",
        "Sople wystawiły ci rachunek.",
        "Nie martw się, opowiesz to wnukom... jeśli będą słuchać.",
        "Może to był test odwagi? Nie zdałeś.",
        "Cóż, przynajmniej było zabawnie... dla sopla.",
        "Uwaga: lokalne sople w natarciu.",
        "Twoja głowa przeszła w tryb 'lodowy'.",
        "Sople mają własne poczucie stylu: twój łeb.",
        "Zimna lekcja o grawitacji.",
        "Sople i ty — historia zatoczyła krąg.",
        "Kolejny poziom: 'Dotyk sopla' — pogratulować?",
        "Twoje plany vs natura: sumarycznie natura 1.",
        "Sople napisały ci wiadomość: 'pa!'",
    },

    -- teksty z pustynią
    pustynia = {
        "Pustynia cię spaliła — piasek wszędzie.",
        "Słońce pali, może przyda się woda?",
        "Burza piaskowa przyniosła szybkie pożegnanie.",
        "Twoja głowa czuje się jak wydma.",
        "Oaza miała inne plany.",
        "Gorący piasek i zimny lód — fatalne połączenie.",
        "Skały pustyni nie wybaczają błędów.",
        "Zamiast sopla dostałeś kamień i kurz.",
        "Pustynny upadek — brak śniegu, więcej pyłu.",
        "Może następnym razem weź ze sobą butelkę wody.",
    }
}

local losowyTekst = ""

function Przegrana.load()
    if stanGry == stan.sople then
        losowyTekst = teksty.sople[love.math.random(#teksty.sople)]
    elseif stanGry == stan.pustynia then
        losowyTekst = teksty.pustynia[love.math.random(#teksty.pustynia)]
    end
    wynik_koniec = math.floor(punkty)
    Efekty.rozpocznijLadowanie(function() stanGry = stan.przegrana end)
end

function Przegrana.draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(losowyTekst, font, 0, wysokosc / 2 - 20, szerokosc, "center")
    love.graphics.printf("Wynik: " .. wynik_koniec, font, 0, wysokosc / 2 + 40, szerokosc, "center")
    love.graphics.printf("Najlepszy wynik: " .. najlepszy_wynik, font, 0, wysokosc / 2 + 80, szerokosc, "center")
    love.graphics.printf("Monety: " .. zebraneMonety, font, 0, wysokosc / 2 + 120, szerokosc, "center")
end

return Przegrana
