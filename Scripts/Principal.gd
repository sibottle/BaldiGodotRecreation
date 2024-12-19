extends "res://Scripts/Character.gd"

var normalSpeed = 2
var runSpeed = 3
var guiltSeen = 0
var angry = false
var seeingGuilt = false

@onready var spawnPos = global_transform.origin

@onready var Aud : AudioStreamPlayer3D = $AudioStreamPlayer3D

func _physics_process(delta):
	if guiltSeen > 0.5:
		angry = true
	if guiltSeen > 0 && !seeingGuilt:
		guiltSeen -= delta
	seeingGuilt = false
	super(delta)
	if angry:
		speed = runSpeed
		agent.target_position = %Player.global_transform.origin
	else:
		speed = normalSpeed
	if (seeingGuilt):
		guiltSeen += delta
	
func _OnSeePlayer():
	if %Player.running:
			seeingGuilt = true
	super()
func _OnTouchPlayer():
	if angry:
		catch()
func catch():
	%Player.global_transform.origin = spawnPos
	angry = false
	guiltSeen = 0
