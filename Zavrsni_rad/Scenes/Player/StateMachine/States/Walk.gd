extends PlayerState

func sm_enter(msg := {}):
	pass

func sm_process(delta):
	if player.inputDirection.is_zero_approx():
		state_machine.transition_to("Idle")
	
	elif !player.is_on_floor():
		state_machine.transition_to("InAir")
		
	elif player.isRunning:
		state_machine.transition_to("Run")
	
	
func sm_physics_process(delta):
	player.velocity.x = lerp(player.velocity.x ,player.walkSpeed * player.inputDirection.x, player.friction)
	player.velocity.z = lerp(player.velocity.z ,player.walkSpeed * player.inputDirection.z, player.friction)
	player.move_and_slide()
	
	
func sm_input(event: InputEvent):
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("InAir", {"doJump":true})
	if Input.is_action_pressed("crouch"):
		state_machine.transition_to("Crouch")

func sm_exit():
	pass
