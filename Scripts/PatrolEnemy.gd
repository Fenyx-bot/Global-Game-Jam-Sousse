extends KinematicBody2D


func _ready():
	pass
	


func _on_VisionTimer_timeout():
	$Sprite.flip_h = !$Sprite.flip_h
	if $VisionRay.cast_to == Vector2(50,0):
		$VisionRay.cast_to = Vector2(-50,0)
	else:
		$VisionRay.cast_to = Vector2(50,0)
