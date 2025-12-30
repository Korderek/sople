local Sound = {}

local dostalem = {
    love.audio.newSource("assets/sound/voice-hit-1.wav", "static"),
    love.audio.newSource("assets/sound/voice-hit-2.wav", "static"),
    love.audio.newSource("assets/sound/voice-hit-3.wav", "static"),
    love.audio.newSource("assets/sound/voice-hit-4.wav", "static"),
}
local skok_odbicie = {
    love.audio.newSource("assets/sound/jump-1.wav", "static"),
    love.audio.newSource("assets/sound/jump-2.wav", "static"),
    love.audio.newSource("assets/sound/jump-3.wav", "static"),
    love.audio.newSource("assets/sound/jump-4.wav", "static"),
}
local skok_ladowanie = {
    love.audio.newSource("assets/sound/land-1.wav", "static"),
    love.audio.newSource("assets/sound/land-2.wav", "static"),
    love.audio.newSource("assets/sound/land-3.wav", "static"),
    love.audio.newSource("assets/sound/land-4.wav", "static"),
}
local bieg_piasek = {
    love.audio.newSource("assets/sound/sand-run-1.wav", "static"),
    love.audio.newSource("assets/sound/sand-run-2.wav", "static"),
    love.audio.newSource("assets/sound/sand-run-3.wav", "static"),
    love.audio.newSource("assets/sound/sand-run-4.wav", "static"),
    love.audio.newSource("assets/sound/sand-run-5.wav", "static"),
    love.audio.newSource("assets/sound/sand-run-6.wav", "static"),
    love.audio.newSource("assets/sound/sand-run-7.wav", "static"),
}
local bieg_snieg = {
    love.audio.newSource("assets/sound/snow-run-1.wav", "static"),
    love.audio.newSource("assets/sound/snow-run-2.wav", "static"),
    love.audio.newSource("assets/sound/snow-run-3.wav", "static"),
    love.audio.newSource("assets/sound/snow-run-4.wav", "static"),
    love.audio.newSource("assets/sound/snow-run-5.wav", "static"),
}
local zatrzymanie_snieg = {
    love.audio.newSource("assets/sound/snow-stop-1.wav", "static"),
    love.audio.newSource("assets/sound/snow-stop-2.wav", "static"),
    love.audio.newSource("assets/sound/snow-stop-3.wav", "static"),
}
local wslizg = love.audio.newSource("assets/sound/slide.wav", "static")
local sklepik_otworz = love.audio.newSource("assets/sound/shop-open.wav", "static")
local sklepik_wyjscie = love.audio.newSource("assets/sound/shop-close.wav", "static")
local sklepik_zakup = love.audio.newSource("assets/sound/shop-buy.wav", "static")
local trafiony = love.audio.newSource("assets/sound/hit.wav", "static")
local kursor_najechal = love.audio.newSource("assets/sound/hover.wav", "static")
local kursor_klik = love.audio.newSource("assets/sound/click.wav", "static")
local kursor_potwierdz = love.audio.newSource("assets/sound/confirm.wav", "static")
local moneta = love.audio.newSource("assets/sound/coin.wav", "static")
local moneta_jingle = love.audio.newSource("assets/sound/coin-jingle.wav", "static")
local przegrana = love.audio.newSource("assets/sound/game-over.wav", "static")
local ulepszenie = love.audio.newSource("assets/sound/upgrade.wav", "static")
local boss_gotowy = love.audio.newSource("assets/sound/boss-get-ready.wav", "static")
local boss_wejscie = love.audio.newSource("assets/sound/boss-enter.flac", "static")
local boss_smiech = love.audio.newSource("assets/sound/boss-laugh.flac", "static")

function Sound.sklepik_otworz()
    sklepik_otworz:clone():play()
end

function Sound.sklepik_wyjscie()
    sklepik_wyjscie:clone():play()
end

function Sound.sklepik_zakup()
    sklepik_zakup:clone():play()
    local jingle = ulepszenie:clone()
    jingle:setVolume(0.8)
    jingle:setPitch(1.1)
    jingle:play()
end

function Sound.kursor_najechal()
    kursor_najechal:clone():play()
end

function Sound.kursor_klik()
    kursor_klik:clone():play()
end

function Sound.kursor_potwierdz()
    local potwierdz = kursor_potwierdz:clone()
    potwierdz:setPitch(love.math.random(1.2))
    potwierdz:setVolume(0.7)
    potwierdz:play()
end

function Sound.moneta()
    local brzek = moneta:clone()
    brzek:setPitch(love.math.random(0.8, 1.2))
    brzek:setVolume(1.2)
    brzek:play()
    local jingle = moneta_jingle:clone()
    jingle:setPitch(1.5)
    jingle:play()
end

function Sound.wslizg()
    wslizg:setPitch(love.math.random(0.8, 1.2))
    wslizg:clone():play()
end

function Sound.trafiony()
    trafiony:setPitch(love.math.random(0.8, 1.2))
    trafiony:clone():play()
    dostalem[love.math.random(1, #dostalem)]:clone():play()
end

function Sound.przegrana()
    przegrana:clone():play()
end

function Sound.skok_odbicie()
    skok_odbicie[love.math.random(1, #skok_odbicie)]:clone():play()
end

function Sound.skok_ladowanie()
    skok_ladowanie[love.math.random(1, #skok_ladowanie)]:clone():play()
end

function Sound.kroki_snieg()
    local krok = bieg_snieg[love.math.random(1, #bieg_snieg)]:clone()
    krok:setVolume(0.2)
    krok:play()
end

function Sound.kroki_piasek()
    local krok = bieg_piasek[love.math.random(1, #bieg_piasek)]:clone()
    krok:setVolume(0.2)
    krok:play()
end

function Sound.stop_snieg()
    local stop = zatrzymanie_snieg[love.math.random(1, #zatrzymanie_snieg)]:clone()
    stop:setVolume(0.2)
    stop:play()
end

function Sound.boss_przygotuj_sie()
    boss_gotowy:play()
end

function Sound.boss_wejscie()
    boss_wejscie:play()
end

function Sound.boss_smiech()
    boss_smiech:play()
end

return Sound
