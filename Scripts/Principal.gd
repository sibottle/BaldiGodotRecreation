extends "res://Scripts/Character.gd"

var normalSpeed = 2
var runSpeed = 3

var guiltSeen = 0
var angry = false
var seeingGuilt = false
var detentionTime = 0

@onready var spawnPos = global_position
@onready var playerSpawnPos = get_tree().get_first_node_in_group("DetentionSpawn").global_position

@onready var Aud_Whistle = preload("res://Audio/Characters/Principal/PRI_Whistle.wav")
@onready var Aud_No_Running = preload("res://Audio/Characters/Principal/RuleBroke/PRI_NoRunning.wav")
@onready var Aud_No_Bullying = preload("res://Audio/Characters/Principal/RuleBroke/PRI_NoBullying.wav")
@onready var Aud_No_Drinking = preload("res://Audio/Characters/Principal/RuleBroke/PRI_NoDrinking.wav")
@onready var Aud_No_Escaping = preload("res://Audio/Characters/Principal/RuleBroke/PRI_NoEscaping.wav")
@onready var Aud_No_Faculty = preload("res://Audio/Characters/Principal/RuleBroke/PRI_NoFaculty.wav")

@onready var Aud_Times = [
	preload("res://Audio/Characters/Principal/Times/PRI_15Sec.wav"),
	preload("res://Audio/Characters/Principal/Times/PRI_30Sec.wav"),
	preload("res://Audio/Characters/Principal/Times/PRI_45Sec.wav"),
	preload("res://Audio/Characters/Principal/Times/PRI_60Sec.wav"),
	preload("res://Audio/Characters/Principal/Times/PRI_99Sec.wav"),
]

@onready var Aud_Detention = preload("res://Audio/Characters/Principal/PRI_DetentionForYou.wav")

@onready var Aud_Scold = [
	preload("res://Audio/Characters/Principal/Scolds/PRI_KnowBetter.wav"),
	preload("res://Audio/Characters/Principal/Scolds/PRI_WhenLearn.wav"),
	preload("res://Audio/Characters/Principal/Scolds/PRI_YourParents.wav")
]

@onready var Audio = $AudioStreamPlayer3D

enum GuiltTypes {  
	RUNNING,      
	DRINKING,  
	BULLYING,
	ESCAPING,
	FACULTY  
}  

var guiltType = GuiltTypes.RUNNING

func _physics_process(delta):
	if guiltSeen > 0.5:
		angry = true
	if guiltSeen > 0 && !seeingGuilt:
		guiltSeen -= delta
	seeingGuilt = false
	super(delta)
	if angry:
		speed = runSpeed
		agent.target_position = Player.global_position
	else:
		speed = normalSpeed
	if (seeingGuilt):
		guiltSeen += delta
		
func correct_player():
	Audio.clearQueue()
	match guiltType:
		GuiltTypes.RUNNING:
			Audio.add(Aud_No_Running)
		GuiltTypes.DRINKING:
			Audio.add(Aud_No_Drinking)
		GuiltTypes.ESCAPING:
			Audio.add(Aud_No_Escaping)
		GuiltTypes.FACULTY:
			Audio.add(Aud_No_Faculty)
	
func _OnSeePlayer():
	if Player.running:
		guiltType = GuiltTypes.RUNNING
		seeingGuilt = true
	super()
	
func _OnTouchPlayer():
	if angry:
		catch()
		
func _OnWander():
	if (!angry):
		super()
	if randf_range(0.0,10.0) <= 1:
		Audio.add(Aud_Whistle)
		
func catch():
	stopped = true
	Player.global_transform.origin = playerSpawnPos
	global_position = spawnPos
	angry = false
	guiltSeen = 0
	
	Audio.add(Aud_Times[detentionTime])
	Audio.add(Aud_Detention)
	Audio.add(Aud_Scold.pick_random())
	
	detentionTime = min(detentionTime + 1, 4)
	
	await get_tree().create_timer(5).timeout
	stopped = false
