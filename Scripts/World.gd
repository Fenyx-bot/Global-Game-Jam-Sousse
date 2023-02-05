extends Node2D


var inIntro = true


func _on_BossArea_body_entered(body):
	if body.is_in_group('player'):
		$BossArea/CameraAnim.play("boss_fight")
