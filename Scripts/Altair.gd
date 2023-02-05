extends Area2D


var playerIn = false
var altairActivated = false


func _process(_delta):
	if playerIn:
		if Input.is_action_just_pressed("interact") and !altairActivated:
			get_node("AnimationPlayer").play("Start")
			altairActivated = true
			get_parent().altairsActivated += 1

func _on_Altair_body_entered(body):
	if body.name == "Player":
		playerIn = true

func _on_Altair_body_exited(body):
		if body.name == "Player":
			playerIn = false
