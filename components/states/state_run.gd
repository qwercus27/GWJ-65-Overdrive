extends PlayerState

func enter(_msg := {}) -> void:
	print("entered run state")
	pass


func physics_update(delta: float) -> void:
	
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return
	
	var direction = Input.get_axis("left", "right")

	if direction:
		player.velocity.x = direction * player.speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.speed)
	
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	if Input.is_action_just_pressed("space"):
		state_machine.transition_to("Air", {do_jump = true})
	elif Input.is_action_just_pressed("Down"):
		state_machine.transition_to("Slide", {dir = direction})
	elif is_equal_approx(direction, 0.0):
		state_machine.transition_to("Idle")
		
	if player.goal == true:
		state_machine.transition_to("Goal")

		

