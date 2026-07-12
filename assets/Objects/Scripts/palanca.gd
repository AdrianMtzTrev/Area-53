extends StaticBody3D

@export var numero_palanca : int = 1
@export var cerebro_puzzle : Node3D

var esta_bajada = false

@onready var foco_led = $FocoLED
#@onready var mesh_palanca = $MeshPalanca

func _ready():
	cambiar_color_led(Color(1,0,0))

func iniciar_puzzle():
	esta_bajada = !esta_bajada
	
	if esta_bajada:
		cambiar_color_led(Color(0,1,0))
	else:
		cambiar_color_led(Color(1,0,0))
		
	if cerebro_puzzle:
		cerebro_puzzle.comprobar_palanca(numero_palanca, esta_bajada)
		
func reiniciar():
	esta_bajada = false
	cambiar_color_led(Color(1,0,0))
	
func cambiar_color_led(color_nuevo: Color):
	var material_led = StandardMaterial3D.new()
	material_led.albedo_color = color_nuevo
	
	material_led.emission_enabled = true
	material_led.emission = color_nuevo
	material_led.emission_energy_multiplier = 2.0
	
	foco_led.material_override = material_led
