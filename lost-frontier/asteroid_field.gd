extends Node3D

@export var asteroid_scenes: Array[PackedScene] #array of scenes
@export var count: int = 600
@export var field_radius: float = 500.0
@export var min_scale: float = 0.001
@export var max_scale: float = 0.1

func get_random_asteroid() -> Node3D:
	var index = randi() % asteroid_scenes.size()
	return asteroid_scenes[index].instantiate()



# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	for i in range(count):
		var asteroid = get_random_asteroid()
		#random position
		var pos = Vector3(
			randf_range(-field_radius, field_radius),
			randf_range(-field_radius, field_radius),
			randf_range(-field_radius, field_radius)
		)
		asteroid.position = pos
		#random rotation
		asteroid.rotation = Vector3(
			randf_range(0, TAU),
			randf_range(0, TAU),
			randf_range(0, TAU)
		)
		
		#random scale
		var s = randf_range(min_scale, max_scale)
		asteroid.scale = Vector3(s, s, s)
		asteroid.mass = s * 10.0
		
		add_child(asteroid)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
