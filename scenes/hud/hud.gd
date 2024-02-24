extends CanvasLayer

var od_meter_width = 20
var hp_meter_width = 20

var meter_scene = load("res://scenes/hud/meter.tscn")

var overdrive_max: int = 5
var health_max : int = 5

var hp_cells = []
var od_cells = []

func _ready():
	
	meter_setup(hp_cells)
	meter_setup(od_cells)


func _process(_delta):
	$HitScreen.color.a8 = 100 * $FlashTimer.time_left

func flash_red():
	$FlashTimer.start(1)


func update_health_meter(health : int):
	
	var difference = health_max - health
	
	for hp in health_max:
		if((hp + 1) <= health):
			hp_cells[hp].get_node("Sprite2D").set_modulate(Color(1,0,0))
		else:
			hp_cells[hp].get_node("Sprite2D").set_modulate(Color(0.5,0.5,0.5))

func update_od_meter(overdrive_current : int):
	
	var difference = overdrive_max - overdrive_current
	
	for od in overdrive_max:
		if((od + 1) <= overdrive_current):
			od_cells[od].get_node("Sprite2D").set_modulate(Color(1,1,1))
		else:
			od_cells[od].get_node("Sprite2D").set_modulate(Color(0.5,0.5,0.5))

func meter_setup(array : Array):
	
	var max : int
	var mid : int
	var pos : Vector2
	var last_pos : Vector2
	var first : Node2D
	
	if array == hp_cells:
		max = health_max
		first = $HP/HP_1
		pos = first.global_position
	else:
		max = overdrive_max
		first = $OD/OD_1
		pos = first.global_position
	
	mid = max - 2	
	last_pos = pos + Vector2((max-1) * 48, 0)
	
	array.append(first)
	
	for i in mid:
		array.append(meter_scene.instantiate())
		array[i + 1] = meter_scene.instantiate()
		array[i + 1].position = pos + Vector2(48*(i+1), 0)
		array[i + 1].get_node("Sprite2D").set_region_rect(Rect2(23, 0, 22, 8))
		add_child(array[i + 1])

	array.append(meter_scene.instantiate())
	array[max-1].position = last_pos
	array[max-1].get_node("Sprite2D").set_region_rect(Rect2(46,0,22,8))
	add_child(array[max-1])
