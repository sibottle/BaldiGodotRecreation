extends CharacterBody3D

@export var viewDistance := INF
@export var speed := 5.0

@export var acceleration := INF
@export var turn_speed := INF

@export var stopped = false

var SeesPlayer := false

@onready var agent := $NavigationAgent3D

@onready var NavMeshPoints := get_tree().get_first_node_in_group("Nav")
@onready var Player := get_tree().get_first_node_in_group("player")
@onready var GC := get_tree().get_first_node_in_group("GC")

@onready var map_id = NavigationServer3D.get_maps()[0]

func _ready():
	_OnWander()
	if find_children("*", "Area3D"):
		find_children("*", "Area3D")[0].body_entered.connect(body_entered)
	
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
	
	if stopped: return
	
	var direction = agent.get_next_path_position() - global_transform.origin
	velocity = velocity.move_toward(direction.normalized() * speed,acceleration * delta)
	move_and_slide()
	global_position = NavigationServer3D.map_get_closest_point(map_id, global_position)
	
signal see_player
signal unsee_player
func _OnSeePlayer():
	if not SeesPlayer:
		SeesPlayer = true
		see_player.emit()
		
func _OnUnseePlayer():
	if see_player:
		SeesPlayer = false
		unsee_player.emit()
	
func _OnWander():
	agent.target_position = NavMeshPoints.get_child(randi() % NavMeshPoints.get_child_count()).global_transform.origin
	
func _OnTouchPlayer():
	print("touched")
	pass

func body_entered(body):
	if body.has_meta("player"):
		_OnTouchPlayer()
	
