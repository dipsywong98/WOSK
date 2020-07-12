extends CanvasLayer

signal start_game
signal prepare_game

func _ready():
	entrance()
	pass # Replace with function body.

func debug(text):
	$DebugLabel.text = text

func set_score(score):
	$ScoreLabel.text = str(score)

func set_health(percent):
	var width = get_viewport().get_visible_rect().size[0]
	$GreenColorRect.rect_position.x = (percent - 1)*width
	$YellowColorRect.rect_position.x = (percent - 1)*width
	$RedColorRect.rect_position.x = (percent - 1)*width
	$GreenColorRect.visible = false
	$YellowColorRect.visible = false
	$RedColorRect.visible = false
	if percent > 0.60:
		$GreenColorRect.visible = true
	elif percent > 0.30:
		$YellowColorRect.visible = true
	else:
		$RedColorRect.visible = true
	pass
	
func entrance():
	$Music.play()
	$GameOverSound.stop()
	$MessageLabel.visible = true
	$MessageLabel.text = 'WOSK'
	$ScoreLabel.visible = false
	$HealthBarColorRect.visible = false
	$StartButton.visible = true
	$HelpButton.visible = true
	
func game_over():
	$Music.stop()
	$GameOverSound.play()
	$MessageLabel.visible = true
	$MessageLabel.text = 'YOU DIED'
	$EndTimer.start()

func _on_Button_pressed():
	emit_signal("prepare_game")
	$StartTimer.start()
	$StartButton.visible = false
	$HelpButton.visible = false
	set_score(0)
	$MessageLabel.text = 'READY!'

func _on_StartTimer_timeout():
	emit_signal('start_game')
	$ScoreLabel.visible = true
	$MessageLabel.visible = false
	$HealthBarColorRect.visible = true
	set_health(1.0)


func _on_EndTimer_timeout():
	entrance()


func _on_HelpButton_pressed():
	pass # Replace with function body.
	$Help.show()
