extends Particles2D


func _ready():
	pass # Replace with function body.

func emit():
	emitting = true
	$StopTimer.start()
	$RocketSound.play()

func _on_StopTimer_timeout():
	emitting = false
	$RocketSound.stop()
