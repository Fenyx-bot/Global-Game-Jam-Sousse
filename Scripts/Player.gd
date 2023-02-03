extends KinematicBody2D


var speed = 200
var velocity = Vector2()
var gravity = 90
var jumpForce = -1200


#Nodes
onready var GunHolder = get_node("GunHolder")


func _ready():
	pass

func _process(_delta):
	#Movement
	velocity.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	velocity.x *= speed
	
	GunHolder.look_at(get_global_mouse_position())
	
	#Gravity
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > 200:
			velocity.y = 200
	
	#Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jumpForce



func _physics_process(_delta):
	velocity = move_and_slide(velocity, Vector2.UP)
