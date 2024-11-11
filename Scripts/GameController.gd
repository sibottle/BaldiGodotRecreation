extends Node

var endlessMode = false
var noteBookCount = 0
var spoopMode = false
var mathing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func EnableMathGame():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	%UI/MathGame.show()
	%UI/MathGame.show()
	mathing = true
	Engine.time_scale = 0

func DisableMathGame():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	%UI/MathGame.hide()
	mathing = false
	Engine.time_scale = 1
	
func ActivateJumprope():
	%UI/JumpRope.show()
	%Player.jumprope = true
	
func DeactivateJumprope():
	%UI/JumpRope.hide()
	%Player.jumprope = false
	%Playtime.playingTime = 60
	
func EnableSpoopMode():
	spoopMode = true
	%Baldi.show()
