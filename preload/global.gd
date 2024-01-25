extends Node

var current_level
var default_viewport_width = 960

func _ready():
	current_level = load("res://scenes/levels/level_1.tscn")
	
