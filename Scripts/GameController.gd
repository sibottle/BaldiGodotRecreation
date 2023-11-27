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
	%UI.get_node("MathGame").show()
	%UI.get_node("MathGame")._show()
	mathing = true
	Engine.time_scale = 0

func DisableMathGame():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	%UI.get_node("MathGame").hide()
	mathing = false
	Engine.time_scale = 1
	
func EnableSpoopMode():
	spoopMode = true
	%Baldi.show()
