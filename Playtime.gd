extends CharacterBody3D

var speed = 3
var normalSpeed = 1
var runSpeed = 2
var viewDistance = 5

@onready var agent : NavigationAgent3D = $NavigationAgent3D
@onready var sprite : AnimatedSprite3D = $AnimatedSprite3D

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
	if result && origin.distance_to(%Player.global_transform.origin) < viewDistance && result.collider.has_meta("player"):
		speed = runSpeed
		agent.target_position = %Player.global_transform.origin
	else:
		speed = normalSpeed
	
	
	var direction = agent.get_next_path_position() - global_transform.origin
	velocity = direction.normalized() * speed
	move_and_slide()
