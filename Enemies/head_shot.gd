extends Area3D


@export var parent: CharacterBody3D


func is_headshot():
	pass

func crit_hit():
	parent.health = 0
