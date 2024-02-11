extends CanvasLayer

var od_meter_width = 20
var hp_meter_width = 20
# Called when the node enters the scene tree for the first time.
func _ready():
	
	$Boost/BoostMeterFrame/Mid.position.x = $Boost/BoostMeterFrame/Left.position.x + 1
	$Boost/BoostMeterFrame/Mid.scale.x = od_meter_width * 3
	$Boost/BoostMeterFrame/Right.position.x = $Boost/BoostMeterFrame/Mid.position.x + (od_meter_width * 3)
	
	$HP/HPFrame/Mid.position.x = $HP/HPFrame/Left.position.x + 1
	$HP/HPFrame/Mid.scale.x = hp_meter_width * 3
	$HP/HPFrame/Right.position.x = $HP/HPFrame/Mid.position.x + (hp_meter_width * 3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $Boost/BoostMeterLine.scale.x >= od_meter_width * 9:
		$Boost/BoostReadyLabel.visible = true
	else:
		$Boost/BoostReadyLabel.visible = false
	
	$HitScreen.color.a8 = 100 * $FlashTimer.time_left

func flash_red():
	$FlashTimer.start(1)


func update_health_meter(health : int, max_health : int):
	
	var _new_width = (float(health) / float(max_health)) * hp_meter_width * 9
	$HP/HPLine.scale.x = _new_width

func update_od_meter(od : float, max_od : float):

	var _new_width = od / max_od * od_meter_width * 9
	$Boost/BoostMeterLine.scale.x = _new_width

