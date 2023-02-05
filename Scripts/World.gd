extends Node2D


var inIntro = true
var altairsActivated = 0
var PassageOneOpen = false
var PassageTwoOpen = false

var MiniBossAlive = true
var HiddenAltairShown = false
var BossAlive = true

func _process(delta):
	match altairsActivated:
		1:
			if !PassageOneOpen:
				PassageOneOpen = true
				get_node("AnimationPlayer").play("RemoveLimit1")
		2:
			if !PassageTwoOpen:
				PassageTwoOpen = true
				get_node("AnimationPlayer").play("RemoveLimit2")
	
	if !MiniBossAlive and !HiddenAltairShown:
		HiddenAltairShown = true
		get_node("AnimationPlayer").play("ShowAltair")


func _on_Damage_body_entered(body):
	if body.name == "Player":
		get_node("Player").Die()
