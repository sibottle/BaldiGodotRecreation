extends CharacterBody3D

var slapSpeed = 5
var speed = 0
var anger = 0
var slapTime = 0
var slapDelay = 1

@onready var agent : NavigationAgent3D = $NavigationAgent3D
@onready var sprite : AnimatedSprite3D = $AnimatedSprite3D

func ready():
	agent.target_position = player.global_transform.origin
	
func getAnger(a):
	anger += a
	if anger < 0.5: anger = 0.5
	slapDelay = -3 * anger / anger + 5
	
func _physics_process(delta):
	if slapTime <= 0: slap()
	else: slapTime -= delta
	
	if agent.is_navigation_finished():
		agent.target_position =  %NavMeshPoints.get_child(randi() % %NavMeshPoints.get_child_count()).global_transform.origin
	
	var space_state = get_world_3d().direct_space_state
	var origin = global_transform.origin
	var query = PhysicsRayQueryParameters3D.create(origin, %Player.global_transform.origin)
	query.exclude = [self]
	query.collide_with_areas = false
	var result = space_state.intersect_ray(query)
	if result && result.collider.has_meta("player"):
		agent.target_position = %Player.global_transform.origin
	
	
	var direction = agent.get_next_path_position() - global_transform.origin
	velocity = direction.normalized() * speed
	move_and_slide()

func slap():
	sprite.play("default")
	speed = slapSpeed
	slapTime = slapDelay
	await get_tree().create_timer(0.25).timeout
	speed = 0
