extends PlayerState

func enter(msg := {}) -> void:

	player.velocity.x = player.overdrive_speed

func physics_update(delta: float) -> void:
		
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
