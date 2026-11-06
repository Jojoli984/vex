extends Node

var health = 100.0
var max_health = 100.0
var spawn_position = Vector2.ZERO
var coming_from_interior = false
var parts_assigned = false
var selected_character = "Vex"
var current_house = ""

# --- ESTO ES LO NUEVO QUE TE FALTABA ---
var vol_musica = 1.0
var vol_disparos = 1.0
var vol_efectos = 1.0
var escena_anterior = ""
# ---------------------------------------

# Stats por personaje
var character_stats = {
	"Vex": {"hp": 80, "speed": 300, "weapon": "pistola"},
	"Angle": {"hp": 140, "speed": 200, "weapon": "melee"},
	"DrCero": {"hp": 100, "speed": 250, "weapon": "laser"}
}

var car_parts = {
	"Capó": false,
	"Tanque": false,
	"Batería": false
}

var house_with_part = {}

func assign_parts_randomly(house_list: Array):
	var parts = ["Capó", "Tanque", "Batería"]
	var houses = house_list.duplicate()
	houses.shuffle()
	for i in range(parts.size()):
		house_with_part[houses[i]] = parts[i]

func has_all_parts():
	return car_parts["Capó"] and car_parts["Tanque"] and car_parts["Batería"]
