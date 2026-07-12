extends CanvasLayer

@onready var texto_label = $TextoHistoria
@onready var animador = $AnimationPlayer
@onready var pantalla_fade = $PantallaFade

var parrafos = [
	"Área 53. El Área 51 ya existía, así que supongo que tuvieron que improvisar.",
 	"Oficialmente es una base militar abandonada. Extraoficialmente... es el tipo de lugar donde la gente baja la voz cuando empieza a hacer preguntas.",
 	"Meses de documentos, teorías y registros de radio. Antenas gigantes apuntando al espacio, esperando respuestas... o enviando preguntas.",
 	"Y ahora estoy aquí. Solo. En plena noche. Porque, si las películas me han enseñado algo, es que esto nunca termina mal."]

func _ready():
	pantalla_fade.modulate.a = 1.0
	texto_label.text = ""
	
	animador.play("fade_in")
	await animador.animation_finished
	
	await mostrar_historia()
	
func mostrar_historia():
	for p in parrafos:
		texto_label.text = p
		texto_label.visible_characters = 0
		
		for i in range(p.length() +1):
			texto_label.visible_characters = i
			await get_tree().create_timer(0.06).timeout
			
		await get_tree().create_timer(2.0).timeout
	animador.play_backwards("fade_in")
	await animador.animation_finished
	get_tree().change_scene_to_file("res://Maps/Exterior/Exterior.tscn")
	
