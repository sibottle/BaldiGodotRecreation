extends Node

class_name ItemSelector

const SelectorPositions = [21, 105, 180]
@onready var ItemSlots := [$Item0, $Item1, $Item2]
@onready var ItemText : Label = $ItemText

@export var Player : player
var CurrentItem = 0

var CurrentItems = [0, 0, 0]

@export var ItemNames = [
		"Nothing",
		"Energy flavored Zesty Bar", # not added
		"Yellow Door Lock", # not added
		"Principal's Keys", # not added
		"BSODA", # not added
		"Quarter", # not added
		"Baldi Anti Hearing and Disorienting Tape", # not added
		"Alarm Clock", # not added
		"WD-NoSquee (Door Type)", # not added
		"Safety Scissors", # not added
		"Big Ol' Boots"] # not added
@export var ItemTextures = [
preload("res://Textures/PickUps/EnergyFlavoredZestyBar.png"),
preload("res://Textures/PickUps/YellowDoorLock.png"),
preload("res://Textures/PickUps/Key.png"),
preload("res://Textures/PickUps/BSODA.png"),
preload("res://Textures/PickUps/Quarter.png"),
preload("res://Textures/PickUps/Tape.png"),
preload("res://Textures/PickUps/AlarmClockItem.png"),
preload("res://Textures/PickUps/wd_nosquee.png"),
preload("res://Textures/PickUps/SafetyScissors.png"),
preload("res://Textures/PickUps/BootsIcon.png")
]
@onready var Selector := $Selector

func _process(delta: float) -> void:
	if (Input.is_action_just_released("Scroll_Up")):
		CurrentItem += 1
	if (Input.is_action_just_released("Scroll_Down")):
		CurrentItem -= 1
		if CurrentItem < 0: CurrentItem = 2
	if CurrentItem > 2: CurrentItem = 0
	Selector.position.x = SelectorPositions[CurrentItem]
	ItemText.text = ItemNames[CurrentItems[CurrentItem]]
	if Input.is_key_pressed(KEY_G):
		CollectItem(1)
func _input(event: InputEvent) -> void:
	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)):
		UseItem()
	
func UseItem():
	match CurrentItems[CurrentItem]:
		0:
			pass
		1: #zesty bar
			Player.stamina = 200
		5: #quarter
			Player.UseQuarter()
			return
	CollectItem(0)
func CollectItem(item: int):
	CurrentItems[CurrentItem] = item
	if item == 0:
		ItemSlots[CurrentItem].visible = false
	else:
		ItemSlots[CurrentItem].visible = true
		ItemSlots[CurrentItem].texture = ItemTextures[item - 1]
	
	
