extends StaticBody3D

@export var numero_palanca : int = 1
@export var cerebro_puzzle : Node3D

var esta_bajada = false

func iniciar_puzzle():
	esta_bajada = !esta_bajada
	
	if esta_bajada:
		rotation_degrees.x = -45
	else:
		rotation_degrees.x = 0
		
	if cerebro_puzzle:
		cerebro_puzzle.comprobar_palanca(numero_palanca, esta_bajada)
		
func reiniciar():
	esta_bajada = false
	rotation_degrees.x = 0
