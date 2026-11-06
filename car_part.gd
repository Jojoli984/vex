extends Area2D

var player_inside = false
var part_name = ""

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Verificar si esta casa tiene una pieza
	part_name = GameState.house_with_part.get(GameState.current_house, "")
	
	# Si no hay pieza en esta casa, ocultarse
	if part_name == "":
		queue_free()

func _on_body_entered(body):
	if body.name == "player":
		player_inside = true
		print("Presiona E para recoger: ", part_name)

func _on_body_exited(body):
	if body.name == "player":
		player_inside = false

func _process(_delta):
	if player_inside and Input.is_action_just_pressed("Interactuar"):
		GameState.car_parts[part_name] = true
		print("Recogiste: ", part_name)
		queue_free()
		
		if GameState.has_all_parts():
			print("¡Tienes todas las piezas!")
