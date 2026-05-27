extends Node3D

@onready var gun_anim = $AnimationPlayer
@export var camera : Camera3D
@export var aim_cast : RayCast3D

var is_reloading = false

@onready var revolver_position = self.position



const CAMERAOFFSET_X = 0
const CAMERAOFFSET_Y = -0.15
const CAMERAOFFSET_Z = -0.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("shoot"):
		if not gun_anim.is_playing() and PlayerData.revolver_ammo > 0:
			gun_anim.play("fire")
			PlayerData.revolver_ammo -= 1
			if aim_cast.is_colliding() and aim_cast.get_collider().get_class() == "CharacterBody3D":
				aim_cast.get_collider().hit("revolver")
	
	if Input.is_action_just_pressed("reload"):
		if not gun_anim.is_playing():
			gun_anim.play("reload")
			is_reloading = true
	
	if Input.is_action_pressed("aim"):
		self.position.x = CAMERAOFFSET_X
		self.position.z = CAMERAOFFSET_Z
		self.position.y = CAMERAOFFSET_Y
	else:
		self.position = revolver_position


func _on_animation_player_animation_finished(_anim_name):
	if is_reloading == true:
		PlayerData.revolver_ammo = 6
		is_reloading = false
