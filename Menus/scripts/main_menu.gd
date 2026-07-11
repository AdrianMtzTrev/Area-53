extends Control
class_name Main_Menu



func _on_start_bttn_pressed() -> void:
	pass # Se elimina escena y se manda a la escena1
	#get_tree().change_scene_to_file("res://...")
	

func _on_exit_bttn_pressed() -> void:
	get_tree().quit()
