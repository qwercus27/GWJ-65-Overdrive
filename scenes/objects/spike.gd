extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_hitbox_area_entered(area):

	if area.owner is CharacterBody2D:
		print("spike hitbox collided with " + area.name + " of " + area.get_parent().name)
	
	if(area.name == "Hurtbox"):
		var parent = area.get_parent()
		if parent.has_node("HealthComponent"):
			parent.get_node("HealthComponent").change_health(-1)
		if parent is CharacterBody2D:
			parent.velocity.y = -300
