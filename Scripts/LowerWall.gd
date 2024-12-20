extends Node3D


@export var MapWall : MeshInstance3D
@export var Map : Material
@onready var GC = %GameController

func lower(finale : bool):
	position.y = -1
	if finale:
		MapWall.set_material_override(Map)
		GC.OnExitReached()
	
func raise():
	position.y = 0

func _on_begin_spoop_mode() -> void:
	lower(false)
	
func _OnFinale():
	raise()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if (GC.Finalemode and GC.ExitsReached < 3 and body.is_in_group("player")):
		lower(true)
