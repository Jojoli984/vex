extends AnimatedSprite2D

var lista_animaciones = []
var current = 0
var timer = 0.0
var interval = 0.8

func _ready():
	# Ponemos los nombres tal cual los tienes en el AnimatedSprite2D
	lista_animaciones = [
		"walk_down",
		"walk_down_left",
		"walk_left",
		"walk_up_left",
		"walk_up",
		"walk_up_right",
		"walk_right",
		"walk_left_down"
	]
	play(lista_animaciones[current])

func _process(delta):
	timer += delta
	if timer >= interval:
		timer = 0.0
		current = (current + 1) % lista_animaciones.size()
		play(lista_animaciones[current])
