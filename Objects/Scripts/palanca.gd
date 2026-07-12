extends StaticBody3D

@export var numero_palanca : int = 1
@export var cerebro_puzzle : Node3D

var bajada = false

func iniciar_puzzle():
	if bajada: return
	
	bajada = true
	rotation_degrees.x = -45
	
	if cerebro_puzzle:
		cerebro_puzzle.comprobar_palanca(numero_palanca)
		
func reiniciar():
	bajada = false
	rotation_degrees.x = 0
