extends Control

func _ready():
	$botoncambiar.pressed.connect(_on_flecha_pressed)
	$volver.pressed.connect(_on_volver_pressed)
	
func _on_flecha_pressed():
	get_tree().change_scene_to_file("res://galeria_personajes.tscn")

func _on_volver_pressed():
	get_tree().change_scene_to_file("res://menu_principal.tscn")
