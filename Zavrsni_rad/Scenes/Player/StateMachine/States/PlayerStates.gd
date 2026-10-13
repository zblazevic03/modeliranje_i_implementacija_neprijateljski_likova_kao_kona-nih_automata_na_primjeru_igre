class_name  PlayerState
extends  StateSM

var player : Player

func _ready():
	await  owner.ready
	player = owner as Player
	assert(player != null, "Varijabla igrač nije pronađena")
	


func _process(delta):
	pass
