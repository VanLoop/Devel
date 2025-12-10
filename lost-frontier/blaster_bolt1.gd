extends Node3D

@export var speed := 60.0 #adjust for visual speed
@export var lifetime := 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(lifetime).timeout
	queue_free()


func _physics_process(delta):
	translate(Vector3.FORWARD * speed * delta)
