extends CharacterBody2D

@onready var hud = $"../CanvasLayer"
@onready var sprite = $AnimatedSprite2D
@onready var sonido_disparo = $SonidoDisparo
@onready var sonido_caminar = $SonidoCaminar
@onready var timer_pasos = $TimerPasos

# ¡Aquí agregamos la referencia al nuevo nodo de daño!
@onready var sonido_golpe = $SonidoGolpe 

var sonidos_pasos = [
	preload("res://assets/audio/audio/step_0.mp3"), 
	preload("res://assets/audio/audio/step_1.mp3")
]

var paso_actual = 0 

var bullet_scene = preload("res://bullet.tscn")
var speed = 300.0

func _ready():
	var stats = GameState.character_stats["Vex"]
	GameState.health = stats["hp"]
	GameState.max_health = stats["hp"]
	speed = stats["speed"]
	
	var cam = Camera2D.new()
	cam.name = "Camera2D"
	add_child(cam)
	cam.make_current()
	
	if GameState.coming_from_interior and GameState.spawn_position != Vector2.ZERO:
		position = GameState.spawn_position
		GameState.spawn_position = Vector2.ZERO
		GameState.coming_from_interior = false
		
	await get_tree().process_frame
	if hud:
		hud.update_health(GameState.health)
		
	timer_pasos.timeout.connect(dar_paso)

func _physics_process(_delta):
	var dir = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		dir.x += 1
	if Input.is_action_pressed("ui_left"):
		dir.x -= 1
	if Input.is_action_pressed("ui_down"):
		dir.y += 1
	if Input.is_action_pressed("ui_up"):
		dir.y -= 1
	
	velocity = dir.normalized() * speed
	move_and_slide()
	
	if dir == Vector2.ZERO:
		sprite.stop() 
		timer_pasos.stop() 
	else:
		if timer_pasos.is_stopped():
			dar_paso()
			timer_pasos.start()
			
		if dir.x > 0 and dir.y == 0:
			sprite.play("walk_right")
		elif dir.x < 0 and dir.y == 0:
			sprite.play("walk_left")
		elif dir.y < 0 and dir.x == 0:
			sprite.play("walk_up")
		elif dir.y > 0 and dir.x == 0:
			sprite.play("walk_down")
		elif dir.x > 0 and dir.y < 0:
			sprite.play("walk_up_right")
		elif dir.x < 0 and dir.y < 0:
			sprite.play("walk_up_left")
		elif dir.x > 0 and dir.y > 0:
			sprite.play("walk_down_right")
		elif dir.x < 0 and dir.y > 0:
			sprite.play("walk_down_left")
	
	if Input.is_action_just_pressed("disparar"):
		shoot()

func dar_paso():
	sonido_caminar.stream = sonidos_pasos[paso_actual]
	sonido_caminar.play()
	paso_actual = (paso_actual + 1) % 2

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.position = position
	var mouse_pos = get_global_mouse_position()
	bullet.direction = (mouse_pos - position).normalized()
	get_parent().add_child(bullet)
	
	sonido_disparo.play() 

func take_damage(amount):
	# ¡Y aquí le damos play justo cuando recibe el daño!
	sonido_golpe.play()
	
	GameState.health -= amount
	GameState.health = clamp(GameState.health, 0, GameState.max_health)
	if hud:
		hud.update_health(GameState.health)
	if GameState.health <= 0:
		die()

func die():
	get_tree().paused = false
	GameState.parts_assigned = false
	GameState.car_parts = {"Capó": false, "Tanque": false, "Batería": false}
	GameState.house_with_part = {}
	get_tree().change_scene_to_file("res://derrota.tscn")
