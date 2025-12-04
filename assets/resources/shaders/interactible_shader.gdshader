shader_type canvas_item;

uniform float outline_size = 2.0;
uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    vec4 final_color = tex;

    if (tex.a == 0.0) {
        float alpha = 0.0;

        for (int x = -1; x <= 1; x++) {
            for (int y = -1; y <= 1; y++) {
                vec2 offset_uv = UV + vec2(float(x), float(y)) * outline_size / TEXTURE_PIXEL_SIZE;
                alpha = max(alpha, texture(TEXTURE, offset_uv).a);
            }
        }

        if (alpha > 0.0) {
            final_color = outline_color;
        } else {
            final_color = vec4(0.0);
        }
    }

    COLOR = final_color;
}
