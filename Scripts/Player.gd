extends KinematicBody2D

#Stats
var MaxHealth = 100
var Health = 100
var MaxEssence = 100
var Essence = 20

const MAX_SPEED = 2000
const FRICTION_AIR = 0.95
const FRICTION_GROUND = 0.85
const CHAIN_PULL = 80

var speed = 400
var velocity = Vector2()
var gravity = 50
var jumpForce = -1000
var holdtimer = 0

var canShoot = true
var isDead = false
var lookingRight = true
var jumped = false
var justLanded = false
var takingDamage = false
var DeathTimerStarted = false
var inDialogue = true

var gunDirection = Vector2.ZERO
var prevGunDirection = Vector2.ZERO


var chain_velocity:= Vector2(0,0)
var can_jump = false

#Nodes
onready var anim = get_node("Sprite")


onready var GunHolder = get_node("GunHolder")
onready var gunPos = get_node("GunHolder/Gun/GunPoint")
var bullet = preload("res://Nodes/Bullet.tscn")

onready var healthBar = get_parent().get_node("HUD/Control/Health")
onready var essenceBar = get_parent().get_node("HUD/Control/Essence")

func _ready():
	#Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	pass

func _process(_delta):
	HandleUI()
	if !isDead and !inDialogue:
		HandleGun()
		#Movement
		if holdtimer == 0:
			velocity.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
			velocity.x *= speed
		else:
			velocity.x = 0
		
		
	#State Mashine for animations
	if is_on_floor():
		if isDead:
			anim.play("die")
		elif velocity.x != 0:
			anim.play("move")
		elif velocity.x == 0:
			anim.play("idle")
	else:
		if velocity.y != 0:
			if jumped:
				anim.play("jump")
		
	if !isDead and !inDialogue:
		#Making sure that the character is always facing the mouse
		var mousePos = get_global_mouse_position()
		if mousePos.x - global_position.x > 0 and !lookingRight:
			flip()
		elif mousePos.x - global_position.x < 0 and lookingRight:
			flip()
		
		#Healing input
		if Input.is_action_pressed("heal") and Health < MaxHealth:
			holdtimer += _delta
			if holdtimer > 1:
				heal()
		else:
			holdtimer = 0
	
	#Capping Stats and resetting
	if Essence < 0:
		Essence = 0
	if Health <= 0:
		Health = 0
		isDead = true

func _physics_process(_delta):
	if !isDead and !inDialogue:
		HandleGrapple()
		#Jumping
		if is_on_floor():
			if Input.is_action_pressed("jump") and holdtimer == 0:
				jumped = true
				$JumpAudio.play()
				get_node("Timers/JumpTimer").start()
				velocity.y = jumpForce 
	
	#Gravity
	if !is_on_floor():
		velocity.y += gravity
	
	velocity = move_and_slide(velocity, Vector2.UP)

func HandleGrapple():
	get_node("GunHolder/Gun/Indicator/Glow").visible = get_node("GunHolder/Gun/RayCast2D").is_colliding()
	
	if $Chain.hooked:
		chain_velocity = to_local($Chain.tip).normalized() * CHAIN_PULL
		if chain_velocity.y > 0:
			chain_velocity.y *= 0.55
		else:
			chain_velocity.y *= 1.65
		if sign(chain_velocity.x) != sign(velocity.x):
			chain_velocity.x *= 0.7
	else:
		chain_velocity = Vector2(0, 0)
	velocity += chain_velocity
	
	velocity.y = clamp(velocity.y, -MAX_SPEED, MAX_SPEED)	# Make sure we are in our limits
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	var grounded = is_on_floor()
	if grounded:
		velocity.x *= FRICTION_GROUND
		can_jump = true
		if velocity.y >= 5:
			velocity.y = 5
	elif is_on_ceiling() and velocity.y <= -5:
			velocity.y = -5
	
	if !grounded:
		velocity.x *= FRICTION_AIR
		if velocity.y > 0:
			velocity.y *= FRICTION_AIR

func HandleUI():
	#Changes the values of the UI bars in realtime
	healthBar.value = Health
	essenceBar.value = Essence

func _input(event):
	if event is InputEventMouseMotion:
		prevGunDirection = get_global_mouse_position() - global_position
		GunHolder.look_at(get_global_mouse_position())
	if event.is_action("grapple") and event.pressed and get_node("GunHolder/Gun/RayCast2D").is_colliding():
			$Chain.shoot(prevGunDirection)
	if event.is_action_released("grapple"):
		$Chain.release()

func HandleGun():
	#handles all of our gun functions
	#it's not even a gun anymore but sure
	gunDirection = get_global_mouse_position() - global_position
	GunHolder.look_at(get_global_mouse_position())
	
	var gamepad_vector = Input.get_vector("aim_left", "aim_right","aim_up", "aim_down")
	if  gamepad_vector != Vector2.ZERO:
		gunDirection = gamepad_vector
		prevGunDirection = gamepad_vector
		GunHolder.look_at(global_position + gunDirection)
	else:
		GunHolder.look_at(global_position + prevGunDirection)
		
	if Input.is_action_just_pressed("shoot") and canShoot:
		canShoot = false
		get_node("Timers/TimeBetweenShots").start()
		shoot()

func shoot():
	#Instatiates a bullet and shoot its toward the mouse
	var bulletInstance = bullet.instance()
	bulletInstance.dir = prevGunDirection
	bulletInstance.global_position = gunPos.get_global_position()
	bulletInstance.rotation = GunHolder.rotation
	get_tree().get_root().add_child(bulletInstance)
	
	

func heal():
	$HealParticles.emitting = true
	#Healths the player at the price of the essence collected
	holdtimer = 0
	
	var healthlost = MaxHealth - Health
	if Essence >= healthlost:
		Essence -= healthlost
		Health += healthlost / 2
	else:
		Health += Essence / 2
		Essence = 0

func flip():
	#Flips the player character
	anim.flip_h = !anim.flip_h
	lookingRight = !lookingRight
	get_node("Ball").position.x *= -1

func TakeDamage(arg):
	Health -= arg
	get_node("Timers/damageTimer").start()
	modulate = "e00000"
	if Health <= 0:
		Die()

func Die():
	if !DeathTimerStarted:
		DeathTimerStarted = true
		isDead = true
		#get_parent().get_node("AnimationPlayer").play("fade out")
		get_node("Timers/deathTimer").start()

#Timers
func _on_TimeBetweenShots_timeout():
	canShoot = true

func _on_JumpTimer_timeout():
	jumped = false


func _on_damageTimer_timeout():
	modulate = "ffffff"


func _on_deathTimer_timeout():
	#get_parent().get_node("AnimationPlayer").play("fade in")
	match get_parent().altairsActivated:
		0:
			get_tree().reload_current_scene()
		1:
			position = Vector2(-686, 51)
			Health = MaxHealth * 0.5
			Essence = 0
		2:
			position = Vector2(3144, 1730)
			Health = MaxHealth * 0.5
			Essence = 0
	if get_parent().MiniBossAlive:
		get_parent().get_node("MiniBoss").Health = get_parent().get_node("MiniBoss").maxHealth
	isDead = false
	DeathTimerStarted = false
