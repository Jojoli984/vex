extends CharacterBody2D

const SPEED = 100.0
const DAMAGE = 10.0
const DETECTION_RANGE = 200.0
const PATROL_RANGE = 80.0

var player
var damage_cooldown = 0.0
var attack2_cooldown = 0.0
var current_dir = Vector2.ZERO
var patrol_timer = 0.0
var patrol_direction = Vector2.ZERO

@onready var sprite = $AnimatedSprite2D

# NUEVO: Referencias a los nodos de sonido que vas a crear en tu escena
@onready var sonido_ataque = $SonidoAtaque
@onready var sonido_muerte = $SonidoMuerte

# NUEVO: Una banderita para evitar que el sonido de muerte se repita si le disparas mientras cae
var is_dead = false 

func _ready():
	player = get_tree().get_root().get_node("main/player")
	sprite.animation_finished.connect(_on_animation_finished)
	_new_patrol_direction()

func _new_patrol_direction():
	patrol_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	patrol_timer = randf_range(1.5, 3.0)

func _on_animation_finished():
	if sprite.animation == "attack2_left":
		sprite.play("idle_right")
	elif sprite.animation == "attack2_right":
		sprite.play("idle_left")
	elif sprite.animation == "attack2_up":
		sprite.play("idle_down")
	elif sprite.animation == "attack2_down":
		sprite.play("idle_up")

func _process(delta):
	# Si ya se murió o no hay jugador, que no haga nada de esto
	if not player or is_dead:
		return
	
	var dist = position.distance_to(player.position)
	var dir = (player.position - position).normalized()
	current_dir = dir
	
	damage_cooldown -= delta
	attack2_cooldown -= delta

	if dist < DETECTION_RANGE:
		# Modo persecución
		if dist < 25:
			velocity = Vector2.ZERO
			if not sprite.animation.begins_with("attack"):
				if dir.x > 0:
					sprite.play("attack1_right")
				elif dir.x < 0:
					sprite.play("attack1_left")
				elif dir.y > 0:
					sprite.play("attack1_down")
				else:
					sprite.play("attack1_up")
			if dist < 40 and damage_cooldown <= 0:
				# NUEVO: Suena cuando te da el golpe normal
				sonido_ataque.play()
				player.take_damage(DAMAGE)
				damage_cooldown = 1.0
		elif dist < 40 and attack2_cooldown <= 0 and randf() < 0.01:
			velocity = Vector2.ZERO
			attack2_cooldown = 3.0
			
			# NUEVO: Suena cuando empieza a hacer el ataque fuerte
			sonido_ataque.play() 
			
			if not sprite.animation.begins_with("attack2"):
				if dir.x > 0:
					sprite.play("attack2_right")
				elif dir.x < 0:
					sprite.play("attack2_left")
				elif dir.y > 0:
					sprite.play("attack2_down")
				else:
					sprite.play("attack2_up")
			await sprite.animation_finished
			var new_dist = position.distance_to(player.position)
			if new_dist < 50:
				player.take_damage(DAMAGE * 1.5)
		else:
			velocity = dir * SPEED
			if abs(dir.x) > abs(dir.y):
				if dir.x > 0:
					sprite.play("walk_right")
				else:
					sprite.play("walk_left")
			else:
				if dir.y > 0:
					sprite.play("walk_down")
				else:
					sprite.play("walk_up")
	else:
		# Modo patrulla
		patrol_timer -= delta
		if patrol_timer <= 0:
			_new_patrol_direction()
		
		velocity = patrol_direction * (SPEED * 0.5)
		
		if abs(patrol_direction.x) > abs(patrol_direction.y):
			if patrol_direction.x > 0:
				sprite.play("walk_right")
			else:
				sprite.play("walk_left")
		else:
			if patrol_direction.y > 0:
				sprite.play("walk_down")
			else:
				sprite.play("walk_up")

	move_and_slide()

func die():
	# Revisamos si ya estaba muerto para no repetir el sonido y la animación
	if is_dead:
		return
	is_dead = true
	
	# NUEVO: Reproducimos el sonido justo al empezar a morir
	sonido_muerte.play()
	
	if player and position.x < player.position.x:
		sprite.play("death_left")
	else:
		sprite.play("death_right")
		
	await sprite.animation_finished
	
	# OJO: Si el audio de muerte dura MÁS que la animación, se va a cortar 
	# porque aquí el enemigo desaparece. Si te pasa eso, me dices y lo arreglamos fácil.
	queue_free()
