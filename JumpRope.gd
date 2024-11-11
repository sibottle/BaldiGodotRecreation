extends Control

var count = 0
var maxCount = 5
var awaiting = true

func _show():
	count = 0
	$JumpropeCount.text = str('0/',maxCount)
	$rope.frame = 0
	awaiting = true
	
func _process(delta):
	$rope.play("default",2.5)
	if $rope.frame == 13 and awaiting:
		awaiting = false
		if  %Player.is_on_floor():
			count = 0
		else:
			count += 1
			if count >= maxCount:
				%GameController.DeactivateJumprope()
		$JumpropeCount.text = str(count,'/',maxCount)
	if $rope.frame == 14:
		awaiting = true
