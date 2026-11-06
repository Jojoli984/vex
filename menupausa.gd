extends CanvasLayer

func _ready():
	$Continuar.pressed.connect(_on_continuar_pressed)
	$Reiniciar.pressed.connect(_on_reiniciar_pressed)
	$Opciones.pressed.connect(_on_op_pressed)
	$Volver.pressed.connect(_on_menu_pressed)

func _on_continuar_pressed():
	get_tree().paused = false
	queue_free()

func _on_reiniciar_pressed():
	get_tree().paused = false
	GameState.parts_assigned = false
	GameState.car_parts = {"Capó": false, "Tanque": false, "Batería": false}
	GameState.house_with_part = {}
	get_tree().change_scene_to_file("res://main.tscn")

func _on_op_pressed():
	GameState.escena_anterior = "res://menupausa.tscn"
	get_tree().change_scene_to_file("res://configuracion.tscn")

func _on_menu_pressed():
	get_tree().paused = false
	GameState.parts_assigned = false
	GameState.car_parts = {"Capó": false, "Tanque": false, "Batería": false}
	GameState.house_with_part = {}
	get_tree().change_scene_to_file("res://menu_principal.tscn")
