extends Node

var level
var goal_cleared
var danger
var danger_camera
const ITEM = preload("res://scenes/items/item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	level = Global.current_level.instantiate()
	add_child(level)
	$Player.position = level.get_node("StartPosition").position
	$DangerLine.position = level.get_node("DangerPosition").position
	
	$Player.z_index = 1
	$DangerLine.z_index = 2
	if(get_level_id(level) == 1): 
		danger_camera = true
		$DangerCameraTimer.start()
		$HUD.visible = false
	else: danger_camera = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	if danger_camera:
		$Camera2D.position.x = $DangerLine.position.x
	elif get_level_id(level) == 1:
		if $Camera2D.position.x != $Player.position.x:
			$Camera2D.position.x = move_toward($Camera2D.position.x, $Player.position.x, 50)
		#if not goal_cleared:
		#	$Camera2D.position.x = $Player.position.x
		else:
			$HUD.visible = true
	else:
		$Camera2D.position.x = $Player.position.x
		
	
	
	if(Input.is_action_just_pressed("1")):
		change_level("1")
	if(Input.is_action_just_pressed("2")):
		change_level("2")
	
	var _meter_width =  $HUD.od_meter_width
	var _current_width = (float($Player.overdrive_meter) / float($Player.meter_max)) * _meter_width * 9
	$HUD.get_node("Boost/BoostMeterLine").scale.x = _current_width
	
	var _hp_width =  $HUD.od_meter_width
	var _current_hp_width = (float($Player.hp) / float($Player.max_hp)) * _hp_width * 9
	$HUD.get_node("HP/HPLine").scale.x = _current_hp_width
	
	if $DangerLine.position.x > $Player.position.x:
		if not danger:
			$DangerTimer.start()
			danger = true
	else:
		danger = false
		$DangerTimer.stop()
	
	_update_danger_distance()
	
		

func change_level(level_id):
	level.queue_free()
	Global.current_level = load("res://scenes/levels/level_" + str(level_id) + ".tscn")
	#level = Global.current_level.instantiate()
	#add_child(level)
	_ready()

func get_level_id(level):
	var _path = str(level.get_path())
	var _split = _path.split("/")[3].split(".")[0].split("_")[1]
	print("get level return: " + str(_split))
	return int(_split)
	
#func instantiate_tiles():
#	var tilemap = level.get_node("TileMap")
#	for cellpos in tilemap.get_used_cells(0):
#		var cell = tilemap.get_cell_source_id(0, cellpos)
#		if cell == 1:
#			var object = ITEM.instantiate()
#			object.position = tilemap.map_to_local(cellpos) * tilemap.scale
#			add_child(object)
#			tilemap.erase_cell(0, cellpos)
			
func _update_danger_distance():
	
	var _dist_label = $HUD.get_node("DangerDistance")
	var _dist_pos = $HUD.get_node("DistancePosition")
	var _danger_pos = $DangerLine.position.x

	var _view_width = Global.default_viewport_width
	#var _left_edge = $Player.position.x - _view_width/2
	var _danger_dist = ($Player.position.x - _danger_pos) / (3*16)
		
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
		$HUD/ClearedLabel.visible = true
		


func _on_next_level_timer_timeout():
	
	var next_level = int(str(level.get_path()).split("_")[1]) + 1
	change_level(next_level)
	goal_cleared = false
	$Player.goal = false
	$HUD/ClearedLabel.visible = false


func _on_danger_timer_timeout():
	$Player.hp -= 1
	$HUD.flash_red()


func _on_danger_camera_timer_timeout():
	danger_camera = false
