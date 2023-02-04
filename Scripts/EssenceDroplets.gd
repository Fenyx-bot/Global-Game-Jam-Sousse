extends Area2D

func _on_EssenceDroplets_body_entered(body):
	#Checks if the body is the player and then chooses a random number between 5 and 10 to add it to the player's essence
	if body.name == "Player":
		body.Essence += rand_range(5, 10)
		queue_free()
