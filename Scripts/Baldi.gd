extends "res://Scripts/Character.gd"

var slapSpeed = 5
var anger = 0
var slapTime = 0
var slapDelay = 1
@onready var sprite : AnimatedSprite3D = $AnimatedSprite3D
@onready var SlapSound : AudioStreamPlayer3D = $AudioStreamPlayer3D

	
func getAnger(a):
	anger += a
	if anger < 0.5: anger = 0.5
	slapDelay = -3 * anger / anger + 5
	
func _physics_process(delta):
	super(delta)
	if slapTime <= 0: slap()
	else: slapTime -= delta

func _OnSeePlayer():
	super()
	agent.target_position = Player.global_transform.origin

func slap():
	SlapSound.play()
	sprite.play("default")
	speed = slapSpeed
	slapTime = slapDelay
	await get_tree().create_timer(0.25).timeout
	speed = 0
