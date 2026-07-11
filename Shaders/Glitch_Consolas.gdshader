shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

// Variables ajustadas para ser muy sutiles
uniform float curvature = 4.0; // Curva suave
uniform float scanline_count = 120.0; // Muchas líneas para que se vean muy finas
uniform float scanline_intensity = 0.05; // Intensidad casi invisible (5%)
uniform float vignette_multiplier = 0.2; // Bordes solo un poco oscuros

void fragment() {
    // 1. Curvar la pantalla
    vec2 centered_uv = UV * 2.0 - 1.0;
    vec2 offset = centered_uv.yx / curvature;
    vec2 warped_uv = centered_uv + centered_uv * offset * offset;
    warped_uv = warped_uv * 0.5 + 0.5;

    // 2. Pintar de negro absoluto si la curva sale de los bordes del recuadro
    if (warped_uv.x < 0.0 || warped_uv.x > 1.0 || warped_uv.y < 0.0 || warped_uv.y > 1.0) {
        COLOR = vec4(0.0, 0.0, 0.0, 1.0);
    } else {
        // 3. Leer los colores de lo que está dibujado detrás (textos, slider, onda)
        vec4 base_color = texture(screen_texture, warped_uv);

        // 4. Aplicar líneas de escaneo estáticas y tenues
        float scanlines = 0.5 - cos(warped_uv.y * scanline_count * 3.14159) * 0.5;
        base_color.rgb -= scanlines * scanline_intensity;

        // 5. Oscurecer las esquinas (Viñeta) para dar volumen al cristal
        float vignette = length(centered_uv) * vignette_multiplier;
        base_color.rgb -= vignette;

        COLOR = base_color;
    }
}