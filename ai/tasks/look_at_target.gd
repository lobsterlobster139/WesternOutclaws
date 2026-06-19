extends BTAction


func _enter():
	agent.rotation_timer_finished = false
	agent.rotation_timer.start()

func _tick(delta) -> Status:
	agent.global_rotation_degrees.y = lerp(agent.global_rotation_degrees.y, agent.rotation_cone.global_rotation_degrees.y, delta * 1.0)
	agent.rotation_degrees.x = clamp(agent.rotation_degrees.x, 0, 0)
	agent.rotation_degrees.z = clamp(agent.rotation_degrees.z, 0, 0)
	
	if agent.rotation_timer_finished == true:
		return SUCCESS
	
	return RUNNING
