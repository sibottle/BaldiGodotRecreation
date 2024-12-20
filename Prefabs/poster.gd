extends StaticBody3D


@onready var Front : MeshInstance3D = get_node("Front")
@export var Poster : Material
func _ready():
	Front.set_material_override(Poster)
