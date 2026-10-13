extends CanvasLayer
@onready var curr_weap_label = $Debug/HBoxContainer/currWeapLabel
@onready var ammo_label = $Debug/HBoxContainer2/ammoLabel
@onready var wp_stack_label = $Debug/HBoxContainer3/wpStackLabel



func _on_wapons_manager_update_ammo(Ammo):
	ammo_label.set_text(str(Ammo[0]) + "/" +str(Ammo[1]))


func _on_wapons_manager_update_weapon_stack(weapon_stack):
	wp_stack_label.set_text("")
	for i in weapon_stack:
		wp_stack_label.text += "\n" +i


func _on_wapons_manager_weapon_changed(weapon_name):
	curr_weap_label.set_text(weapon_name)
