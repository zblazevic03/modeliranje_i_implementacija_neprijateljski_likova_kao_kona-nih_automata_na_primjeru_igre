class_name Player
extends CharacterBody3D

@onready var camera_3d = $Camera3D
@onready var origCamPos : Vector3 = camera_3d.position
@onready var health_label = $CanvasHUD/Debug/HBoxContainer4/healthLabel  

var health = 10

const JUMP := 30.0
const GRAVITY := 2
const walkSpeed := 10
const runSpeed := 20
const friction := 0.15

var inputDirection := Vector3.ZERO

var distanceFootstep := 0.0 
var playFootstep := true
var isRunning := false

var mouse_sens := 0.1

@onready var bullet_point = %bullet_point


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	update_health_label() 

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		camera_3d.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	
	
	inputDirection = Vector3.ZERO
	inputDirection.x = Input.get_axis("move_left", "move_right")
	inputDirection.z = Input.get_axis("move_front", "move_back")
	inputDirection = inputDirection.rotated(Vector3.UP, rotation.y).normalized()

	
	if Input.is_action_just_pressed("ran"):
		isRunning = true
		
	if Input.is_action_just_released("ran"):
		isRunning = false
	
	if Input.is_action_just_pressed("jump"):
		$Sounds/Jump.play()
		
	if Input.is_action_just_pressed("game_exit"):
		get_tree().quit()
		
func _process(delta):
	if (!is_zero_approx(inputDirection.x) || !is_zero_approx(inputDirection.z) and is_on_floor()):
		distanceFootstep += .1
	
func hit_successful(damage, _Direction := Vector3.ZERO, _Position := Vector3.ZERO):
	health -= damage
	update_health_label()
	
	if health <= 0:
		queue_free()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene_to_file("res://Menu/game_over_menu.tscn")
		
func update_health_label():
	health_label.text = str(health)
