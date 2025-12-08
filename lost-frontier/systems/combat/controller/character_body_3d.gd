extends CharacterBody3D

@export var speed = 15.0
@export var rotation_speed = 2.5
@onready var camera := get_viewport().get_camera_3d()
@onready var left_thrusters = $left_thrusters
@onready var right_thrusters = $right_thrusters
@onready var warning = get_node("../ui/warning_label")
@export var bolt_scene: PackedScene
@export var fire_rate := 0.2
@export var damage := 15

var can_fire := true
var max_distance = 1000.0

func play_muzzle_flash():
	$muzzle_flash.visible = true
	await get_tree().create_timer(0.05).timeout
	$muzzle_flash.visible = false

func fire():
	if not can_fire: return
	can_fire = false
	
	# create visual bolt
	var bolt = bolt_scene.instantiate()
	var bolt1 = bolt_scene.instantiate()
	bolt.global_transform = $Marker3D.global_transform
	bolt1.global_transform = $Muzzle.global_transform
	play_muzzle_flash()
	get_tree().current_scene.add_child(bolt)
	get_tree().current_scene.add_child(bolt1)
	
	# raycast hit direction
	$RayCast3D.enabled = true
	var ray = $RayCast3D
	ray.force_raycast_update()
	
	if ray.is_colliding():
		var collider = ray.get_collider()
		var pos = ray.get_collision_point()
		var normal = ray.get_collision_normal()
		
		if collider.has_method("apply_damage"):
			collider.apply_damage(damage)
		
		#spawn impact effect
		spawn_hit_effect(pos, normal)
		
	#play sound
	#$AudioStreamPlayer3D.play()
	
	#cooldown
	await get_tree().create_timer(fire_rate).timeout
	can_fire = true
	
func spawn_hit_effect(pos, normal):
	# hook particle effect here
	pass

func set_thrusters_emitting(group: Node, is_on: bool):
	for thruster in group.get_children():
		thruster.emitting = is_on

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
#function to fire the ship lasers



func _physics_process(delta):
	var input_vector = Vector3.ZERO
	var left_on = false
	var right_on = false

	# Move forward/backward
	if Input.is_action_pressed("move_forward"):
		input_vector.z -= 1
		left_on = true
		right_on = true
		
		
	if Input.is_action_pressed("move_backward"):
		input_vector.z += 1

	# Strafe left/right
	if Input.is_action_pressed("move_left"):
		input_vector.x += 1
		right_on = true
		
	if Input.is_action_pressed("move_right"):
		input_vector.x -= 1
		left_on = true
		
	set_thrusters_emitting(left_thrusters, left_on)
	set_thrusters_emitting(right_thrusters, right_on)
		

	# Convert input to local space
	var direction = -transform.basis.z * input_vector.z \
					+ transform.basis.x * input_vector.x

	velocity = direction.normalized() * speed
	move_and_slide()
	
	rotate_toward_mouse(delta)
	
	# max distance warning
	var dist := global_position.length()
	if dist > (max_distance - 300) and dist < max_distance:
		warning.visible = true
	else:
		warning.visible = false
	
	# maximum distance lock
	if global_position.length() > max_distance:
		global_position = global_position.normalized() * max_distance
	
	if Input.is_action_pressed("shoot"):
		fire()
	# Rotation (Yaw only)
	if Input.is_action_pressed("turn_left"):
		rotate_y(-rotation_speed * delta)
	if Input.is_action_pressed("turn_right"):
		rotate_y(rotation_speed * delta)
