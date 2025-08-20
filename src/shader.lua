local Shader = {}

local obramowanie = love.graphics.newShader([[
    extern number outline_width = 30.0;
    extern vec4 outline_color = vec4(1.0, 1.0, 1.0, 1.0);
    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
    {
        float threshold = 0.1; // alpha threshold
        float outline = 0.0;
        float alpha = Texel(texture, texture_coords).a;

        if (alpha < threshold) {
            // Check surrounding pixels within outline_width
            for (float x = -outline_width; x <= outline_width; x++) {
                for (float y = -outline_width; y <= outline_width; y++) {
                    if (x*x + y*y > outline_width*outline_width) continue;
                    vec2 offset = vec2(x, y) / love_ScreenSize.yx;
                    float a = Texel(texture, texture_coords + offset).a;
                    if (a >= threshold) {
                        outline = 1.0;
                    }
                }
            }
        }

        if (outline > 0.0) {
            return outline_color;
        } else {
            return Texel(texture, texture_coords) * color;
        }
    }
]])

function Shader.obramowanie(grubosc, kolor)
    obramowanie:send("outline_width", grubosc or 20)
    obramowanie:send("outline_color", kolor or { 1, 1, 1, 1 })
    love.graphics.setShader(obramowanie)
end

function Shader.koniec()
    love.graphics.setShader()
end

return Shader
