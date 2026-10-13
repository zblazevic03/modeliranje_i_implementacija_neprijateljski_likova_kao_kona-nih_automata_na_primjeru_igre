extends Area3D

func _on_body_entered(body):
	if body is Player: 
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene_to_file("res://Menu/you_win_menu.tscn")
