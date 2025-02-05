extends Control

@onready var spin_box = $VBoxContainer/SpinBox
@onready var confirm_button = $VBoxContainer/ConfirmButton

var selected_character_count = 1  # Default to 1



func _on_confirm_button_pressed() -> void:
	selected_character_count = int(spin_box.value)
	print("Selected characters:", selected_character_count)
	
	# Store the selected character count globally
	Global.selected_character_count = selected_character_count
	
	# Load the dice selection scene
	get_tree().change_scene_to_file("res://character_dice_selection.tscn")
