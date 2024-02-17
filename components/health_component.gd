extends Node
class_name HealthComponent

signal health_changed
signal health_depleted
signal damaged(x_vel : int)

@export var max_health : int

var health
var recovery = false


func _ready():
	
	health = max_health


func change_health(amount : int):
	
	if recovery:
		print(get_parent().name + " was hit, but was in recovery.")
		return
	
	health += amount
	
	if health > max_health:
		health = max_health
		
	health_changed.emit()
	
	if health <= 0:
		health_depleted.emit()
	elif amount < 0:
		damaged.emit()
		
	print(get_parent().name + " was hit")

