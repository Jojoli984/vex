extends Control

func _ready():
	$volver.pressed.connect(_on_volver_pressed)
	$reiniciar.pressed.connect(_on_reiniciar_pressed)
	
func _on_volver_pressed():
	get_tree().change_scene_to_file("res://menu_principal.tscn")

func _on_reiniciar_pressed():
	get_tree().paused = false
	GameState.parts_assigned = false
	GameState.car_parts = {"Capó": false, "Tanque": false, "Batería": false}
	GameState.house_with_part = {}
	get_tree().change_scene_to_file("res://main.tscn")
