extends Node3D

var secuencia_correcta = [5, 3, 1, 2, 6, 4]
var progreso = []

func comprobar_palanca(numero, agregando):
	if agregando:
		progreso.append(numero)
	else:
		progreso.erase(numero)
		
	print("Progreso actual: ", progreso)
	
	if progreso.size() == secuencia_correcta.size():
		validar_secuencia()

func validar_secuencia():
	if progreso == secuencia_correcta:
		print("Secuencia Correcta")
	else:
		print("Secuencia Incorrecta")
		progreso.clear()
		get_tree().call_group("grupo_palancas", "reiniciar")
		
