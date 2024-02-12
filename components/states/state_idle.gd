extends PlayerState


func enter(_msg := {}) -> void:

	player.velocity = Vector2.ZERO
	#print("entered idle state")
	
	
func update(delta: float) -> void:
	
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return
	
	if Input.is_action_just_pressed("space"):
		state_machine.transition_to("Air", {do_jump = true})
	elif Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		state_machine.transition_to("Run")
		
	if player.goal == true:
		state_machine.transition_to("Goal")

		

