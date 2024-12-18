extends Control

var questionText = "LOAD LOAD STILL LOAD"
var currentQuestion = 1
var questionAnswer = 0
var exitTimer = 4

@onready var BaldiSprite : AnimatedSprite2D = $AnimatedSprite2D

@onready var checkMarkImage = preload("res://Textures/UI/Check-sharedassets1.assets-27.png")
@onready var xImage = preload("res://Textures/UI/X-sharedassets2.assets-358.png")
#numbers and math stuff
@onready var Aud_numbers = [
	preload("res://Audio/Characters/Baldi/MathGame/Numbers/BAL_Math_0.wav"),
	preload("res://Audio/Characters/Baldi/MathGame/Numbers/BAL_Math_1.wav"),
	preload("res://Audio/Characters/Baldi/MathGame/Numbers/BAL_Math_2.wav"),
	preload("res://Audio/Characters/Baldi/MathGame/Numbers/BAL_Math_3.wav"),
	preload("res://Audio/Characters/Baldi/MathGame/Numbers/BAL_Math_4.wav"),
	preload("res://Audio/Characters/Baldi/MathGame/Numbers/BAL_Math_5.wav"),
	preload("res://Audio/Characters/Baldi/MathGame/Numbers/BAL_Math_6.wav"),
	preload("res://Audio/Characters/Baldi/MathGame/Numbers/BAL_Math_7.wav"),
	preload("res://Audio/Characters/Baldi/MathGame/Numbers/BAL_Math_8.wav"),
	preload("res://Audio/Characters/Baldi/MathGame/Numbers/BAL_Math_9.wav")
	]
@onready var Aud_Plus = preload("res://Audio/Characters/Baldi/MathGame/BAL_Math_Plus.wav")
@onready var Aud_Minus = preload("res://Audio/Characters/Baldi/MathGame/BAL_Math_Minus.wav")
@onready var Aud_Times = preload("res://Audio/Characters/Baldi/MathGame/BAL_Math_Times.wav")
@onready var Aud_Equals = preload("res://Audio/Characters/Baldi/MathGame/BAL_Math_Equals.wav")
#Praises
@onready var Aud_Praises = [
	preload("res://Audio/Characters/Baldi/MathGame/Praises/BAL_Praise1.wav"),
	preload("res://Audio/Characters/Baldi/MathGame/Praises/BAL_Praise2.wav"),
	preload("res://Audio/Characters/Baldi/MathGame/Praises/BAL_Praise3.wav"),
	preload("res://Audio/Characters/Baldi/MathGame/Praises/BAL_Praise4.wav"),
	preload("res://Audio/Characters/Baldi/MathGame/Praises/BAL_Praise5.wav")
	]
#Problems
@onready var Aud_Problems = [
	preload("res://Audio/Characters/Baldi/MathGame/Problems/BAL_General_Problem1.wav"),
	preload("res://Audio/Characters/Baldi/MathGame/Problems/BAL_General_Problem2.wav"),
	preload("res://Audio/Characters/Baldi/MathGame/Problems/BAL_General_Problem3.wav")
	]
	
@onready var Aud_Screech = preload("res://Audio/Characters/Baldi/Sounds/BAL_Screech.wav")

@onready var checkMarks = [$Checkmark1,$Checkmark2,$Checkmark3]
@onready var text = $Label
@onready var Audio = $Bald

@onready var Queue = [
preload("res://Audio/Characters/Baldi/MathGame/Intro/BAL_Math_Intro.wav"),
preload("res://Audio/Characters/Baldi/MathGame/Intro/BAL_General_HowTo.wav")
]

func _show():
	if (%GameController.spoopMode):
		Audio.volume_db = -INF
		BaldiSprite.hide()
	if (%GameController.noteBookCount == 0):
		Audio.stream = Queue[0]
		Audio.play()
		Queue.remove_at(0)
		BaldiSprite.play("Talk")
	exitTimer = 4
	text.text = questionText
	currentQuestion = 1
	for a in checkMarks:
		a.visible = false
	reset()
	if (%GameController.noteBookCount == 1):
		_on_bald_finished()
	
func _process(delta):
	if !%GameController.mathing: return
	if Input.is_action_just_pressed("confirm"):
		checkAnswer()
	if currentQuestion == 4:
		if exitTimer > 0 : exitTimer -= 0.015
		else:
			get_tree().paused = false
			%GameController.DisableMathGame()
			
	
func reset():
	Queue.clear()
	Queue.append(Aud_Problems[currentQuestion-1])
	$LineEdit.text = ""
	
	if %GameController.noteBookCount > 1 and currentQuestion == 3:
		Queue.append_array([Aud_Screech, Aud_Plus, Aud_Screech, Aud_Times, Aud_Screech, Aud_Minus, Aud_Screech, Aud_Equals])
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
		Queue.append(Aud_numbers[a])
		Queue.append((Aud_Plus if c == 0 else Aud_Minus))
		Queue.append_array([Aud_numbers[b], Aud_Equals])
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
	checkMarks[currentQuestion - 1].visible = true
	if int($LineEdit.text) == questionAnswer: 
		checkMarks[currentQuestion - 1].texture = checkMarkImage
		if (!%GameController.spoopMode):
			Queue.clear()
			Audio.stream = Aud_Praises.pick_random()
			Audio.play()
			BaldiSprite.play("Talk")
	else: 
		Audio.stop()
		BaldiSprite.play("Frown")
		checkMarks[currentQuestion - 1].texture = xImage
		if !%GameController.spoopMode: 
			%GameController.EnableSpoopMode()
		if currentQuestion == 3: %GameController.Baldi.getAnger(1)
		else: %GameController.Baldi.getAnger(0.25)

	currentQuestion += 1
	if currentQuestion == 4:
		text.text = "WOW! YOU EXIST!"
		$LineEdit.text = ""
	else:
		reset()

# Play next sound in queue
func _on_bald_finished() -> void:
	if (!Queue.is_empty()):
		BaldiSprite.play("Talk")
		Audio.stream = Queue[0]
		Audio.play()
		Queue.remove_at(0)
	else:
		BaldiSprite.play("default")
