shader_type canvas_item;

// Variables ajustadas para ser muy sutiles
uniform float curvature = 15.0; 
uniform float scanline_count = 100.0; 
uniform float scanline_intensity = 0.08; 
uniform float vignette_multiplier = 0.25;

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
        float scanlines = 0.5 - cos(warped_uv.y * scanline_count * 3.14159) * 0.5;
        float vignette = length(centered_uv) * vignette_multiplier;
		float oscuridad = (scanlines * scanline_intensity) + vignette;

        COLOR = vec4(0.0, 0.0, 0.0, oscuridad);
    }
}