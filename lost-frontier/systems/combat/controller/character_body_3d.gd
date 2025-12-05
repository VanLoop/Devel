extends CharacterBody3D

@export var speed = 15.0
@export var rotation_speed = 2.5
@onready var camera := get_viewport().get_camera_3d()

func rotate_toward_mouse(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 2000
	
	#create a virtual horizontal plane at the ship height y = globalposition
	var plane = Plane(Vector3.UP, -global_position.y)
	var hit_pos = plane.intersects_ray(from, to)
	
	if hit_pos:
		#var dir = (hit_pos - global_position).normalized()
		#var look_at_pos = global_position + dir
		#look_at(look_at_pos, Vector3.UP)
		var dir = (hit_pos - global_position)
		dir.y = 0
		dir = dir.normalized()
		
		# rotate only around Y-axis
		#var target_rotation = atan2(dir.x, dir.z)
		#rotation.y = target_rotation
		
		# rotate only aroun Y smoother
		var target_yaw = atan2(dir.x, dir.z)
		rotation.y = lerp_angle(rotation.y, target_yaw, 8.0 * delta)

func _physics_process(delta):
	var input_vector = Vector3.ZERO

	# Move forward/backward
	if Input.is_action_pressed("move_forward"):
		input_vector.z -= 1
	if Input.is_action_pressed("move_backward"):
		input_vector.z += 1

	# Strafe left/right
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1

	# Convert input to local space
	var direction = -transform.basis.z * input_vector.z \
					+ transform.basis.x * input_vector.x

	velocity = direction.normalized() * speed
	move_and_slide()
	
	rotate_toward_mouse(delta)

	# Rotation (Yaw only)
	if Input.is_action_pressed("turn_left"):
		rotate_y(-rotation_speed * delta)
	if Input.is_action_pressed("turn_right"):
		rotate_y(rotation_speed * delta)
