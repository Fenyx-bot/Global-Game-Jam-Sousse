extends Area2D


var playerIn = false
var altairActivated = false


func _process(_delta):
	if playerIn:
		if Input.is_action_just_pressed("interact") and !altairActivated:
			get_node("AnimationPlayer").play("Start")
			altairActivated = true
			get_parent().altairsActivated += 1
			match get_parent().currentDialogue:
				1:
					var new_dialog = Dialogic.start('Altair 1')
					get_parent().get_node("Player").inDialogue = true
					get_parent().get_node("HUD/Control").add_child(new_dialog)
				2:
					var new_dialog = Dialogic.start('Altair 2')
					get_parent().get_node("Player").inDialogue = true
					get_parent().get_node("HUD/Control").add_child(new_dialog)
			
func _on_Altair_body_entered(body):
	if body.name == "Player":
		playerIn = true

func _on_Altair_body_exited(body):
		if body.name == "Player":
			playerIn = false
