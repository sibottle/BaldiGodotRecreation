extends CharacterBody3D

class_name player

@export var SPEED = 1
@export var RUNSPEED = 1.6
const JUMP_VELOCITY = 1
const MOUSE_SENS = 0.01

var jumprope = false
var running = false

var stamina = 100

@onready var cam = get_node("Camera3D")
@export var ItmManager : ItemSelector

func ItemRay(item : int):
		var space_state = get_world_3d().direct_space_state
		var mousepos = get_viewport().get_mouse_position()
		var origin = cam.project_ray_origin(mousepos)
		var end = origin + cam.project_ray_normal(mousepos)
		var query = PhysicsRayQueryParameters3D.create(origin, end)
		query.exclude = [self]
		query.collide_with_areas = true
		
		var result = space_state.intersect_ray(query)
		match item:
			5:
				if result && result.collider.is_in_group("VendingMachine"):
					ItmManager.CollectItem(result.collider.get_meta("ID"))
				#if result && result.collider.is_in_group("Payphone"):
					#ItmManager.CollectItem(0)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENS)
		

func _physics_process(delta):
	# Add the gravity.
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	if jumprope:
		velocity.x = 0
		velocity.z = 0
		if Input.is_action_pressed("look_back") && is_on_floor():
			velocity.y = JUMP_VELOCITY
	else:
		cam.basis = Basis(Vector3.UP, PI if Input.is_action_pressed("look_back") else 0.0)
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("left", "right", "forward", "back")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			var speed = SPEED
			if Input.is_action_pressed("run") and stamina > 0:
				running = true
				stamina -= 0.2
				speed = RUNSPEED
				if stamina <= 0:
					stamina = -5
			else:
				running = false
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			running = false
			if stamina < 100:
				stamina += 0.2
			velocity.x = 0
			velocity.z = 0
		
	if Input.is_action_just_pressed("interact"):
		var space_state = get_world_3d().direct_space_state
		var mousepos = get_viewport().get_mouse_position()
		var origin = cam.project_ray_origin(mousepos)
		var end = origin + cam.project_ray_normal(mousepos)
		var query = PhysicsRayQueryParameters3D.create(origin, end)
		query.exclude = [self]
		query.collide_with_areas = true

		var result = space_state.intersect_ray(query)
		
		if result && result.collider.get_parent().has_meta("blueDoor"):
			result.collider.get_parent().doorOpen()
		if result && result.collider.is_in_group("notebook"):
			result.collider.Collect()
		if result && result.collider.is_in_group("Item"):
			ItmManager.CollectItem(result.collider.get_meta("ID"))
			result.collider.queue_free()
			
	move_and_slide()
