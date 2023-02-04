extends KinematicBody2D

export var chase_speed = 200

const gravity = 90

onready var DetectionRay = $DetectionRay
onready var GunPos = $GunPos

var bullet = preload("res://Nodes/Bullet.tscn")
var target = null
var velocity = Vector2.ZERO


func _process(delta):
	GunPos.position = Vector2(16,0) if velocity.x > 0 else Vector2(-16,0)

func _physics_process(delta):
	if target:
		var target_dir = Vector2(target.global_position - global_position).normalized()
		DetectionRay.cast_to = target_dir * 128
		if DetectionRay.is_colliding() and DetectionRay.get_collider().is_in_group('player'):
			velocity = target_dir.project(Vector2.RIGHT) * chase_speed
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > 200:
			velocity.y = 200
	velocity = move_and_slide(velocity, Vector2.UP)
func _on_DetectionArea_body_entered(body):
	if body.is_in_group('player'):
		target = body


func _on_DetectionArea_body_exited(body):
	if body.is_in_group('body'):
		target = null


func _on_ShootArea_body_entered(body):
	if body.is_in_group('player'):
		shoot()
		$ShootTimer.start()


func _on_ShootArea_body_exited(body):
	if body.is_in_group('player'):
		$ShootTimer.stop()


func _on_ShootTimer_timeout():
	shoot()

func shoot():
	var target_dir = Vector2(target.global_position - global_position).normalized()
	var bulletInstance = bullet.instance()
	bulletInstance.dir = target_dir
	bulletInstance.global_position = $GunPos.global_position
	bulletInstance.rotation = get_angle_to(target_dir)
	get_tree().get_root().add_child(bulletInstance)
	
