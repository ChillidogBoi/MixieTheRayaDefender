// Atlas Region Tiled Repeat (2D) by Cammymoop

shader_type canvas_item;

uniform vec2 tile_factor = vec2(1.0, 1.0);

void fragment() {
    vec2 tex_size = vec2(textureSize(TEXTURE, 0));
    vec2 seem_hiding = vec2(1.0/64.0) / tex_size;
    vec2 seem_scale = vec2(1.0) - seem_hiding * 2.0;
    
    vec2 tiled_pixel = mod((UV - REGION_RECT.xy) * tile_factor, REGION_RECT.zw) * seem_scale + seem_hiding;
    
    COLOR = texture(TEXTURE, (tiled_pixel + REGION_RECT.xy));
}