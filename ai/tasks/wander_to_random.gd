extends BTAction



func _tick(delta) -> Status:
	agent.move(delta)
	agent.move_and_slide()
	
	
	if agent.wander_success_area.monitoring == true and agent.wander_success_area.has_overlapping_areas():
		agent.velocity = Vector3.ZERO
		agent.wander_success_area.monitoring = false
		print("yuh")
		agent.wander_success_collision.start()
		if agent.target == agent.wander_node1:
			agent.target = agent.wander_node2
		else:
			agent.target = agent.wander_node1
		

	
	return RUNNING
