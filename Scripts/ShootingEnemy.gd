extends KinematicBody2D

export var chase_speed = 200

onready var AimRay = $AimRay

var target = null

func _physics_process(delta):
	if target:
		var target_dir = Vector2(target.global_position - global_position).normalized()
		AimRay.cast_to = target_dir * 128
		if AimRay.is_colliding() and AimRay.get_collider().is_in_group('player'):
			move_and_slide(target_dir * chase_speed)

func _on_DetectionArea_body_entered(body):
	if body.is_in_group('player'):
		target = body


func _on_DetectionArea_body_exited(body):
	if body.is_in_group('body'):
		target = null
