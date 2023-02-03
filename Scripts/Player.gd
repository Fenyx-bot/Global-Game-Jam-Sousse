extends KinematicBody2D


var speed = 250
var velocity = Vector2()
var gravity = 50
var jumpForce = -900

var canShoot = true

#Nodes
onready var GunHolder = get_node("GunHolder")
onready var gunPos = get_node("GunHolder/Gun/GunPoint")
var bullet = preload("res://Nodes/Bullet.tscn")


func _ready():
	pass

func _process(_delta):
	HandleGun()
	
	#Movement
	velocity.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	velocity.x *= speed
	
	#Gravity
	if !is_on_floor():
		velocity.y += gravity
	
	#Jumping
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = jumpForce
	

func HandleGun():
	GunHolder.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("shoot") and canShoot:
		canShoot = false
		get_node("Timers/TimeBetweenShots").start()
		shoot()

func _physics_process(_delta):
	velocity = move_and_slide(velocity, Vector2.UP)

func shoot():
	var bulletInstance = bullet.instance()
	bulletInstance.dir = get_global_mouse_position() - global_position
	bulletInstance.global_position = gunPos.get_global_position()
	bulletInstance.rotation = GunHolder.rotation
	get_tree().get_root().add_child(bulletInstance)


func _on_TimeBetweenShots_timeout():
	canShoot = true
