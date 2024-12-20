extends Sprite3D
var ElapsedTime : float

func _process(delta: float) -> void:
	position.y = (sin(ElapsedTime) * 0.04)
	ElapsedTime += delta
