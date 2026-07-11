extends CharacterBody3D

#Velocidad de caminar y gravedad
const SPEED = 4.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#Sensibilidad del raton
var mouse_sensibilidad = 0.003

#Referencia a la camara
@onready var camera = $Camera3D
@onready var raycast = $Camera3D/RayCast3D

func _ready():
	#Ocultar cursor del raton y bloquea al cetro de la pantalla
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	#Detecta movimiento del mouse
	if	event is InputEventMouseMotion:
		#Rotar cuerpo entero Eje Y
		rotate_y(-event.relative.x * mouse_sensibilidad)
		
		#Rotar solo camara de arriba a abajo Eje X
		camera.rotate_x(-event.relative.y * mouse_sensibilidad)
		
		#Limitacion giro de camara360
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
		
	#Prsionar Esc para liberar mouse
	if	event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	#Interaccion E
	if event.is_action_pressed("Interactuar"):
		if raycast.is_colliding(): 
			var objeto_mirado = raycast.get_collider()
			
			#Comprobamos si el objeto tiene la funcion llamada "Iniciar_Puzzle"
			if objeto_mirado.has_method("iniciar_puzzle"):
				objeto_mirado.iniciar_puzzle()
	
func _physics_process(delta):
	#Aplicar gravedad si el player no toca el suelo
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	#Obtener teclas de movimiento
	var input_dir = Input.get_vector("move_left","move_right","move_forward","move_backward")
	
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
