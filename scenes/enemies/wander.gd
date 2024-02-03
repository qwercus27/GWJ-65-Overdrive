extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func wander(delta, velocity, is_on_floor):
	
	if(is_on_floor):
		
		velocity.x -= delta * 10
