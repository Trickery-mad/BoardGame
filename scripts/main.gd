extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # You can add initialization code here if needed.

# Function connected to the StartButton's "pressed" signal
func _on_start_pressed()-> void:
	get_tree().change_scene_to_file("res://scenes/character_selection.tscn")
