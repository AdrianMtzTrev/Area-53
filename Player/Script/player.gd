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
@export var texto_tutorial = Label
@export var texto_dialogo1 = Label
var altura_camara_original: float = 0.0

#variables de tambaleo
const BOB_FRECUENCIA = 3.8
const BOB_AMPLITUD = 0.03
var t_bob = 0.0

func _ready():
	#Ocultar cursor del raton y bloquea al cetro de la pantalla
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	pantalla_negra.modulate.a = 0.0
	
	altura_camara_original = camera.position.y
	
	#Linterna apagada al iniciar
	linterna.visible = false
	linterna.set_as_top_level(true)
	
	if texto_dialogo1: texto_dialogo1.modulate.a = 0.0
	
func _input(event):
	#Detecta movimiento del mouse solo si esta oculto
	if	event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		#Rotar cuerpo entero Eje Y
		rotate_y(-event.relative.x * mouse_sensibilidad)
		
		#Rotar solo camara de arriba a abajo Eje X
		camera.rotate_x(-event.relative.y * mouse_sensibilidad)
		
		#Limitacion giro de camara360
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
		
	#Prsionar Esc para liberar mouse
	if	event.is_action_pressed("ui_cancel"):
		if not get_tree().paused:
			var menu_pausa = preload("res://UI/menu_pausa.tscn").instantiate()
			get_tree().root.add_child(menu_pausa)
			get_tree().paused = true
			Input.mouse_mode =Input.MOUSE_MODE_VISIBLE
		
	#Interaccion E
	if event.is_action_pressed("Interactuar"):
		if raycast.is_colliding(): 
			var objeto_mirado = raycast.get_collider()
			
			#Comprobamos si el objeto tiene la funcion llamada "Iniciar_Puzzle"
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
		
	#Obtener teclas de movimiento si no estamos en un menu
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
