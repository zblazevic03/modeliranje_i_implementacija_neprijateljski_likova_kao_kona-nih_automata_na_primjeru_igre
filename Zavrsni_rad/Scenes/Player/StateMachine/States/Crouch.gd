extends PlayerState

@onready var collision_shape_3d = $"../../CollisionShape3D"


func sm_enter(msg := {}):
	collision_shape_3d.shape.height = 1

func sm_process(delta):
	pass
	
func sm_physics_process(delta):
	player.velocity.x = lerp(player.velocity.x ,.1 * player.runSpeed * player.inputDirection.x, player.friction)
	player.velocity.z = lerp(player.velocity.z ,.1 * player.runSpeed * player.inputDirection.z, player.friction)
	player.velocity.y -= player.GRAVITY
	player.move_and_slide()
	
func sm_input(event: InputEvent):
	if Input.is_action_just_released("crouch"):
		state_machine.transition_to("Idle")

func sm_exit():
	collision_shape_3d.shape.height = 2
