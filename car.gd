extends Area2D

var player_inside = false
var escaping = false
var camera_attached = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "player":
		player_inside = true

func _on_body_exited(body):
	if body.name == "player":
		player_inside = false

func _process(delta):
	if player_inside and Input.is_action_just_pressed("Interactuar"):
		if GameState.has_all_parts():
			escaping = true
			var player = get_tree().get_root().get_node("main/player")
			player.visible = false
			player.set_physics_process(false)
		else:
			var missing = []
			for part in GameState.car_parts:
				if not GameState.car_parts[part]:
					missing.append(part)
			print("Faltan: ", missing)
	
	if escaping:
		if not camera_attached:
			var cam = get_tree().get_root().get_node("main/player/Camera2D")
			cam.reparent(self)
			camera_attached = true
		position.x += 300 * delta
		if position.x > 2500:
			show_victory()

func show_victory():
	escaping = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://victoria.tscn")
