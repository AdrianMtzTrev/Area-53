extends CanvasLayer

var frecuencia_objetivo = 87.5

@onready var label_actual = $MonitorMarco/MarginContainer/ColorRect/VBoxContainer/LabelActual
@onready var slider = $MonitorMarco/MarginContainer/ColorRect/VBoxContainer/HSlider
@onready var boton = $MonitorMarco/MarginContainer/ColorRect/VBoxContainer/Button
@onready var linea_onda = $"MonitorMarco/MarginContainer/ColorRect/OndaSeñal"

#Variables para controlar la animacion de la onda
var tiempo = 0.0
var puntos_onda = 100

func _ready():
	#Limites del slider
	slider.min_value = 50.0
	slider.max_value = 100.0
	slider.step = 0.1
	slider.value = 50.0
	
	slider.value_changed.connect(_on_slider_changed)
	boton.pressed.connect(_on_boton_presionado)
	
func _process(delta):
	tiempo += delta * 10.0
	dibujar_onda_dinamica()
	
func dibujar_onda_dinamica():
	linea_onda.clear_points()
	
	#Se calcula que tan lejos esa la frecuenica correcta
	var distancia_al_objetivo = abs(slider.value - frecuencia_objetivo)
	
	#Si esta lejos, la onda es mas caotica
	var amplitud = clamp(distancia_al_objetivo * 5.0, 10, 50)
	var frecuencua_onda = lerp(0.05, 0.3, 1.0 - (distancia_al_objetivo / 50.0))
	
	#Posicion base
	var centro_y = 250.0
	
	#Dibujamos la onda
	for i in range(puntos_onda):
		var x = (600.0 / puntos_onda) * i
		var y = centro_y + sin((i * frecuencua_onda) + tiempo) * amplitud
		
		linea_onda.add_point(Vector2(x,y))
 	
func _on_slider_changed(valor):
	#Se actualiza el texto cada que movemos el slider
	label_actual.text = "Frecuencia Actual: " + str(snapped(valor, 0.1)) + "Mhz"
	
func _on_boton_presionado():
	#Comprobar si la frecuencia esta cerca del objetivo (margren de 0.5)
	if abs(slider.value - frecuencia_objetivo) <= 0.5:
		print("Satelite Sincronizado")
		
		#Ocultamos Mouse
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
		#Destruimos interfaz
		queue_free()
	else:
		label_actual.text = "ERROR DE SEÑAL..."	
		
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
		queue_free()
