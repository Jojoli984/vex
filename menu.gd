extends Control

func _ready():
	$BotonJugar.pressed.connect(_on_jugar_pressed)
	$BotonPer.pressed.connect(_on_personajes_pressed)
	$BotonOp.pressed.connect(_on_configuracion_pressed)
	$BotonSalir.pressed.connect(_on_salir_pressed)
	
func _on_jugar_pressed():
	get_tree().change_scene_to_file("res://muestra_personajes.tscn")

func _on_personajes_pressed():
	get_tree().change_scene_to_file("res://galeria_personajes.tscn")

func _on_configuracion_pressed():
	GameState.escena_anterior = "res://menu_principal.tscn"
	get_tree().change_scene_to_file("res://configuracion.tscn")


func _on_salir_pressed():
	get_tree().quit()
