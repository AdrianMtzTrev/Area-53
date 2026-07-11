extends CanvasLayer

func _ready():
	print("Juego en Pausa")
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		reaunudar_juego()
		
	
func _on_btn_menu_pressed():
	get_tree().paused = false
	queue_free()
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")
	
func _on_btn_salir_pressed():
	get_tree().quit()

func _on_btn_reanudar_pressed() -> void:
	reaunudar_juego()
	
func reaunudar_juego():
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	queue_free()
