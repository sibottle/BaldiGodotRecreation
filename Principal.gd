extends CharacterBody3D

var speed = 3
var normalSpeed = 2
var runSpeed = 3
var guiltSeen = 0
var angry = false
var seeingGuilt = false

@onready var spawnPos = global_transform.origin

@onready var agent : NavigationAgent3D = $NavigationAgent3D
@onready var Aud : AudioStreamPlayer3D = $AudioStreamPlayer3D

func ready():
	agent.target_position =  %NavMeshPoints.get_child(randi() % %NavMeshPoints.get_child_count()).global_transform.origin
	
	
func _physics_process(delta):
	if agent.is_navigation_finished():
		agent.target_position =  %NavMeshPoints.get_child(randi() % %NavMeshPoints.get_child_count()).global_transform.origin
	
	var space_state = get_world_3d().direct_space_state
	var origin = global_transform.origin
	var query = PhysicsRayQueryParameters3D.create(origin, %Player.global_transform.origin)
	query.exclude = [self]
	query.collide_with_areas = false
	var result = space_state.intersect_ray(query)
	if result && result.collider.has_meta("player"):
		if %Player.running:
			guiltSeen += delta
			seeingGuilt = true
	
	if guiltSeen > 0.5:
		angry = true
	if guiltSeen > 0 && !seeingGuilt:
		guiltSeen -= delta
	seeingGuilt = false
		
	if angry:
		speed = runSpeed
		agent.target_position = %Player.global_transform.origin
		if origin.distance_to(%Player.global_transform.origin) < 0.5:
			catch()
	else:
		speed = normalSpeed
	
	var direction = agent.get_next_path_position() - global_transform.origin
	velocity = direction.normalized() * speed
	move_and_slide()

func catch():
	%Player.global_transform.origin = spawnPos
	angry = false
	guiltSeen = 0
