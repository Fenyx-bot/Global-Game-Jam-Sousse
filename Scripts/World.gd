extends Node2D


var inIntro = true
var altairsActivated = 0
var PassageOneOpen = false
var PassageTwoOpen = false
var currentDialogue = 0

var MiniBossAlive = true
var HiddenAltairShown = false
var BossAlive = true

func _ready():
	var new_dialog = Dialogic.start('Game Intro')
	get_node("HUD/Control").add_child(new_dialog)
	get_node("Player").position = Vector2(732, 449)
	
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

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene("res://Scenes/MenuScene.tscn")

func gameStart():
	get_node("Player").inDialogue = false
	currentDialogue += 1
func gameEnd():
	get_tree().change_scene("res://Scenes/MenuScene.tscn")
	get_node("AnimationPlayer").play("GameEnd")

func _on_BossArea_body_entered(body):
	if body.name == "Player" and MiniBossAlive:
		get_node("AnimationPlayer").play("ZoomOut")
		get_node("AnimationPlayer").play("BossBarIn")


func _on_BossArea_body_exited(body):
	if body.name == "Player":
		get_node("AnimationPlayer").play("ZoomIn")
		get_node("AnimationPlayer").play("BossBarOut")


func _on_TreeOfLife_body_entered(body):
	if body.name == "Player":
		#var new_dialog = Dialogic.start('Game Outro')
		#get_node("HUD/Control").add_child(new_dialog)
		pass
