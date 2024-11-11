extends Control

var questionText = "LOAD LOAD STILL LOAD"
var currentQuestion = 1
var questionAnswer = 0
var exitTimer = 4

@onready var checkMarkImage = preload("res://Textures/UI/Check-sharedassets1.assets-27.png")
@onready var xImage = preload("res://Textures/UI/X-sharedassets2.assets-358.png")

@onready var checkMarks = [$Checkmark1,$Checkmark2,$Checkmark3]
@onready var text = $Label

func _show():
	exitTimer = 4
	text.text = questionText
	currentQuestion = 1
	for a in checkMarks:
		a.texture = null
	reset()
	
func _process(delta):
	if !%GameController.mathing: return
	if Input.is_action_just_pressed("confirm"):
		checkAnswer()
	if currentQuestion == 4:
		if exitTimer > 0 : exitTimer -= 0.015
		else: %GameController.DisableMathGame()
	
func reset():
	$LineEdit.text = ""
	
	if %GameController.noteBookCount > 1 and currentQuestion == 3:
		var a = (randi() + 1) % 9999
		var b = (randi() + 1) % 9999
		var c = (randi() + 1) % 9999
		var sign = randi() % 2
		if sign == 0:
			text.text = str(
				"SOLVE MATH Q",
				currentQuestion,
				":\n\n",
				a,
				"+(",
				b,
				"X",
				c,
				"=")
		else:
			text.text = str(
				"SOLVE MATH Q",
				currentQuestion,
				":\n\n(",
				a,
				"/",
				b,
				")+",
				c,
				"=")
	else:
		var a = randi() % 10
		var b = randi() % 10
		var c = randi() % 2
		
		if c == 0: questionAnswer = a + b
		else: questionAnswer = a - b
		text.text = str(
			"SOLVE MATH Q",
			currentQuestion,
			":\n\n",
			a,
			"+" if c == 0 else "-",
			b,
			"=")
	
func checkAnswer():
	if currentQuestion >= 4: return
	if int($LineEdit.text) == questionAnswer: checkMarks[currentQuestion - 1].texture = checkMarkImage
	else: 
		if currentQuestion == 3: %Baldi.getAnger(1)
		else: %Baldi.getAnger(0.25)
		checkMarks[currentQuestion - 1].texture = xImage
		if !%GameController.spoopMode: %GameController.EnableSpoopMode()

	currentQuestion += 1
	if currentQuestion == 4:
		text.text = "WOW! YOU EXIST!"
		$LineEdit.text = ""
	else:
		reset()
