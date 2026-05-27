extends CharacterBody3D

var health = 5

func hit(bullet_type):
	if bullet_type == "revolver":
		health -= PlayerData.revolver_damage
		print(health)
