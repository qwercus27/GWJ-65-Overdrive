extends Node

var level
const ITEM = preload("res://scenes/items/item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	level = Global.current_level.instantiate()
	add_child(level)
	$Player.position = level.get_node("StartPosition").position
	$DangerZone.position = level.get_node("DangerPosition").position
	$DangerZone.z_index = 1
	
	instantiate_tiles()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	$Camera2D.position.x = $Player.position.x
	
	if(Input.is_action_just_pressed("1")):
		change_level("1")
	if(Input.is_action_just_pressed("2")):
		change_level("2")
	
	var _meter_width =  $HUD.meter_width
	var _current_width = (float($Player.overdrive_meter) / float($Player.meter_max)) * _meter_width * 9
	$HUD.get_node("BoostMeterLine").scale.x = _current_width
	
	var danger_dist = ($Player.position.x - $DangerZone.position.x) / (3*16)
	$HUD.get_node("DangerDistance").text = "< " + str(snapped(danger_dist, 0.1))

func change_level(level_id):
	level.queue_free()
	Global.current_level = load("res://scenes/levels/level_" + level_id + ".tscn")
	#level = Global.current_level.instantiate()
	#add_child(level)
	_ready()
	
func instantiate_tiles():
	var tilemap = level.get_node("TileMap")
	for cellpos in tilemap.get_used_cells(0):
		var cell = tilemap.get_cell_source_id(0, cellpos)
		if cell == 1:
			var object = ITEM.instantiate()
			object.position = tilemap.map_to_local(cellpos) * tilemap.scale
			add_child(object)
			tilemap.erase_cell(0, cellpos)
