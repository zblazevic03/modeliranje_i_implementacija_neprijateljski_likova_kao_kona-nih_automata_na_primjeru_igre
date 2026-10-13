extends Node3D

@onready var animation_player = $FPS_Rig/AnimationPlayer
@onready var bullet_point = $FPS_Rig/bullet_point
@onready var BulletShot = preload("res://Scenes/Player/Weapons/bullet_shot.tscn")

@onready var WP_Pickup = preload("res://Scenes/Player/Weapons/weapon_pickup.tscn")
var current_weapon = null
var weapon_stack = [] #drži oružija koja igrač iam
var next_weapon : String
var weapon_list = {} #prati sva dostupna oružija
@export var _weapon_resources : Array[WeaponResource]
@export var start_weapons : Array[String]

enum {NULL, HITSCAN, PROJECTILE}

signal weapon_changed
signal update_ammo
signal update_weapon_stack

var collision_exclusion = [] #Lansoranje projektila

func _ready():
	initialize(start_weapons)
	
func _input(event):
	if event.is_action_pressed("weapon_up"):
		var getRef = weapon_stack.find(current_weapon.weapon_name)
		getRef = min(getRef+1, weapon_stack.size()-1)
		exit(weapon_stack[getRef])
	
	if event.is_action_pressed("weapon_down"):
		var getRef = weapon_stack.find(current_weapon.weapon_name)
		getRef = max(getRef -1, 0)
		exit(weapon_stack[getRef])
		
	if event.is_action_pressed("shoot"):
		shoot()
		
	if event.is_action_pressed("reload"):
		reload()
		
	if event.is_action_pressed("drop"):
		drop(current_weapon.weapon_name)
		
		
	
func initialize(start_weapons : Array):
	for weapon in _weapon_resources:
		weapon_list[weapon.weapon_name]  = weapon
	
	for i in start_weapons:
		weapon_stack.push_back(i)
		
	current_weapon = weapon_list[weapon_stack[0]]
	emit_signal("update_weapon_stack", weapon_stack)
	enter()
	
	
func enter():
	animation_player.queue(current_weapon.activate_anim)
	emit_signal("weapon_changed", current_weapon.weapon_name)
	emit_signal("update_ammo", [current_weapon.current_ammo, current_weapon.reserve_ammo])
	
func exit(_next_weapon : String):
	if _next_weapon != current_weapon.weapon_name:
		if animation_player.get_current_animation() != current_weapon.deactivate_anim:
			animation_player.play(current_weapon.deactivate_anim)
			next_weapon = _next_weapon


func _on_animation_player_animation_finished(anim_name):
	if anim_name == current_weapon.deactivate_anim:
		change_weapon(next_weapon)
	
	if anim_name == current_weapon.shoot_anim and current_weapon.auto_fire:
		if Input.is_action_pressed("shoot"):
			shoot()


func change_weapon(weapon_name : String):
	current_weapon = weapon_list[weapon_name]
	next_weapon = ""
	enter()

func shoot():
	if current_weapon.current_ammo != 0:
		if !animation_player.is_playing():
			animation_player.play(current_weapon.shoot_anim)
			current_weapon.current_ammo -= 1
			emit_signal("update_ammo", [current_weapon.current_ammo, current_weapon.reserve_ammo])
			$"../../Sounds/ShootSound".play()
			
			var camera_collision = get_camera_collision()
			match  current_weapon.type:
				NULL:
					print("tip oruzija nije odabran")
				
				HITSCAN:
					hitscan_collision(camera_collision)
				
				PROJECTILE:
					launch_projectile(camera_collision)
	else:
		reload()



func hitscan_collision(collision_point):
	var bullet_direction = (collision_point - bullet_point.get_global_transform().origin).normalized()
	var new_intersection = PhysicsRayQueryParameters3D.create(bullet_point.get_global_transform().origin, collision_point + bullet_direction * 2)
	var bullet_collision = get_world_3d().direct_space_state.intersect_ray(new_intersection)
	
	if bullet_collision:
		var hit_indc = BulletShot.instantiate()
		var world = get_tree().get_root().get_child(0)
		world.add_child(hit_indc)
		hit_indc.global_translate(bullet_collision.position) 
		hitscan_damage(bullet_collision.collider, bullet_direction, bullet_collision.position)
		
func  hitscan_damage(collider, direction, collider_position):
	if collider.is_in_group("Target") and collider.has_method("hit_successful"):  
		collider.hit_successful(current_weapon.damage, direction, collider_position)	
	
	
	
func launch_projectile(point : Vector3):
	var direction = (point - bullet_point.global_transform.origin).normalized()
	var projectile = current_weapon.projectile_to_load.instantiate()
	var projectile_RID = projectile.get_rid()
	collision_exclusion.push_back(projectile_RID)
	projectile.tree_exited.connect(remove_exclusion.bind(projectile.get_rid()))
	
	bullet_point.add_child(projectile)
	projectile.damage = current_weapon.damage
	projectile.set_linear_velocity(direction * current_weapon.projectile_velocity)
	
	
func remove_exclusion(projectile_rid):
	collision_exclusion.erase(projectile_rid)
	
func reload():
	if current_weapon.current_ammo == current_weapon.magazine:
		return
	elif !animation_player.is_playing():
		if current_weapon.reserve_ammo != 0:
			animation_player.play(current_weapon.reload_anim)
			
			var reload_amount = min(current_weapon.magazine - current_weapon.current_ammo, current_weapon.magazine, current_weapon.reserve_ammo)
			current_weapon.current_ammo += reload_amount
			current_weapon.reserve_ammo -= reload_amount
			emit_signal("update_ammo", [current_weapon.current_ammo, current_weapon.reserve_ammo])
			$"../../Sounds/Reload".play()
		else:
			$"../../Sounds/NotEnoughtAmmo".play()
			
			

func get_camera_collision() -> Vector3:
	var camera = get_viewport().get_camera_3d()
	var viewport = get_viewport().get_size()
	
	var ray_origin = camera.project_ray_origin(viewport/2)
	var ray_end = ray_origin + camera.project_ray_normal(viewport/2) * current_weapon.weapon_range
	
	var new_intersection = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	new_intersection.set_exclude(collision_exclusion)
	
	
	var intersection = get_world_3d().direct_space_state.intersect_ray(new_intersection)
	
	if not intersection.is_empty():
		var col_point = intersection.position
		return col_point
	
	else:
		return ray_end
	
func _on_pickup_area_body_entered(body):
	if body.is_in_group("PickupGroup"):
		if body.type == "Weapon" and body.pickup_ready:
			var weapon_in_stack = weapon_stack.find(body.weap_name, 0)
			if weapon_in_stack == -1:
				var getRef = weapon_stack.find(current_weapon.weapon_name)
				weapon_stack.insert(getRef, body.weap_name)
				emit_signal("update_weapon_stack", weapon_stack)
				exit(body.weap_name)
				body.queue_free()
			elif  add_ammo(body.weap_name, weapon_list[body.weap_name].magazine):
				body.queue_free()
		elif body.type == "Ammo" and body.pickup_ready:
			if add_ammo(body.weap_name, weapon_list[body.weap_name].magazine):
				body.queue_free() 
				
func add_ammo(_name,  ammo) -> bool:
	var required = weapon_list[_name].max_ammo - weapon_list[_name].reserve_ammo
	if required > 0:
		var remaining = max(ammo, required, 0)
		weapon_list[_name].reserve_ammo += min(ammo, required)
		emit_signal("update_ammo", [current_weapon.current_ammo, current_weapon.reserve_ammo])
	return required > 0


func drop(_name : String):
	if weapon_stack.size() > 1:
		var weapon_ref = weapon_stack.find(_name, 0)
		if weapon_ref != -1:
			weapon_stack.pop_at(weapon_ref)
			emit_signal("update_weapon_stack", weapon_stack)
			var weapon_dropped = WP_Pickup.instantiate()
			if weapon_dropped.has_method("set_weapon_name"):
				weapon_dropped.set_weapon_name(_name) 
			else:
				weapon_dropped.weap_name = _name
			var world = get_tree().get_root().get_child(1)
			world.add_child(weapon_dropped)
			weapon_dropped.global_transform = bullet_point.global_transform
			var getRef = weapon_stack.find(current_weapon.weapon_name)
			getRef = max(getRef - 1, 0)  
			exit(weapon_stack[getRef])
