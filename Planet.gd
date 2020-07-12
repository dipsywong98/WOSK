extends Area2D

signal crashed

var left_sceen = false
var left_block = false
var ratio = randf() + 0.2

func _ready():
	scale.x = ratio
	scale.y = scale.x
	$Sprite.frame = randi()%7
	

func try_queue_free():
	if left_sceen && left_block:
		queue_free()

func leave_block():
	left_block = true
	try_queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	left_sceen = true
	try_queue_free()


func _on_Planet_body_entered(body):
	$Explosion.explode()
	#if $Sprite != null:
	$Sprite.visible = false
	emit_signal("crashed", ratio)


func _on_Explosion_exploded():
	pass # Replace with function body.
	queue_free()
