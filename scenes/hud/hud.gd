extends CanvasLayer

var meter_width = 20
# Called when the node enters the scene tree for the first time.
func _ready():
	
	$BoostMeterFrame/Mid.position.x = $BoostMeterFrame/Left.position.x + 1
	$BoostMeterFrame/Mid.scale.x = 1 + meter_width * 3
	$BoostMeterFrame/Right.position.x = $BoostMeterFrame/Mid.position.x + (1 + meter_width * 3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $BoostMeterLine.scale.x >= meter_width * 9:
		$BoostReadyLabel.visible = true
	else:
		$BoostReadyLabel.visible = false
