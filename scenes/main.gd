extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.position = $Marker2D.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	$Camera2D.position.x = $Player.position.x
