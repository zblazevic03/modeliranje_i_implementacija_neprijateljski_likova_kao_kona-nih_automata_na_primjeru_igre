extends PlayerState

func sm_enter(msg := {}):
	if msg.has("doJump"):
		player.velocity.y = 0
		player.velocity.y += player.JUMP
	
	pass

func sm_process(delta):
	if player.is_on_floor():
		state_machine.transition_to("Idle")
	
	pass
	
func sm_physics_process(delta):
	player.velocity.x = lerp(player.velocity.x ,player.runSpeed * player.inputDirection.x, player.friction)
	player.velocity.z = lerp(player.velocity.z ,player.runSpeed * player.inputDirection.z, player.friction)
	
	
	player.velocity.y -= player.GRAVITY
	player.move_and_slide()
	
func sm_input(event: InputEvent):
	pass	

func sm_exit():
	pass
