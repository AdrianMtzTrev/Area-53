shader_type canvas_item;

// Controla qué tan oscuro es el fondo (0.0 transparente, 1.0 negro total)
uniform float oscuridad : hint_range(0.0, 1.0) = 0.7;
// Controla la fuerza de la estática
uniform float estatica : hint_range(0.0, 1.0) = 0.15;

void fragment() {
    // Genera ruido aleatorio basado en la posición y el tiempo
    float ruido = fract(sin(dot(UV + TIME, vec2(12.9898, 78.233))) * 43758.5453);

    // Pinta la pantalla de negro, pero le suma el ruido gris/blanco
    vec3 color_base = vec3(0.0) + vec3(ruido * estatica);

    COLOR = vec4(color_base, oscuridad);
}