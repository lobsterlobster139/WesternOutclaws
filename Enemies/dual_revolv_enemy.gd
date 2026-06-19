extends CharacterBody3D



var is_near_target = false

var health = 5
var dead = false

const SPEED = 80.0


@export var player_path : NodePath
@export var wander_node1 : Area3D
@export var wander_node2 : Area3D
@export var rotation_speed : float = TAU * 2

@onready var nav_agent = $NavigationAgent3D
@onready var eyesight = $Eyes/Eyesight
@onready var near_timer = $Eyes/Eyesight/Timer
@onready var eyesight_right = $Eyes/EyesightRight
@onready var eyesight_left = $Eyes/EyesightLeft

@onready var wander_success_area = $WanderSuccessArea
@onready var rotation_cone = $RotationCone
@onready var rotation_timer = $RotationTimer
@onready var wander_success_collision = $WanderSuccessCollision



var target = wander_node1

var rotation_timer_finished = false


func _ready():
	target = wander_node1

func _physics_process(delta):
	#if not is_on_floor():
	#	velocity += get_gravity() * delta
	
	
	
	if dead:
		return
	
	if health == 0:
		death()
	
	
	$RotationCone.look_at(target.position)
	
	#var tween = get_tree().create_tween()
	#tween.tween_method(look_at.bind(target.global_position), rotation, target.global_position, 0.7)

	
	
	
	#if eyesight.is_colliding() and eyesight_left.is_colliding() and eyesight_right.is_colliding() and eyesight.get_collider().has_method("is_player"):
		#target = get_node(player_path)
		#is_near_target = true
		#near_timer.start()
	
	
	
	move_and_slide()




func _on_timer_timeout():
	if eyesight.is_colliding() and eyesight_left.is_colliding() and eyesight_right.is_colliding() and eyesight.get_collider().has_method("is_player"):
		is_near_target = true
	else:
		is_near_target = false

func hit(bullet_type):
	if bullet_type == "revolver":
		health -= PlayerData.revolver_damage
		print(health)


func death():
	dead = true
	$PlaceholderMesh/Eyebrows.hide()
	$PlaceholderMesh/DeadEyesMesh.show()
	$PlaceholderMesh/EyeMesh.hide()



func move(delta):
	
	
	
	
	if is_near_target == false:
		velocity = Vector3.ZERO
		
		nav_agent.set_target_position(target.global_position)
		var next_nav_point = nav_agent.get_next_path_position()
		velocity = (next_nav_point - global_position).normalized() * SPEED * delta
		
		look_at(global_transform.origin + velocity)
		rotation_degrees.x = clamp(rotation_degrees.x, 0, 0)
		rotation_degrees.z = clamp(rotation_degrees.z, 0, 0)
		


func _on_rotation_timer_timeout():
	rotation_timer_finished = true


func _on_wander_success_collision_timeout():
	wander_success_area.monitoring = true
