extends Area3D
@onready var GC = get_tree().get_first_node_in_group("GC")
func Collect():
	GC.EnableMathGame()
	GC.noteBookCount += 1
	global_position.y -= 5
	if GC.endlessMode: ReadyForRise()
	

func ReadyForRise():
	await get_tree().create_timer(180).timeout
	global_position.y += 5
