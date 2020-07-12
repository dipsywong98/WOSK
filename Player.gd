extends KinematicBody2D

export (PackedScene) var Explosion

var start = false

var left_v = 0
var right_v = 0

var velocity = Vector2()
var rotation_speed = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	rotation = -PI/2
	pass # Replace with function body.

func _input(event):
	if !start:
		return
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_W:
			left_v -= 1
			$TopLeftEngine.emit()
		if event.scancode == KEY_S:
			left_v += 1
			$BottomLeftEngine.emit()
		if event.scancode == KEY_O:
			right_v -= 1
			$TopRightEngine.emit()
		if event.scancode == KEY_K:
			right_v += 1
			$BottomRightEngine.emit()
		#print(left_v, right_v)

func _process(delta):
	if start:
		rotation += (left_v - right_v) * delta * rotation_speed
		velocity = move_and_slide(Vector2((right_v + left_v)*10,0).rotated(rotation))

func start():
	start = true
	rotation = -PI/2
	left_v = 10
	right_v = 10
	
func stop():
	start = false
	left_v = 0
	right_v = 0
	
func die():
	stop()
	$Explosion.explode()
	$Sprite.visible = false
