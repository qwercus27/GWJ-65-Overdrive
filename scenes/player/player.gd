class_name Player
extends CharacterBody2D

signal goal_cleared
signal health_changed
signal od_meter_changed
signal bounce_activated()

var normal_jump_v = -400.0
var overdrive_jump_v = -500.0
var jump_v = normal_jump_v

var normal_speed = 300.0
var overdrive_speed = 500.0
var speed = normal_speed

var overdrive_meter = 0
var meter_max = 5
var timer_max = 4

var goal = false
var overdrive = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):

	#print("vel_x: " + str(velocity.x))
	
	if(overdrive_meter >= meter_max):
		if Input.is_action_just_pressed("a"):
			overdrive = true
			overdrive_meter = float(meter_max - 0.1)
			$OverdriveTimer.start(timer_max)

	if overdrive:
		speed = overdrive_speed
		jump_v = overdrive_jump_v
		overdrive_meter = meter_max * ($OverdriveTimer.time_left / 4) - 0.01
		od_meter_changed.emit()
		
	else:
		speed = normal_speed
		jump_v = normal_jump_v
		


func change_overdrive(amount):
	overdrive_meter += amount


func _on_area_2d_area_entered(area):
	
	if(area.is_in_group("Items")):
		area.queue_free()
		if not overdrive: 
			change_overdrive(1)
			od_meter_changed.emit()
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


func _on_health_component_health_changed():
	health_changed.emit()


func _on_hitbox_area_entered(area):
	print("player hitbox collided with " + area.name + " of " + area.get_parent().name)
	if(area.name == "Hurtbox"):
		if area.get_parent().has_node("HealthComponent"):
			area.get_parent().get_node("HealthComponent").change_health(-1)
		bounce_activated.emit()
		velocity.y = jump_v

# player is damaged
# vel.x away from damage, vel.y up (usually?)
# timer starts
# sprite blinks until timer ends
# player cannot be damaged until timer ends

func _on_health_component_damaged():

	$RecoveryTimer.start()
	$BlinkTimer.start()
	$HealthComponent.recovery = true


func _on_recovery_timer_timeout():
	$HealthComponent.recovery = false
	$Sprite2D.visible = true
	$BlinkTimer.stop()


func _on_blink_timer_timeout():
	$Sprite2D.visible = not $Sprite2D.visible
	
func set_animation(anim_name : String):
	%SpriteAnimationPlayer.play(anim_name)

func get_animation():
	return %SpriteAnimationPlayer.current_animation
	
