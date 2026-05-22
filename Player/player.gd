extends CharacterBody3D

@onready var head = $Head
@onready var player = $"."
@onready var camera = $Head/Pivot/Camera
@onready var full_collision = $FullCollision
@onready var crouch_collision = $CrouchCollision
@onready var raycast = $CrouchCollision/RayCast3D


const JUMP_VELOCITY = 5.0
const WALK_SPEED = 4.0
const CROUCH_SPEED = 1.5

const CAMERA_CROUCH_POS = 0.75
const CAMERA_WALK_POS = 1.3

var sensitivity = 0.002
var speed = 4.0


#head_bob variables
const BOB_FREQ = 3
const BOB_AMP = 0.06
var t_bob = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		player.rotate_y(-event.relative.x * sensitivity)
		head.rotate_x(-event.relative.y * sensitivity)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-60), deg_to_rad(60))


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_pressed("crouch"):
		speed = CROUCH_SPEED
		full_collision.disabled = true
		camera.position.y = lerp(camera.position.y, CAMERA_CROUCH_POS, 7 * delta)
	else:
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
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	
	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	head.transform.origin = head_bob(t_bob)
	
	move_and_slide()



func head_bob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * (BOB_AMP / 2)
	return pos
