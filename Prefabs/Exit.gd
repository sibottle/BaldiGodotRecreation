extends StaticBody3D

var Ready
func _on_area_3d_body_entered(body: Node3D) -> void:
	if Ready:
		if body.is_in_group("player"):
			get_tree().change_scene_to_file("res://WinScreen.tscn")
			
func OnFinale():
	Ready = true
		
