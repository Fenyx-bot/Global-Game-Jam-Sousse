extends KinematicBody2D

var speed = 900
var damage = 20
var dir = Vector2()


func _physics_process(_delta):
	var _temp = move_and_slide(dir.normalized() * speed)


func _on_BulletArea_body_entered(body):
	if body.is_in_group("Damagable"):
		body.TakeDamage(damage)
	if not body.is_in_group("bullet"):
		queue_free()
