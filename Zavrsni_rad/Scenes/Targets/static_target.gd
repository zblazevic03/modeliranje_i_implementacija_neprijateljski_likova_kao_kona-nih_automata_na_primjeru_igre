extends StaticBody3D

var health = 3

func hit_successful(damage, _Direction := Vector3.ZERO, _Position := Vector3.ZERO):
	var hit_position = _Position - global_transform.origin
	health -= damage
	if health <= 0:
		queue_free()
