extends Node



func _on_level_pressed():
	get_tree().change_scene_to_file("res://Scenes/level.tscn")
	

func _on_shoot_down_pressed():
	get_tree().quit()
