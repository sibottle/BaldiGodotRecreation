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
		if global_transform.origin.distance_to(%Player.global_transform.origin) < 0.5:
			catch()
	else:
		speed = normalSpeed
	if (seeingGuilt):
		guiltSeen += delta
	
func _OnSeePlayer():
	if %Player.running:
			seeingGuilt = true
	super()
	
func catch():
	%Player.global_transform.origin = spawnPos
	angry = false
	guiltSeen = 0
