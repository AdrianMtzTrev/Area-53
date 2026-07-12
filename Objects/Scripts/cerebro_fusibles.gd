extends Node3D

var secuencia_correcta = [5, 3, 1, 2, 6, 4]
var progreso = []

func comprobar_palanca(numero):
	progreso.append(numero)
	var indice = progreso.size() -1
	
	#contraseña incorrecta
	if progreso[indice] != secuencia_correcta[indice]:
		print("Secuencia incorrecta")
		progreso.clear()
		get_tree().call_group("grupo_palancas", "reiniciar")
	else:
		print("Secuencia Correcta")
		
