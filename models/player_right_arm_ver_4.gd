extends Node3D

@onready var animation_player = $AnimationPlayer
@export var parent : Node3D

func _on_animation_player_animation_finished(anim_name):
	if parent.is_reloading == true:
		PlayerData.revolver_ammo = 6
		parent.is_reloading = false
		parent.gun_anim.speed_scale = parent.gun_anim_speed_modifier
