shader_type canvas_item;

uniform float vignette_intensity = 0.4;
uniform float vignette_opacity : hint_range(0.0, 1.0) = 0.5;
uniform vec4 vignette_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

float vignette(vec2 uv){
    uv *= 1.0 - uv;
    float v = uv.x * uv.y * 15.0;
    return pow(v, vignette_intensity * vignette_opacity);
}

void fragment(){
    vec4 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV);

    float vig = vignette(UV);

    // blend vignette
    screen_color.rgb = mix(vignette_color.rgb, screen_color.rgb, vig);

    COLOR = screen_color;
}