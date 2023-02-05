extends KinematicBody2D

#Stats
var speed = 300
var Health = 50
var damage = 30
var dropAmmount = 4

var isDead = false
var canHit = true
var inRange = false

var velocity = Vector2()
var gravity = 50

var chase = false
var lookingRight = true

onready var anim = get_node("Sprite")
onready var Player : KinematicBody2D = get_tree().get_root().get_node("World/Player")

var essence = preload("res://Nodes/EssenceDroplets.tscn")

func _process(_delta):
	if isDead:
		anim.play("die")
	elif is_on_floor():
		if velocity.x != 0:
			anim.play("move")
		elif velocity.x == 0:
			anim.play("idle")
	
	if Player.takingDamage and canHit and inRange:
		canHit = false
		Player.TakeDamage(damage)
		get_node("Timers/CanHitTimer").start()
	
	if velocity.x > 0 and !lookingRight:
		flip()
	elif velocity.x < 0 and lookingRight:
		flip()

func _physics_process(_delta):
	if not isDead:
		if chase:
			var playerPos = Player.get_global_position()
			if playerPos.x - position. x > 0:
				velocity.x = speed
			elif playerPos.x - position.x < 0:
				velocity.x = -speed
			else:
				velocity.x = 0
		else:
			velocity.x = 0
	
	#Gravity
	if !is_on_floor() and !isDead:
		velocity.y += gravity
		if velocity.y > 600:
			velocity.y = 600
	
	velocity = move_and_slide(velocity, Vector2.UP)

func flip():
	anim.flip_h = !anim.flip_h
	lookingRight = !lookingRight

func TakeDamage(arg):
	Health -= arg
	get_node("Timers/damageTimer").start()
	modulate = "e00000"
	
	if Health <= 0:
		Die()

func Die():
	isDead = true
	velocity = Vector2.ZERO
	get_node("CollisionShape2D").set_deferred("disabled", true)
	get_node("DamageArea/CollisionShape2D").set_deferred("disabled", true)
	Drop()
	

func Drop():
	for _i in range(dropAmmount):
		var essenceInstance = essence.instance()
		essenceInstance.position = Vector2(position.x + rand_range(-50, 50), position.y - 10)
		get_tree().get_root().add_child(essenceInstance)

func _on_Detection_body_entered(body):
	if body.name == "Player":
		chase = true

func _on_Detection_body_exited(body):
	if body.name == "Player":
		chase = false


func _on_DamageArea_body_entered(body):
	if body.name == "Player":
		inRange = true
		body.takingDamage = true


func _on_DamageArea_body_exited(body):
	if body.name == "Player":
		inRange = false
		body.takingDamage = false


func _on_CanHitTimer_timeout():
	canHit = true


func _on_damageTimer_timeout():
	modulate = "ffffff"
