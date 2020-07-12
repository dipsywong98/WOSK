extends CanvasLayer

signal exit
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func show():
	offset.x = 0

func hide():
	offset.x = 1000000
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BackButton_pressed():
	emit_signal("exit")
	hide()
	pass # Replace with function body.
