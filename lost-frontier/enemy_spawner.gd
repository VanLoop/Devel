extends Node3D

@export var enemy_scene: PackedScene
@export var spawn_count := 100
@export var spawn_interval := 5.0
@export var spawn_area := 5000.0         # width/length of spawn square
@export var spawn_height := 0.0          # Y = 0 for XZ plane games




# Called when the node enters the scene tree for the first time.
func _ready():
	# Spawn initial wave
	for i in range(spawn_count):
		spawn_enemy()
		
# Continuous spawns
	spawn_loop()
	
func spawn_loop() -> void:
	while true:
		await get_tree().create_timer(spawn_interval).timeout
		spawn_enemy()
		
func spawn_enemy():
	if enemy_scene == null:
		return

	var enemy = enemy_scene.instantiate()

 # Random position on the XZ plane
	var x = randf_range(-spawn_area / 3, spawn_area / 3)
	var z = randf_range(-spawn_area / 3, spawn_area / 3)

	enemy.global_position = Vector3(x, spawn_height, z)

	get_parent().add_child(enemy)
