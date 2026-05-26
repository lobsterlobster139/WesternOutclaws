extends Node3D

@onready var gun_anim = $AnimationPlayer
@export var aim_cast : RayCast3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		if not gun_anim.is_playing():
			$AnimationPlayer.play("fire")
