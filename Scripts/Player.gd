extends KinematicBody2D


var speed = 200
var velocity = Vector2()
var gravity = 90
var jumpForce = -50


func _ready():
	pass

func _process(_delta):
	velocity.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))

func _physics_process(_delta):
	velocity = move_and_slide(velocity)
