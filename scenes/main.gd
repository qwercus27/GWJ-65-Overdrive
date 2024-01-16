extends Node

var level

# Called when the node enters the scene tree for the first time.
func _ready():
	
	level = Global.current_level.instantiate()
	add_child(level)
	$Player.position = level.get_node("StartPosition").position
	$DangerZone.position = level.get_node("DangerPosition").position
	$DangerZone.z_index = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	$Camera2D.position.x = $Player.position.x
	
	if(Input.is_action_just_pressed("1")):
		change_level("1")
	if(Input.is_action_just_pressed("2")):
		change_level("2")

func change_level(level_id):
	level.queue_free()
	Global.current_level = load("res://scenes/levels/level_" + level_id + ".tscn")
	#level = Global.current_level.instantiate()
	#add_child(level)
	_ready()
