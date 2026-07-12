extends Control
class_name Main_Menu



func _on_start_bttn_pressed() -> void:
	get_tree().change_scene_to_file("res://Objects/escena_test.tscn")


func _on_exit_bttn_pressed() -> void:
	get_tree().quit()
