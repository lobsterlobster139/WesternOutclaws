extends Node3D

#yuh
@onready var gun_anim = $PlayerRightArmVer4.animation_player
@export var camera : Camera3D
@export var aim_cast : RayCast3D
@export var player : CharacterBody3D
@export var aim_marker : Marker3D

var is_reloading = false
var hammer_down = false

@onready var revolver_position = position



const CAMERAOFFSET_X = -0.09
const CAMERAOFFSET_Y = -0.27
const CAMERAOFFSET_Z = -0.16

const gun_anim_speed_modifier = 1.5

func _ready():
	gun_anim.speed_scale = gun_anim_speed_modifier

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("shoot"):
		if not gun_anim.is_playing() and PlayerData.revolver_ammo > 0 and hammer_down == true:
			gun_anim.play("Shoot")
			PlayerData.revolver_ammo -= 1
			hammer_down = false
			if aim_cast.is_colliding() and aim_cast.get_collider().get_class() == "CharacterBody3D":
				aim_cast.get_collider().hit("revolver")
			elif aim_cast.is_colliding() and aim_cast.get_collider().has_method("is_headshot"):
				aim_cast.get_collider().crit_hit()
	
	if Input.is_action_just_pressed("reload"):
		if not gun_anim.is_playing():
			gun_anim.speed_scale = 1
			gun_anim.play("Reload")
			is_reloading = true
			hammer_down = false
	
	if Input.is_action_pressed("aim"):
		position = lerp(position, aim_marker.position, delta * 10.0)
		player.ui.aim_marker.hide()
	else:
		position = lerp(position, revolver_position, delta * 10.0)
		player.ui.aim_marker.show()
	
	if Input.is_action_just_pressed("hammer_down"):
		if not gun_anim.is_playing():
			gun_anim.play("HammerDown")
			hammer_down = true
