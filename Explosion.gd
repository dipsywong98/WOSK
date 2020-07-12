extends AnimatedSprite

signal exploded

func _ready():
	visible = false
	pass

func explode():
	visible = true
	play('default')
	$EndTimer.start()
	$ExplodeSound.play()

func _on_EndTimer_timeout():
	queue_free()
	$ExplodeSound.stop()
	emit_signal("exploded")
