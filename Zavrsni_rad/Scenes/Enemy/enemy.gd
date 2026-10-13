extends CharacterBody3D

@onready var animation_player = $enemyExample/AnimationPlayer
@onready var enemy_prijectile = preload("res://Scenes/Enemy/enemy_projectile.tscn")

var damage := 1
var speed := 0.0
var health :=5
var projectile_velocity  := 15
var origin_position: Vector3

enum {IDLE, ROAM, ATTACK}

var detectedPlayer : Player
var vel
var roamDistance := 5


var currentState = IDLE:
	set(value):
		currentState = value
		match value:
			IDLE:
				animation_player.play("Idle")
				speed = 0.001
				$moveTimer.start()
			ROAM: 
				animation_player.play("Walk")
				speed = 5.5

			ATTACK:
				var direction = (detectedPlayer.global_position - $enemyExample/bulletPoint.global_position).normalized()
				$enemyExample/Armature.rotation.y = atan2(direction.x, direction.z)
				animation_player.play("Attacking")
				await animation_player.animation_finished
				
				var nBullet = enemy_prijectile.instantiate()
				get_parent().add_child(nBullet)
				nBullet.global_position = $enemyExample/bulletPoint.global_position
				
				nBullet.damage = damage
				nBullet.set_linear_velocity(direction * projectile_velocity)
				nBullet.look_at(detectedPlayer.global_position, Vector3.UP,true)
				$DetectPlayerArea/CollisionShape3D.disabled = true
				$DetectPlayerArea/CollisionShape3D.disabled = false
				$moveTimer.start()

func _ready():
	origin_position = global_position
	$moveTimer.start()

func  _physics_process(delta):
	if !is_on_floor():
		velocity.y -= 100
		move_and_slide()
		return
		
	vel = Vector3.ZERO

	var target = $NavigationAgent3D.get_next_path_position()
	var pos = global_transform.origin
	var n = $RayCast3D.get_collision_normal()
	if n.length_squared() < 0.001:
		n = Vector3.UP 

	vel = (target - pos).slide(n).normalized() * speed

	if currentState == ATTACK:
		var attack_direction = (detectedPlayer.global_position - global_position).normalized()
		$enemyExample/Armature.rotation.y = lerp_angle(
		$enemyExample/Armature.rotation.y,
			atan2(attack_direction.x, attack_direction.z),
			delta * 10
		)
	else:
		if vel != Vector3.ZERO and vel.length() > 0.1: 
			var move_direction_angle = atan2(vel.x, vel.z)
			$enemyExample/Armature.rotation.y = lerp_angle(
				$enemyExample/Armature.rotation.y,
				move_direction_angle,
				delta * 10
			)
	if currentState != ATTACK:
		velocity = vel  
		move_and_slide()  
	else:
		$NavigationAgent3D.set_velocity(Vector3.ZERO)  
		move_and_slide()
	
func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	set_velocity(safe_velocity)


func _on_navigation_agent_3d_navigation_finished():
	currentState = IDLE


func _on_move_timer_timeout():
	var sphere_point = get_random_pos_insphere(roamDistance)
	move_to(sphere_point)

func move_to(target_pos):
	currentState = ROAM
	var clossest_pos = NavigationServer3D.map_get_closest_point(get_world_3d().get_navigation_map(), target_pos)
	$NavigationAgent3D.set_target_position(clossest_pos)


	
func  get_random_pos_insphere(radius: float) -> Vector3:
	var x1= randi_range(-1, 1)
	var x2= randi_range(1, -1)
	
	while  x1*x1 + x2*x2 >=1:
		x1 = randi_range(-1, 1)
		x2= randi_range(1, -1)
	
	var random_pos_on_unit_sphere = Vector3(
		1 - 2 * (x1*x2 + x2*x2),
		0, 
		1 - 2 * (x1*x2 + x2*x2))
		
	random_pos_on_unit_sphere.x *= randi_range(-radius, radius)
	random_pos_on_unit_sphere.z *= randi_range(-radius, radius)
	
	return random_pos_on_unit_sphere
	
	
func _on_detect_player_area_body_entered(body):
	if body is Player:
		$moveTimer.stop()
		detectedPlayer = body
		currentState = ATTACK


func _on_detect_player_area_body_exited(body):
	if body is Player:
		currentState = ROAM
		_on_move_timer_timeout()
		var sphere_point = get_random_pos_insphere(roamDistance)
		move_to(sphere_point)
	
	
func hit_successful(damage, _Direction := Vector3.ZERO, _Position := Vector3.ZERO):
	var hit_position = _Position - global_transform.origin
	health -= damage
	if health <= 0:
		queue_free()
