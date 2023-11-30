extends StaticBody3D

var openTimer = 0
var isOpen = false

@export var requiredNotebooks : int = 2

@onready var doorCollider = $Barrier
@onready var doorVisual = self.get_node("Dor")
@onready var doorVisual2 = self.get_node("Dor/e")

@onready var closeMaterial = preload("res://Materials/swingDoorClose.tres")
@onready var openMaterial = preload("res://Materials/swingDoorOpen.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	doorVisual.set_material_override(closeMaterial)
	doorVisual2.set_material_override(closeMaterial)
	doorCollider.set_deferred("disabled", false)

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

func doorOpen():
	openTimer = 5
	if isOpen: return
	doorCollider.set_deferred("disabled", true)
	isOpen = true
	doorVisual.set_material_override(openMaterial)
	doorVisual2.set_material_override(openMaterial)
	
	

func _on_area_3d_body_entered(body):
	if body.has_meta("player"):
		if %GameController.noteBookCount >= requiredNotebooks:
			doorOpen()


func _on_area_3d_area_entered(area):
	if area.is_in_group("npc"):
		doorOpen()
