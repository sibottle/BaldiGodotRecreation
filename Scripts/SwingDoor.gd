extends StaticBody3D

var openTimer = 0
var isOpen = false

@export var requiredNotebooks : int = 2

@onready var doorCollider = $Barrier
@onready var doorVisual = self.get_node("Dor")
@onready var doorVisual2 = self.get_node("Dor/e")

@onready var Audio : AudioStreamPlayer3D = $AudioStreamPlayer3D

@onready var openSound = preload("res://Audio/Sounds/Doors/swingdoor_open.wav")
@onready var NOP = preload("res://Audio/Characters/Baldi/BaldiTutor/BAL_Door.wav")

@onready var closeMaterial = preload("res://Materials/swingDoorClose.tres")
@onready var openMaterial = preload("res://Materials/swingDoorOpen.tres")

@onready var GC = get_tree().get_first_node_in_group("GC")

# Called when the node enters the scene tree for the first time.
func _ready():
	doorVisual.set_material_override(closeMaterial)
	doorVisual2.set_material_override(closeMaterial)
	doorCollider.set_deferred("disabled", false)
	GC.GetNotebook.connect(on_get_notebook)

func on_get_notebook():
	if GC.noteBookCount >= requiredNotebooks:
		$NavigationObstacle3D.avoidance_enabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isOpen:
		openTimer -= delta
		if openTimer <= 0:
			doorCollider.set_deferred("disabled", false)
			isOpen = false
			openTimer = 0
			doorVisual.set_material_override(closeMaterial)
			doorVisual2.set_material_override(closeMaterial)
	pass
	
func _physics_process(delta: float) -> void:
	for i in $Area3D.get_overlapping_bodies():
		if i.is_in_group("player"):
			if %GameController.noteBookCount >= requiredNotebooks:
				doorOpen()
				if GC.char_Baldi: GC.char_Baldi.hear(global_position, 1)
		if i.is_in_group("npc"):
			if %GameController.noteBookCount >= requiredNotebooks:
				doorOpen()

func doorOpen():
	openTimer = 5
	if isOpen: return
	doorCollider.set_deferred("disabled", true)
	isOpen = true
	doorVisual.set_material_override(openMaterial)
	doorVisual2.set_material_override(openMaterial)
	Audio.stream = openSound
	Audio.play()
	
func _on_area_3d_body_entered(body):
	print(body)
	if body.is_in_group("player"):
		if %GameController.noteBookCount >= requiredNotebooks:
			doorOpen()
			if GC.char_Baldi: GC.char_Baldi.hear(global_position, 1)
		else: 
			Audio.stream = NOP
			Audio.play()
	if body.is_in_group("npc"):
		if %GameController.noteBookCount >= requiredNotebooks:
			doorOpen()
