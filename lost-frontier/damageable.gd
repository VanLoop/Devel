extends RigidBody3D

@export var max_health: int = 50
var health: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = max_health
	
func apply_damage(amount: int):
	health -= amount
	print(name," took: ", amount, " damage. Remaining: ", health)
	if health <= 0:
		die()
		
func die():
	#spawn explosion
	var explosion = preload("res://explosion.tscn").instantiate()
	explosion.global_transform = global_transform
	get_parent().add_child(explosion)
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
