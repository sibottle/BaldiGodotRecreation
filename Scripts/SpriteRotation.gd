extends Sprite3D

var angle

@export var cam : Camera3D
	
func delta_angle(no_1, no_2):
	var angle = abs(no_1 - no_2)
	if angle > 90.0:
		return 180.0 - angle
	return angle
	
# I made this based on the original script in base baldi's basics.. it's SUPER finnicky though, especially when you get too close to him, I'd appreciate if you tried fixing it up
func _process(delta: float) -> void:
	angle = (atan2(cam.global_position.z - global_position.z, cam.global_position.x - global_position.x) + global_rotation.y) / (PI * 2) * 16
	frame = roundi(-angle+12) % 16
	pass
