extends CharacterBody3D

@onready var head = $Head
@onready var player = $"."
@onready var camera = $Head/Pivot/Camera
@onready var full_collision = $FullCollision
@onready var crouch_collision = $CrouchCollision

@onready var crouch_raycast = $CrouchCollision/RayCast3D
@onready var top_raycast = $WallClimbDetectors/TopRaycast
@onready var bottom_raycast = $WallClimbDetectors/DickRaycast
@onready var eye_raycast = $Head/Pivot/Camera/EyeRaycast



const JUMP_VELOCITY = 5.0
const WALK_SPEED = 4.0
const CROUCH_SPEED = 1.5

const CAMERA_CROUCH_POS = 0.75
const CAMERA_WALK_POS = 1.5

var sensitivity = 0.002
var speed = 4.0


#head_bob variables
const BOB_FREQ = 3
const BOB_AMP = 0.06
var t_bob = 0.0

var can_walljump = true

#variables that actually matter in game
var health = 9
var cigarettes = 5
var current_direction = null

func is_player():
	pass



func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
	if event is InputEventMouseMotion:
		player.rotate_y(-event.relative.x * sensitivity)
		head.rotate_x(-event.relative.y * sensitivity)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-60), deg_to_rad(60))



func _process(delta):
	#REMOVE LATER!!!!!!!!!!!!!!!!!
	if Input.is_action_just_pressed("DEBUG hurt self"):
		hit("revolver")
	
	
	if Input.is_action_just_pressed("smoke"):
		if cigarettes > 0 and health < 9:
			health += 1
			cigarettes -= 1
	
	$Head/Pivot/Camera/Label.text = str($"../Testing Level/NavigationRegion3D/DualRevolvEnemy".state)



func _physics_process(delta):
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	#walljump
	if Input.is_action_pressed("jump") and not is_on_floor() and top_raycast.is_colliding() == false and bottom_raycast.is_colliding() == true and eye_raycast.is_colliding() == false and can_walljump == true:
		velocity.y = JUMP_VELOCITY
	if bottom_raycast.is_colliding() == false:
		can_walljump = false
		$WalljumpCooldown.start()

	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	#crouch
	if Input.is_action_pressed("crouch"):
		speed = CROUCH_SPEED
		full_collision.disabled = true
		camera.position.y = lerp(camera.position.y, CAMERA_CROUCH_POS, 7 * delta)
	else:
		if not crouch_raycast.is_colliding():
			
			speed = WALK_SPEED
			full_collision.disabled = false
			camera.position.y = lerp(camera.position.y, CAMERA_WALK_POS, 7 * delta)
	
	
	# Get the input direction and handle the movement/deceleration.
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 8.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 8.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 2.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 2.0)
	
	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	head.transform.origin = head_bob(t_bob)
	
	move_and_slide()



func head_bob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * (BOB_AMP / 2)
	return pos


func _on_walljump_cooldown_timeout():
	can_walljump = true


func hit(bullet_type):
	if bullet_type == "revolver":
		health -= PlayerData.revolver_damage
	print(health)
