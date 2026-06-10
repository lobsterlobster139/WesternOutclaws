extends CharacterBody3D


var player = null
var is_near_target = false

var health = 5
var dead = false

const SPEED = 3.0


@export var player_path : NodePath

@onready var nav_agent = $NavigationAgent3D
@onready var eyesight = $Eyesight
@onready var near_timer = $Eyesight/Timer


func _ready():
	player = get_node(player_path)

func _physics_process(delta):
	if dead:
		return
	
	if health == 0:
		death()
	
	if eyesight.is_colliding():
		is_near_target = true
		near_timer.start()
	
	look_at(player.position)
	self.rotation_degrees.x = clamp(self.rotation_degrees.x, 0, 0)
	self.rotation_degrees.z = clamp(self.rotation_degrees.z, 0, 0)
	
	if is_near_target == false:
		velocity = Vector3.ZERO
		
		nav_agent.set_target_position(player.global_position)
		var next_nav_point = nav_agent.get_next_path_position()
		velocity = (next_nav_point - global_position).normalized() * SPEED
		
		
		move_and_slide()



func _on_timer_timeout():
	if eyesight.is_colliding():
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
