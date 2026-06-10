extends Control


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Container/Container/AmmoLabel.text = str(PlayerData.revolver_ammo)
