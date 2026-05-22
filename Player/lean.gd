extends Node3D

var lean_id = 0


# Called every frame. 'delta' is the elapsed eeeqetime since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("lean_left"):
		lean_id = 1
	if Input.is_action_just_pressed("lean_right"):
		lean_id = 2
	if Input.is_action_just_released("lean_left") or Input.is_action_just_released("lean_right"):
		lean_id = 0
	check_id(delta)

func check_id(delta):
	if lean_id == 0:
		lean(0, delta)
	if lean_id == 1:
		lean(13, delta)
	if lean_id == 2:
		lean(-13, delta)

func lean(lean_amount, delta):
	var wanted_rot = lerp_angle(rotation.z, lean_amount, 5 * delta)
	rotation.z = wanted_rot
