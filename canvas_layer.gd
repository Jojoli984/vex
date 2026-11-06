extends CanvasLayer

var health_bar

func _ready():
	health_bar = $ProgressBar

func _process(_delta):
	if health_bar:
		health_bar.value = GameState.health

func update_health(value):
	if health_bar:
		health_bar.value = value
