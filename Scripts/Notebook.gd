extends Area3D

func Collect():
	%GameController.EnableMathGame()
	%GameController.noteBookCount += 1
	global_position.y -= 5
	if %GameController.endlessMode: ReadyForRise()
	

func ReadyForRise():
	await get_tree().create_timer(180).timeout
	global_position.y += 5
