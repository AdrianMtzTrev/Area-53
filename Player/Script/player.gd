extends CharacterBody3D

var dialogo_puerta_listo : bool = true
#Velocidad de caminar y gravedad
const SPEED = 4.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#Sensibilidad del raton
var mouse_sensibilidad = 0.003

#variables de inventario
var slot_activo : int = 1
var tiene_linterna : bool = true
@onready var pantalla_negra = $CanvasLayer/ColorRect

#Referencia a la linterna y la camara
@onready var linterna = $SpotLight3D
@onready var camera = $Camera3D
@onready var raycast = $Camera3D/RayCast3D
@export var texto_tutorial: Label # Corregido a dos puntos (:) para tipado correcto
@export var texto_dialogo1: Label # Corregido a dos puntos (:) para tipado correcto
var altura_camara_original: float = 0.0

#variables de tambaleo
const BOB_FRECUENCIA = 3.8
const BOB_AMPLITUD = 0.03
var t_bob = 0.0

func _ready():
	# SOLUCIÓN WEB: Quitamos la captura automática de aquí porque el navegador la bloquea.
	# Dejamos que el cursor sea visible al inicio para que el usuario pueda interactuar.
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	pantalla_negra.modulate.a = 0.0
	altura_camara_original = camera.position.y
	
	#Linterna apagada al iniciar
	linterna.visible = false
	linterna.set_as_top_level(true)
	
	if texto_dialogo1: texto_dialogo1.modulate.a = 0.0
	
func _input(event):
	# SOLUCIÓN WEB CRUCIAL: Captura el mouse de forma legal cuando el jugador hace clic izquierdo
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	#Detecta movimiento del mouse solo si esta oculto/capturado
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		#Rotar cuerpo entero Eje Y
		rotate_y(-event.relative.x * mouse_sensibilidad)
		
		#Rotar solo camara de arriba a abajo Eje X
		camera.rotate_x(-event.relative.y * mouse_sensibilidad)
		
		#Limitacion giro de camara360
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
		
	#Presionar Esc para liberar mouse y abrir pausa
	if event.is_action_pressed("ui_cancel"):
		if not get_tree().paused:
			# Evitamos crasheos en la web verificando si el menú existe antes de cargarlo
			if ResourceLoader.exists("res://UI/menu_pausa.tscn"):
				var menu_pausa = preload("res://UI/menu_pausa.tscn").instantiate()
				get_tree().root.add_child(menu_pausa)
				get_tree().paused = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	#Interaccion E (Solo funciona si el mouse está capturado para evitar clicks fantasmas)
	if event.is_action_pressed("Interactuar") and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if raycast.is_colliding(): 
			var objeto_mirado = raycast.get_collider()
			
			if objeto_mirado.has_method("iniciar_puzzle"):
				objeto_mirado.iniciar_puzzle()
				
			if objeto_mirado.has_method("abrir_puerta"):
				print("abrir puerta")
				objeto_mirado.abrir_puerta()
				
	#Interaccion F Linterna
	if event.is_action_pressed("LINTERNA"):
		if slot_activo == 1:
			linterna.visible = !linterna.visible
			
			if texto_tutorial and texto_tutorial.visible:
				var tween = create_tween()
				tween.tween_property(texto_tutorial, "modulate:a", 0.0, 0.5)
				tween.tween_callback(texto_tutorial.hide)
				tween.tween_interval(0.5)
				tween.tween_callback(texto_dialogo1.show)
				tween.tween_property(texto_dialogo1, "modulate:a", 1.0, 1.0)
				tween.tween_interval(4.0)
				tween.tween_property(texto_dialogo1, "modulate:a", 0.0, 0.5)
				tween.tween_callback(texto_dialogo1.hide)
	
func _physics_process(delta):
	#Aplicar gravedad si el player no toca el suelo
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	#Tambaleo
	if is_on_floor() and (velocity.x != 0 or velocity.z != 0):
		t_bob += delta * velocity.length()
		camera.position.y = altura_camara_original + sin(t_bob * BOB_FRECUENCIA) * BOB_AMPLITUD
	else:
		camera.position.y = move_toward(camera.position.y, altura_camara_original, delta)
		
	#Obtener teclas de movimiento si el mouse está capturado (Foco en el juego)
	var input_dir = Vector2.ZERO
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		input_dir = Input.get_vector("move_left","move_right","move_forward","move_backward")
	
	#Calcular direccion donde mira el jugador
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	#Moverse o detenerse
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else :
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	move_and_slide()
	
func _process(delta):
	linterna.global_position = camera.global_position
	linterna.global_transform.basis = linterna.global_transform.basis.slerp(camera.global_transform.basis, 9.0 * delta).orthonormalized()

func _on_zona_puerta_body_entered(body: Node3D) -> void:
	if body == self and dialogo_puerta_listo:
		dialogo_puerta_listo = false
		
		if texto_dialogo1:
			var tween = create_tween()
			texto_dialogo1.text = "Debo revisar mi celular... en esa página de Reddit filtraron las claves de acceso."
			tween.tween_callback(texto_dialogo1.show)
			tween.tween_property(texto_dialogo1, "modulate:a", 1.0, 1.0)
			tween.tween_interval(4.0)
			tween.tween_property(texto_dialogo1, "modulate:a", 0.0, 0.5)
			tween.tween_callback(texto_dialogo1.hide)

func _on_puerta_bunker_body_entered(body: Node3D) -> void:
	if body == self:
		var tween = create_tween()
		tween.tween_property(pantalla_negra, "modulate:a", 1.0, 1.5)
		tween.tween_callback(cambiar_escena_bunker)

func cambiar_escena_bunker():
	get_tree().change_scene_to_file("res://Maps/Interior/Interior.tscn")
