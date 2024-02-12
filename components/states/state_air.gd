extends PlayerState


func enter(msg := {}) -> void:

	if msg.has("do_jump"):
		player.velocity.y = player.jump_v
	#print("entered air state")

func physics_update(delta: float) -> void:
	
	var direction = Input.get_axis("left", "right")

	if direction:
		player.velocity.x = direction * player.speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.speed)
	
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	
	if player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
			
	if player.goal == true:
		state_machine.transition_to("Goal")

		
