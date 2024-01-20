extends Node

var level
var goal_cleared
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
	
	if not goal_cleared:
		$Camera2D.position.x = $Player.position.x
	
	
	if(Input.is_action_just_pressed("1")):
		change_level("1")
	if(Input.is_action_just_pressed("2")):
		change_level("2")
	
	var _meter_width =  $HUD.meter_width
	var _current_width = (float($Player.overdrive_meter) / float($Player.meter_max)) * _meter_width * 9
	$HUD.get_node("BoostMeterLine").scale.x = _current_width
		
	_update_danger_distance()
	
		

func change_level(level_id):
	level.queue_free()
	Global.current_level = load("res://scenes/levels/level_" + str(level_id) + ".tscn")
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
			
func _update_danger_distance():
	
	var _dist_label = $HUD.get_node("DangerDistance")
	var _dist_pos = $HUD.get_node("DistancePosition")
	var _danger_pos = $DangerZone.position.x
	var _danger_dist = ($Player.position.x - _danger_pos) / (3*16)
	var _view_width = get_viewport().size.x
	
	if(_danger_dist > 0): 
		_dist_label.text = "< " + str(snapped(_danger_dist, 0.1))
	else:
		_dist_label.text = str(snapped(_danger_dist * -1, 0.1)) + " >"
	
	if _danger_dist < 10 and _danger_dist > 0:
		_dist_label.position.x = _danger_pos - $Camera2D.position.x + _view_width/2 + 8*3
	elif _danger_dist < 0 and _danger_dist > -10:
		_dist_label.position.x = _danger_pos - $Camera2D.position.x + _view_width/2 - 16*3
		
	elif _danger_dist <= -10:
		_dist_label.position.x = _dist_pos.position.x + _view_width - 32*3
	else:
		_dist_label.position.x = _dist_pos.position.x 
	


func _on_player_goal_cleared():
	if not goal_cleared:
		$Player.goal = true
		goal_cleared = true
		$NextLevelTimer.start()
		


func _on_next_level_timer_timeout():
	
	var next_level = int(str(level.get_path()).split("_")[1]) + 1
	change_level(next_level)
	goal_cleared = false
	$Player.goal = false
