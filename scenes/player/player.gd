extends CharacterBody2D

signal goal_cleared
var normal_jump_v = -400.0
var overdrive_jump_v = -500.0
var jump_v = normal_jump_v
var normal_speed = 300.0
var overdrive_speed = 500.0
var speed = normal_speed
var overdrive_meter = 0
var meter_max = 5
var timer_max = 4
var goal

var overdrive = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_v

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if not goal:
		var direction = Input.get_axis("left", "right")
		
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
	else:
		velocity.x = speed

	move_and_slide()
	
	if(overdrive_meter >= meter_max):
		if Input.is_action_just_pressed("a"):
			overdrive = true
			overdrive_meter = float(meter_max - 0.1)
			$OverdriveTimer.start(timer_max)
				
	if overdrive:
		speed = overdrive_speed
		jump_v = overdrive_jump_v
		overdrive_meter = meter_max * ($OverdriveTimer.time_left / 4) - 0.01
		
	else:
		speed = normal_speed
		jump_v = normal_jump_v
	

func change_overdrive(amount):
	overdrive_meter += amount
	


func _on_area_2d_area_entered(area):
	
	if(area.is_in_group("Items")):
		area.queue_free()
		if not overdrive: change_overdrive(1)
		else: 
#			var _time = $OverdriveTimer.time_left + (1/meter_max) * timer_max
			var _time = $OverdriveTimer.time_left + 0.5
			if _time > timer_max: _time = timer_max
			$OverdriveTimer.start(_time)
			
	if(area.is_in_group("Goal")):
		print("GOAL!")
		goal_cleared.emit()
		
	


func _on_overdrive_timer_timeout():
	overdrive = false
	overdrive_meter = 0
	print("timeout")
