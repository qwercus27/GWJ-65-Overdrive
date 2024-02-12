class_name PlayerState
extends State

var player: Player


func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null)
	player.damaged.connect(on_damaged)
	
func on_damaged():
	if state_machine.state.name != "Damaged":

		state_machine.transition_to("Damaged")





