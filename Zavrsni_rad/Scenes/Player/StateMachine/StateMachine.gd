class_name StateMachine
extends Node


signal transitioned(State_name)

@export var initial_state := NodePath()
@onready var state = get_node(initial_state)


func _ready():
	await owner.ready
	for child in get_children():
		child.state_machine = self
	state.sm_enter()
	
func _unhandled_input(event):
	state.sm_input(event)
	
func _process(delta):
	state.sm_process(delta)

func _physics_process(delta):
	state.sm_physics_process(delta)
	
func transition_to(new_state: String, msg: Dictionary = {}):
	assert(has_node(new_state), "Stanje nije pronađeno, pogeldajte da li je točno implemntirano")
	state.sm_exit()
	state = get_node(new_state)
	state.sm_enter(msg)
	emit_signal("transitioned", new_state)
	
	
	
	
	
	
	
	
