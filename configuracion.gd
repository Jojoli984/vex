extends Control

@onready var barra_musica = $musica
@onready var barra_disparos = $disparo
@onready var barra_efectos = $sonidogeneral

# Referencias a tus botones
@onready var boton_volver = $Volver
@onready var boton_cancelar = $cancelar

# Variables para nuestra "copia de seguridad"
var vol_musica_original = 1.0
var vol_disparos_original = 1.0
var vol_efectos_original = 1.0

func _ready():
	# 1. Hacemos la copia de seguridad ANTES de mover nada
	vol_musica_original = GameState.vol_musica
	vol_disparos_original = GameState.vol_disparos
	vol_efectos_original = GameState.vol_efectos
	
	# Acomodamos las barras
	barra_musica.value = GameState.vol_musica
	barra_disparos.value = GameState.vol_disparos
	barra_efectos.value = GameState.vol_efectos
	
	# Conectamos las barras
	barra_musica.value_changed.connect(_en_musica_cambiada)
	barra_disparos.value_changed.connect(_en_disparos_cambiados)
	barra_efectos.value_changed.connect(_en_efectos_cambiados)
	
	# Conectamos los botones
	boton_volver.pressed.connect(_on_volver_pressed)
	boton_cancelar.pressed.connect(_on_cancelar_pressed)

func _en_musica_cambiada(valor):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Musica"), linear_to_db(valor))
	GameState.vol_musica = valor 

func _en_disparos_cambiados(valor):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Disparos"), linear_to_db(valor))
	GameState.vol_disparos = valor 

func _en_efectos_cambiados(valor):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Efectos"), linear_to_db(valor))
	GameState.vol_efectos = valor 

# --- LÓGICA DE LOS BOTONES ---

func _on_volver_pressed():
	# Como las barras ya guardaron todo en GameState, solo cerramos
	print("¡Le diste al botón de volver!")
	cerrar_ventana()

func _on_cancelar_pressed():
	# 1. Regresamos las variables del Autoload a su estado original
	GameState.vol_musica = vol_musica_original
	GameState.vol_disparos = vol_disparos_original
	GameState.vol_efectos = vol_efectos_original
	print("¡Le diste a cancelar!")
	# 2. Obligamos a los canales de audio a regresar al volumen viejo
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Musica"), linear_to_db(vol_musica_original))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Disparos"), linear_to_db(vol_disparos_original))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Efectos"), linear_to_db(vol_efectos_original))
	
	# 3. Cerramos
	cerrar_ventana()

func cerrar_ventana():
	get_tree().change_scene_to_file(GameState.escena_anterior)
