extends BTAction

func _tick(delta) -> Status:
	var pos: Vector3 = agent.global_transform.origin
	pos += Vector3(
		randf_range(-5.0, 5.0),
		0,
		randf_range(-5.0, 5.0)
		
	)
	
	agent.wander_node1.global_position =  pos
	return SUCCESS
