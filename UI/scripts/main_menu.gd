extends Control
class_name Main_Menu

@onready var animador = $FadeLayer/AnimationPlayer

func _on_start_bttn_pressed() -> void:
	animador.play("Fade_to_Black")
	await animador.animation_finished
	get_tree().change_scene_to_file("res://UI/transicion.tscn")


func _on_exit_bttn_pressed() -> void:
	get_tree().quit()
