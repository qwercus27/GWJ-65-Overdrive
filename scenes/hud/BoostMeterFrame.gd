extends Node2D

var width = 20
# Called when the node enters the scene tree for the first time.
func _ready():
	
	$Mid.position.x = $Left.position.x + 1
	$Mid.scale.x = 1 + width * 3
	$Right.position.x = $Mid.position.x + (1 + width * 3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
