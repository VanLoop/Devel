extends Node3D

@export var target: Node3D
@export var follow_speed := 5.0
@export var arm_offset := Vector3(12, 15, -12)


# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not target:
		return
	
	#smooth rig follow
	global_transform.origin = global_transform.origin.lerp(
		target.global_transform.origin, follow_speed * delta
	)
	
	# handle camera orientation/ arm with offset
	var arm = $Arm
	arm.global_transform.origin = global_transform.origin + arm_offset
	arm.look_at(global_transform.origin, Vector3.UP)
