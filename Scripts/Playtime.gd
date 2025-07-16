extends "res://Scripts/Character.gd"

var normalSpeed = 1
var runSpeed = 2
var playingTime = 0
	
	
func _physics_process(delta):
		super(delta)
		

func JumpropingFinished():
	speed = normalSpeed

func _OnSeePlayer():
	super()
	if playingTime <= 0 && !Player.jumprope:
		speed = runSpeed
		agent.target_position = Player.global_transform.origin
		
func _OnTouchPlayer():
	if playingTime <= 0 and !Player.jumprope:
			catch()

func catch():
	speed = 0
	GC.ActivateJumprope()
	agent.target_position = Player.global_transform.origin - Player.global_transform.basis.z
	global_transform.origin = agent.get_final_position()
	pass
