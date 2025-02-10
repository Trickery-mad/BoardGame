extends Control


@onready var health_result = $Control/HealthResult
@onready var roll_health_button = $Control/RollHealthButton
@onready var health_label = $Control/HealthLabel
@onready var confirm_button = $Control/ConfirmButton
@onready var warning_label = $Control/ConfirmButton/WarningLabel

var rolled_health = []
var buttongroup1 = ButtonGroup.new()
var buttongroup2 = ButtonGroup.new()
var selectedAttackValue = 0
var selectedDefenseValue = 0
var remainingHealthRoll = 3
var rolledHealth = 0

func _ready():
	warning_label.visible = false
	confirm_button.disabled = true
	var arr = get_children()
	for button in arr[0].get_children():
		if button is Button :
			if button.name.begins_with("a_"):
				button.button_group = buttongroup1
				button.connect("pressed", dice_pressed.bind(button))
			if button.name.begins_with("d_"):
				button.button_group = buttongroup2
				button.connect("pressed", dice_pressed.bind(button))

func roll_health():	
	rolled_health = [randi_range(1, 20), randi_range(1, 20), randi_range(1, 20)]
	rolled_health.sort()
	health_result.text = "Your health is %d (%d, %d)" % [rolled_health[2], rolled_health[1], rolled_health[0]]
	rolledHealth = rolled_health[2]
	remainingHealthRoll -= 1
	health_label.text = "Remaining Roll: %d" % remainingHealthRoll
	if remainingHealthRoll <= 0:
		roll_health_button.disabled = true
		health_label.text = "You do not have any remaining rolls :D "
		return
	
func _input(event):
	if(rolledHealth != 0 and ((selectedAttackValue != 0 and selectedDefenseValue != 0) or selectedAttackValue + selectedDefenseValue == 20)):
		confirm_button.disabled = false
	else:
		confirm_button.disabled = true

func _on_roll_health_button_pressed() -> void:
	roll_health()
	
func dice_pressed(button : Button) -> void:
	if button.button_group == buttongroup1:
		for btn in buttongroup1.get_buttons():
			btn.modulate = Color(1, 1, 1)
		selectedAttackValue = Global.get_number_accordingto_dice(button.name)
		for btn in buttongroup2.get_buttons():
			if(Global.get_number_accordingto_dice(btn.name) + selectedAttackValue > 20):
				if(selectedDefenseValue == Global.get_number_accordingto_dice(btn.name)):
					selectedDefenseValue = 0
					btn.modulate = Color(1,1,1)
	elif button.button_group == buttongroup2:
		for btn in buttongroup2.get_buttons():
			btn.modulate = Color(1, 1, 1)
		selectedDefenseValue = Global.get_number_accordingto_dice(button.name)
		for btn in buttongroup1.get_buttons():
			if(Global.get_number_accordingto_dice(btn.name) + selectedDefenseValue > 20):
				if(selectedAttackValue == Global.get_number_accordingto_dice(btn.name)):
					selectedAttackValue = 0
					btn.modulate = Color(1,1,1)
	button.modulate = Color(0, 1, 0)


func _on_confirm_button_mouse_entered() -> void:
	if(confirm_button.disabled):
		warning_label.visible = true

func _on_confirm_button_mouse_exited() -> void:
	if(confirm_button.disabled):
		warning_label.visible = false

func _on_confirm_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/encounter_scene.tscn")
