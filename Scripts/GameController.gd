extends Node

var endlessMode = false
var noteBookCount = 0
var spoopMode = false
var mathing = false

@onready var music : AudioStreamPlayer = get_node("MusicPlayer")

@onready var Mus_School = preload("res://Audio/Music/mus_School.wav")
@onready var Mus_Learn = preload("res://Audio/Music/mus_Learn.wav")
@onready var Mus_hang = preload("res://Audio/Music/mus_hang.wav")

# Characters to clone during spoop mode
const BaldiSpawn = preload("res://Prefabs/Characters/baldi.tscn")
const PtSpawn = preload("res://Prefabs/Characters/playtime.tscn")
const PriSpawn = preload("res://Prefabs/Characters/Principal.tscn")

# Characters to hold after spawning
var char_Baldi : CharacterBody3D
var char_Pt : CharacterBody3D
var char_Pri : CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func EnableMathGame():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	%UI/MathGame._show()
	%UI/MathGame.show()
	get_tree().paused = true
	mathing = true
	if (!spoopMode):
		music.stream = Mus_Learn
		music.play()
	


func DisableMathGame():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	%UI/MathGame.hide()
	mathing = false
	%Player.stamina = 100
	if !spoopMode:
		music.stream = Mus_School
		music.play()
		
func ActivateJumprope():
	%UI/JumpRope.show()
	%Player.jumprope = true
	
func DeactivateJumprope():
	%UI/JumpRope.hide()
	%Player.jumprope = false
	char_Pt.playingTime = 60
	char_Pt.JumpropingFinished()
	
func EnableSpoopMode():
	music.stream = Mus_hang
	music.play()
	spoopMode = true
	char_Baldi = BaldiSpawn.instantiate()
	get_parent().add_child(char_Baldi)
	char_Pt = PtSpawn.instantiate()
	get_parent().add_child(char_Pt)
	char_Pri = PriSpawn.instantiate()
	get_parent().add_child(char_Pri)

	
