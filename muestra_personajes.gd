extends Control

func _ready():
	$BtnVex.pressed.connect(_on_vex_pressed)
	$BtnAngle.pressed.connect(_on_angle_pressed)
	$BtnDoctor.pressed.connect(_on_doctor_pressed)
	$volver.pressed.connect(_on_volver_pressed)

func _on_vex_pressed():
	GameState.selected_character = "Vex"
	get_tree().change_scene_to_file("res://main.tscn")

func _on_angle_pressed():
	GameState.selected_character = "Angle"
	get_tree().change_scene_to_file("res://main.tscn")

func _on_doctor_pressed():
	GameState.selected_character = "DrCero"
	get_tree().change_scene_to_file("res://main.tscn")

func _on_volver_pressed():
	get_tree().change_scene_to_file("res://menu_principal.tscn")
