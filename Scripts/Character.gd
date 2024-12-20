extends CharacterBody3D

@export var viewDistance = 5
@export var speed = 5

var SeesPlayer = false

@onready var agent : NavigationAgent3D = $NavigationAgent3D

@onready var NavMeshPoints :  = get_tree().get_first_node_in_group("Nav")
@onready var Player = get_tree().get_first_node_in_group("player")
@onready var GC = get_tree().get_first_node_in_group("GC")

func ready():
	agent.target_position =  NavMeshPoints.get_child(randi() % NavMeshPoints.get_child_count()).global_transform.origin
	
	
func _physics_process(delta):
	if agent.is_navigation_finished():
		_OnWander()
	SeesPlayer = false
	var space_state = get_world_3d().direct_space_state
	var origin = global_transform.origin
	var query = PhysicsRayQueryParameters3D.create(origin, Player.global_transform.origin)
	query.exclude = [self]
	query.collide_with_areas = false
	var result = space_state.intersect_ray(query)
	if origin.distance_to(Player.global_transform.origin) < viewDistance and !result.is_empty():
		if result.get("collider").has_meta("player"):
			_OnSeePlayer()
	var direction = agent.get_next_path_position() - global_transform.origin
	velocity = direction.normalized() * speed
	move_and_slide()
	
func _OnSeePlayer():
	SeesPlayer = true
	
func _OnWander():
	agent.target_position = NavMeshPoints.get_child(randi() % NavMeshPoints.get_child_count()).global_transform.origin
	
func _OnTouchPlayer():
	print("touched")

func _on_area_3d_body_entered(body):
	if body.has_meta("player"):
		_OnTouchPlayer()
	
