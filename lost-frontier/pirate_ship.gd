extends CharacterBody3D

@export var player: Node3D = null
@export var move_speed := 8.0
@export var shoot_interval := 1.5
@export var fire_range := 25.0
@export var detection_range := 50.0
@export var bolt_scene: PackedScene
@export var damage := 10
@export var fire_rate := 0.2
var chasing := false

func _physics_process(delta: float) -> void:
	if not chasing or player == null:
		velocity = Vector3.ZERO
		move_and_slide()
		return
		
	#get direction toward player
	var dir = (player.global_transform.origin - global_transform.origin)
	
	#stay in XZ plane
	dir.y = 0
	dir = dir.normalized()
	
	#rotate toward player
	look_at(player.global_transform.origin, Vector3.UP)
	
	#move towards player
	velocity = dir * move_speed
	move_and_slide()
	
	#called when player enters the detection range
	



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
