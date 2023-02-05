extends KinematicBody2D

onready var BossBar = get_node("/root/World/HUD/Control/BossBar")

var bullet = preload("res://Nodes/Bullet.tscn")

const move_speed = 200

var Health = 500

var low_hp = false
var move_dir = Vector2.LEFT
var velocity = Vector2.ZERO
var target = null
var isDead = false

func _ready():
	BossBar.max_value = Health

func _process(delta):
	BossBar.value = Health

func _physics_process(delta):
	velocity = move_and_slide(move_dir * move_speed)

func _on_MoveTimer_timeout():
	move_dir *= -1


func _on_DetectionArea_body_entered(body):
	if body.name == "Player":
		target = body

func _on_DetectionArea_body_exited(body):
	if body.name == "Player":
		target = null

func _on_ShootTimer_timeout():
	if target and !target.isDead:
		shoot()


func shoot():
	#Instatiates a bullet and shoot its toward the mouse
	var bulletInstance = bullet.instance()
	bulletInstance.dir = (target.global_position - global_position).normalized()
	bulletInstance.global_position = get_node("Aim/BulletPoint").get_global_position()
	bulletInstance.rotation = get_angle_to(target.global_position)
	bulletInstance.modulate = Color.red
	get_tree().get_root().add_child(bulletInstance)
	
func TakeDamage(arg):
	Health -= arg
	if Health <= 0:
		Die()

func Die():
	isDead = true
	velocity = Vector2.ZERO
	get_node("CollisionShape2D").set_deferred("disabled", true)
	get_parent().MiniBossAlive = false
	queue_free()
	
