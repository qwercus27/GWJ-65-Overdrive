extends CharacterBody2D


const SPEED = 100
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = -1
var seen = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	#var direction = Input.get_axis("ui_left", "ui_right")

	if seen:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()
		
		if direction == -1 and velocity.x == 0:
			direction = 1
		elif direction == 1 and velocity.x == 0:
			direction = -1	
	
	#$Wander.wander(delta, velocity, is_on_floor())
	
	

func _on_health_component_health_changed():
	print("mob health: " + str($HealthComponent.health))


func _on_health_component_health_depleted():
	queue_free()
	

func _on_hitbox_area_entered(area):

	#print("mob hitbox collided with " + area.name + " of " + area.get_parent().name)
	
	var x_vel = 200.0
	var y_vel = -300.0
	
	if area.global_position.x < global_position.x:
		x_vel = x_vel * -1
	
	if(area.name == "Hurtbox"):
		var parent = area.get_parent()
		if parent.has_node("HealthComponent"):
			parent.get_node("HealthComponent").change_health(-1)
			parent.set_velocity(Vector2(x_vel, y_vel))

func _on_visible_on_screen_notifier_2d_screen_entered():
	seen = true
