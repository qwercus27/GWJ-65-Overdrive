extends PlayerState

var direction
var bump = false

func enter(msg := {}) -> void:

	bump = false
	direction = msg.get("dir")
	player.velocity.x = player.speed * direction * 5
	player.get_node("Sprite2D/SpriteAnimationPlayer").play("sliding")
	print("entered slide state")

func physics_update(delta: float) -> void:
	
	if bump:
		player.velocity.x = move_toward(player.velocity.x, 0, 20)
	else:
		player.velocity.x = move_toward(player.velocity.x, player.speed * direction, 
			player.speed/6)
	
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	
	if is_equal_approx(player.velocity.x, player.speed * direction) and player.is_on_floor:
		if player.is_on_floor:		
			state_machine.transition_to("Run")
		else:
			state_machine.transition_to("Air")
			
	elif is_equal_approx(player.velocity.x, 0):
		if(bump == false):
			bump_player()
		else:
			if player.is_on_floor:
				state_machine.transition_to("Idle")
			else:
				state_machine.transition_to("Air")
		
		
	if player.goal == true:
		state_machine.transition_to("Goal")

func bump_player():
	bump = true
	player.set_velocity(Vector2(300 * direction * -1, player.jump_v/1.5))

func exit():
	player.get_node("Sprite2D/SpriteAnimationPlayer").play("standing")
