extends Node2D

var enemy_scene = preload("res://enemy.tscn")
var vex_scene = preload("res://Vex.tscn")
var angle_scene = preload("res://Angle.tscn")
var drcero_scene = preload("res://DrCero.tscn")
var pausa_scene = preload("res://menupausa.tscn")
var pausa_instance = null

var spawn_timer = 0.0
var spawn_interval = 3.0
var wave_timer = 0.0
var wave_interval = 30.0
var wave_number = 1

const SPAWN_MIN_DIST = 400.0
const SPAWN_MAX_DIST = 600.0

func _ready():
	var nuevo_personaje = null
	
	match GameState.selected_character:
		"Vex":
			nuevo_personaje = vex_scene.instantiate()
		"Angle":
			nuevo_personaje = angle_scene.instantiate()
		"DrCero":
			nuevo_personaje = drcero_scene.instantiate()
			
	if nuevo_personaje != null:
		nuevo_personaje.name = "player"
		nuevo_personaje.position = GameState.spawn_position
		add_child(nuevo_personaje)

	if not GameState.parts_assigned:
		var houses = [
			"Casa Gris", "Casa Gris 2", "Casa Gris", "Casa Gris 4",
			"Edificio Rojo", "Edificio Rojo 2", "Edificio Rojo 3", "Edificio Rojo 4", "Edificio Rojo 5",
			"Edificio Rojo 6", "Edificio Rojo 7",
			"Edificio Rojo 8", "Edificio Rojo 9", "Edificio Rojo 10", "Edificio Rojo 11",
			"Casa Amarilla", "Casa Amarilla 2", "Casa Amarilla 3",
			"Casa Gris Lisa", "Casa Almacen", "Market", "Tienda 24",
			"Laboratorio", "Laboratorio"
		]
		GameState.assign_parts_randomly(houses)
		GameState.parts_assigned = true
		print("Piezas asignadas: ", GameState.house_with_part)
		
	var texto_mision = "OBJETIVOS:\n"
	for puerta in GameState.house_with_part:
		var nombre_pieza = GameState.house_with_part[puerta]
		texto_mision += "- " + nombre_pieza + " (En " + puerta + ")\n"
		
	var label = get_node_or_null("CanvasLayer2/LabelPiezas")
	if label:
		label.text = texto_mision

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			_reanudar()
		else:
			_pausar()
	
	if not get_tree().paused:
		spawn_timer += delta
		if spawn_timer >= spawn_interval:
			spawn_timer = 0.0
			spawn_enemy()
		
		wave_timer += delta
		if wave_timer >= wave_interval:
			wave_timer = 0.0
			spawn_wave()

func _pausar():
	get_tree().paused = true
	pausa_instance = pausa_scene.instantiate()
	pausa_instance.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(pausa_instance)

func _reanudar():
	get_tree().paused = false
	if pausa_instance:
		pausa_instance.queue_free()
		pausa_instance = null

func spawn_enemy():
	var player = get_node_or_null("player")
	if not player:
		return
	var angle = randf() * TAU
	var dist = randf_range(SPAWN_MIN_DIST, SPAWN_MAX_DIST)
	var spawn_pos = player.position + Vector2(cos(angle), sin(angle)) * dist
	var enemy = enemy_scene.instantiate()
	enemy.position = spawn_pos
	add_child(enemy)

func spawn_wave():
	var player = get_node_or_null("player")
	if not player:
		return
	var count = 3 + wave_number * 2
	for i in range(count):
		var angle = randf() * TAU
		var dist = randf_range(SPAWN_MIN_DIST, SPAWN_MAX_DIST)
		var spawn_pos = player.position + Vector2(cos(angle), sin(angle)) * dist
		var enemy = enemy_scene.instantiate()
		enemy.position = spawn_pos
		add_child(enemy)
	wave_number += 1
	print("¡Oleada ", wave_number, "! Enemigos: ", count)
