extends "res://Scripts/Character.gd"

var currentSpeed := 0.0
var runSpeed = 100.0
var normSpeed = 2.5

var coolDown = 0.0
var autoBrakeCool = 0.0
var hugThreshold = 1

var angleDiff = 0.0

var crazyTime = 0.0

var hugging = null

@export var motorAudio : AudioStreamPlayer3D
@export var audioDevice : AudioStreamPlayer3D

func _ready() -> void:
	super()
	unsee_player.connect(_OnWander)

func _physics_process(delta):
	super(delta)
			
	if hugging:
		hugging.global_position = global_position - basis.z/3 + Vector3.UP*0.2
		if velocity.length() <= hugThreshold:
			hugging.hugged = false
			hugging = null

func _OnSeePlayer():
	super()
	agent.target_position = Player.global_transform.origin
	
func _OnTouchPlayer(body):
	autoBrakeCool = 0
	if velocity.length() > hugThreshold:
		hugging = body
		hugging.hugged = true
		
func _OnLeavePlayer(body):
	autoBrakeCool = 1
	
func delta_angle(no_1, no_2):
	var a = no_1 - no_2
	if (a > 180): a -= 360
	if (a < -180): a += 360
	return a

func _process(delta):
	currentSpeed = runSpeed if SeesPlayer else normSpeed
	if coolDown > 0:
		coolDown -= 1 * delta
	if autoBrakeCool > 0:
		autoBrakeCool -= 1 * delta;
		
	angleDiff = delta_angle(global_rotation.y * 57.29578 + 90, -atan2(agent.get_next_path_position().z - global_position.z, agent.get_next_path_position().x - global_position.x) * 57.29578)
	
	if crazyTime <= 0:
		if abs(angleDiff) < 5:
			look_at(Vector3(agent.get_next_path_position().x, position.y, agent.get_next_path_position().z))
			speed = currentSpeed;
		else:
			rotate(Vector3.UP, turn_speed * -sign(angleDiff) * delta)
			speed = 0
	else:
		speed = 0
		rotate(Vector3.UP, 180 * delta)
		crazyTime -= delta
		
	motorAudio.pitch_scale = velocity.length() + 1
