extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_hitbox_area_entered(area):

#	if area.owner is CharacterBody2D:
#		print("spike hitbox collided with " + area.name + " of " + area.get_parent().name)
	
	if(area.name == "Hurtbox"):
		var parent = area.get_parent()
		if parent.has_node("HealthComponent"):
			
			if parent is CharacterBody2D:
				var x_vel : float = parent.velocity.x * -1
				var y_vel : float = -400
				
				parent.get_node("HealthComponent").change_health(-1)
				parent.set_velocity(Vector2(x_vel, y_vel))
