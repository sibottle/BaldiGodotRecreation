extends StaticBody3D

var openTimer = 0
var isOpen = false

@onready var doorCollider = get_node("DoorCollision")
@onready var doorVisual = self.get_node("Dorr")
@onready var doorVisual2 = self.get_node("Dorr/Dorr")

@onready var closeMaterial
@onready var openMaterial

@onready var SoundPlayer = $AudioStreamPlayer3D

@onready var openSound = preload("res://Audio/door_open.wav")
@onready var closeSound = preload("res://Audio/door_close.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	doorCollider.disabled = false
	set_meta("blueDoor",true)
	if has_meta("faculty"):
		closeMaterial = preload("res://Materials/closedDoorFaculty.tres")
		openMaterial = preload("res://Materials/openDoorFaculty.tres")
	else:
		closeMaterial = preload("res://Materials/closedDoor.tres")
		openMaterial = preload("res://Materials/openDoor.tres")
	doorVisual.set_material_override(closeMaterial)
	doorVisual2.set_material_override(closeMaterial)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isOpen:
		openTimer -= delta
		if openTimer <= 0:
			doorCollider.disabled = false
			isOpen = false
			openTimer = 0
			doorVisual.set_material_override(closeMaterial)
			doorVisual2.set_material_override(closeMaterial)
			var player = AudioStreamPlayer3D.new()
			add_child(player)
			player.stream = closeSound
			player.play()
	pass

func doorOpen():
	if isOpen: pass
	else:
		doorCollider.set_deferred("disabled", true)
		isOpen = true
		openTimer = 3
		doorVisual.set_material_override(openMaterial)
		doorVisual2.set_material_override(openMaterial)
	
		SoundPlayer.stream = openSound
		SoundPlayer.play()
	
func _on_area_3d_area_entered(area):
	if area.is_in_group("npc"):
		doorOpen()
