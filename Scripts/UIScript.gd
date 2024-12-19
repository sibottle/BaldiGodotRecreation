extends Control


func _ready():
	pass # Replace with function body.

func _process(_delta):
	$StaminaBar.value = %Player.stamina
	$NotebookCounter.text = str(%GameController.noteBookCount,"/","7 Notebooks")
