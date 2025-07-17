extends Control
#for some reason getting the game controller via getting the first node in a group causes issues??? idk why
@onready var GameController = %GameController
@onready var Player = %Player
@onready var rope = $rope
@onready var JumpropeCount = $Label
var count = 0
var maxCount = 5
var awaiting = true

func _show():
	count = 0
	JumpropeCount.text = str('Time to jump rope!\n0/',maxCount)
	rope.frame = 0
	awaiting = true
	
func _process(delta):
	rope.play("default",2.5)
	if rope.frame == 13 and awaiting:
		awaiting = false
		if  Player.is_on_floor():
			count = 0
		else:
			count += 1
			if count >= maxCount:
				GameController.DeactivateJumprope()
		JumpropeCount.text = str('Time to jump rope!\n',count,'/',maxCount)
	if rope.frame == 14:
		awaiting = true
