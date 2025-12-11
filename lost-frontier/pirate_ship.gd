extends CharacterBody3D

@export var player: Node3D = null
@export var move_speed := 8.0
@export var shoot_interval := 1.5
@export var fire_range := 25.0
@export var detection_range := 50.0
@export var bolt_scene: PackedScene
@export var damage := 10
@export var health := 20
@export var fire_rate := 0.2
@onready var raycast := $RayCast3D
@onready var muzzle := $muzzle
@onready var muzzle2 := $muzzle2
@onready var shoot := $shoot
var chasing := false
var can_fire := true

func fire():
	if not can_fire:
		return
	if player == null:
		return
		
	#check if player is in range
	var dist = global_position.distance_to(player.global_position)
	if dist > fire_range:
		return
		
	can_fire = false
	
	# spqn visual bolt
	var bolt = bolt_scene.instantiate()
	bolt.global_transform = muzzle.global_transform
	shoot.play()
	get_tree().current_scene.add_child(bolt)
	
	# raycast hit
	raycast.enabled = true
	raycast.force_raycast_update()
	
	# ray collision
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider and collider.is_in_group("player"):
			if collider.has_method("apply_damage"):
				collider.apply_damage(damage)
				
	await get_tree().create_timer(fire_rate).timeout
	can_fire = true
				
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
	ScoreManager.add_points(50)
	queue_free()

func _physics_process(delta: float) -> void:
	if not chasing or player == null:
		velocity = Vector3.ZERO
		move_and_slide()
		return
	else:
		fire()
		
	#get direction toward player
	var dir = (player.global_transform.origin - global_transform.origin)
	
	#stay in XZ plane
	dir.y = 0
	dir = dir.normalized()
	
	#rotate toward player
	face_player()
	#look_at(player.global_transform.origin, Vector3.UP)
	
	
	#move towards player
	velocity = dir * move_speed
	
	# update RayCast to point at the player ship
	
	
	move_and_slide()
	fire()
	
	
	#called when player enters the detection range
func face_player():
	var to_player = player.global_transform.origin - global_transform.origin
	to_player.y = 0
	
	if to_player.length() > 0.001:
		look_at(global_transform.origin + to_player, Vector3.UP, true)



func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
			player = body
			chasing = true
			print("Player detected!! -- chasing!")


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body == player:
		chasing = false
		player = null
		print("Lost PLayer == stopping.")
