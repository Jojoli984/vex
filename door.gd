extends Area2D

@export var interior_scene: String = "res://interior.tscn"

var player_inside = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "player":
		player_inside = true

func _on_body_exited(body):
	if body.name == "player":
		player_inside = false

func _process(_delta):
	if player_inside and Input.is_action_just_pressed("Interactuar"):
		GameState.spawn_position = get_tree().get_root().get_node("main/player").position
		GameState.current_house = name
		get_tree().change_scene_to_file(interior_scene)
