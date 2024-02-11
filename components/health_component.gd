extends Node
class_name HealthComponent

signal health_changed
signal health_depleted

@export var max_health : int

var health

# Called when the node enters the scene tree for the first time.
func _ready():
	
	health = max_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func change_health(amount : int):
	
	health += amount
	
	if health > max_health:
		health = max_health
		
	health_changed.emit()
	
	if health <= 0:
		health_depleted.emit()
		
	print(get_parent().name + " was hit")

