local Shader = {}

local obramowanie = love.graphics.newShader([[
    uniform float outline_width;
    uniform vec4 outline_color;

    const float MAX_OUTLINE = 50.0;
    const float PI2 = 2.0 * 3.14159265358979323846;
    const float DIRS = 8.0;

    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
    {
        float threshold = 0.05; // alpha threshold
        float outline = 0.0;
        float alpha = Texel(texture, texture_coords).a;

        if (alpha < threshold) {
            for (float i = 0.0; i < DIRS; i++) {
                for (float r = 0.0; r <= MAX_OUTLINE; r++) {
                    if (r > outline_width) break;
                    float angle = i * PI2 / DIRS;
                    float x = r * cos(angle);
                    float y = r * sin(angle);
                    vec2 pixel = 1.0 / love_ScreenSize.yx;
                    vec2 offset = vec2(x, y) * pixel;
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

local szarosc = love.graphics.newShader([[
    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
    {
        vec4 pixel = Texel(texture, texture_coords) * color;
        float gray = dot(pixel.rgb, vec3(0.299, 0.587, 0.114));
        return vec4(gray, gray, gray, pixel.a);
    }
]])

function Shader.obramowanie(grubosc, kolor)
    if grubosc <= 0 then return end
    obramowanie:send("outline_width", grubosc or 30)
    obramowanie:send("outline_color", kolor or { 1, 1, 1, 1 })
    love.graphics.setShader(obramowanie)
end

function Shader.szarosc()
    love.graphics.setShader(szarosc)
end

function Shader.koniec()
    love.graphics.setShader()
end

return Shader
