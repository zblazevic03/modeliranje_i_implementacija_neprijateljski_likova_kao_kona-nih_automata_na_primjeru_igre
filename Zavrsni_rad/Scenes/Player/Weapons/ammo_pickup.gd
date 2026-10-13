extends RigidBody3D

var type := "Ammo"
@export_enum("Pistol", "Machinegun", "Rocketlauncher") var weap_name   = "Pistol"

@onready var mesh_instance_3d = $MeshInstance3D

var pickup_ready := false

func  _ready():
	match weap_name:
		"Pistol":
			mesh_instance_3d.set_mesh(load("res://3dModels/Weapon3dModel/ammo_pistol.obj"))
			
		"Machinegun":
			mesh_instance_3d.set_mesh(load("res://3dModels/Weapon3dModel/ammo_machinegun.obj"))
		
		"Rocketlauncher":
			mesh_instance_3d.set_mesh(load("res://3dModels/Weapon3dModel/ammo_rocket.obj"))
	
	await get_tree().create_timer(1).timeout
	pickup_ready = true
