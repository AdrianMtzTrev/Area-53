extends StaticBody3D

var ui_frecuencia_escena = preload("res://UI/UI_Frecuencia.tscn")

func iniciar_puzzle():
	var ui = ui_frecuencia_escena.instantiate()
	
	get_tree().root.add_child(ui)
	
	#Mostramos mouse en pantalla nuevamente
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
