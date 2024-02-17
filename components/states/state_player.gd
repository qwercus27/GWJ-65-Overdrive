class_name PlayerState
extends State

var player: Player


func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null)
	player.get_node("HealthComponent").damaged.connect(on_damaged)
	player.bounce_activated.connect(on_bounce_activated)
	
func on_damaged():
	if state_machine.state.name != "Damaged":
		state_machine.transition_to("Damaged")

func on_bounce_activated():
	state_machine.transition_to("Air")





