extends Control

@export var aim_marker: Panel

var full_soul = preload("res://sprites/HealthSprite1.png")
var dead_soul = preload("res://sprites/HealthSprite.png")

@onready var health_container = $Control/HealthContainer

var health_icon_list: Array

func _ready():
	var health_container_kids = health_container.get_children()
	for i in health_container_kids:
		health_icon_list.append(i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Container/Container/AmmoLabel.text = str(PlayerData.revolver_ammo)
	

func update_health(player_health):
	for i in health_icon_list:
		i.texture = dead_soul
	for i in player_health:
		health_icon_list[i].texture = full_soul
