extends Control

func _ready() -> void:
	pass

func _on_confirm_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/character_dice_selection.tscn")

func _on_spin_box_value_changed(value: float) -> void:
	Global.selected_character_count = value
