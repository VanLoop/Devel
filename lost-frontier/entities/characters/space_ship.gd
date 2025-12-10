extends Node3D

@export var speed = 15.0
@export var rotation_speed = 2.5




# Called when the node enters the scene tree for the first time.

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

	var velocity: Vector3 = Vector3.ZERO

	translate(velocity * delta)


	# Rotation (Yaw only)
	if Input.is_action_pressed("turn_left"):
		rotate_y(-rotation_speed * delta)
	if Input.is_action_pressed("turn_right"):
		rotate_y(rotation_speed * delta)
