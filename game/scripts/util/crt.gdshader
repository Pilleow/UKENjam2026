shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform vec2 resolution = vec2(320.0, 180.0);
uniform float scan_line_amount : hint_range(0.0, 1.0) = 0.18;
uniform float warp_amount : hint_range(0.0, 1.0) = 0.015;
uniform float vignette_intensity = 0.4;
uniform float vignette_opacity : hint_range(0.0, 1.0) = 0.5;
uniform vec4 vignette_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float grille_amount : hint_range(0.0, 1.0) = 0.03;
uniform float brightness_boost : hint_range(1.0, 2.0) = 1.03;

float vignette(vec2 uv) {
    vec2 v = uv * (1.0 - uv);
    float vx = pow(v.x * 4.0, vignette_intensity);
    float vy = pow(v.y * 4.0, vignette_intensity);
    return clamp(min(vx, vy) * vignette_opacity, 0.0, 1.0);
}

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 delta = uv - 0.5;
    float warp_factor = dot(delta, delta) * warp_amount;
    uv += delta * warp_factor;

    float scanline = sin(uv.y * resolution.y * PI) * 0.5 + 0.5;
    scanline = mix(1.0, scanline, scan_line_amount * 0.5);

    float grille = mod(uv.x * resolution.x, 3.0) < 1.5 ? 0.98 : 1.02;
    grille = mix(1.0, grille, grille_amount * 0.5);

    vec3 color = texture(SCREEN_TEXTURE, uv).rgb * scanline * grille;

    float vig = vignette(SCREEN_UV);
    color = mix(vignette_color.rgb, color, vig) * brightness_boost;

    COLOR.rgb = color;
    COLOR.a = 1.0;
}