extends Control

@export var aim_marker: Panel



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Container/Container/AmmoLabel.text = str(PlayerData.revolver_ammo)
