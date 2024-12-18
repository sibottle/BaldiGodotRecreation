extends Sprite3D

var angle

@export var cam : Camera3D
# I made this based on the original script in base baldi's basics.. it's SUPER finnicky though, especially when you get too close to him, I'd appreciate if you tried fixing it up
func _process(delta: float) -> void:
	angle = atan2(cam.global_position.z - global_position.z, cam.global_position.x - global_position.x) / (PI * 2) * 16
	print(angle)
	frame =  roundi(fposmod(-angle, 16))
	pass
