extends Control

@onready var health_result = $HealthResult
@onready var roll_health_button = $RollHealthButton
@onready var health_label = $HealthLabel
@onready var confirm_button = $ConfirmButton
@onready var warning_label = $ConfirmButton/WarningLabel
@onready var charTexture = $CharacterTexture

var images = {
	"a4d4": preload("res://assets/a4d4.jpg"),
	#"a4d6": preload("res://assets/a4d6.jpg"),
	#"a4d8": preload("res://assets/a4d8.jpg"),
	#"a4d10": preload("res://assets/a4d10.jpg"),
	#"a4d12": preload("res://assets/a4d12.jpg"),

	"a6d4": preload("res://assets/a6d4.jpg"),
	#"a6d6": preload("res://assets/a6d6.jpg"),
	#"a6d8": preload("res://assets/a6d8.jpg"),
	#"a6d10": preload("res://assets/a6d10.jpg"),
	#"a6d12": preload("res://assets/a6d12.jpg"),

	"a8d4": preload("res://assets/a8d4.jpg"),
	#"a8d6": preload("res://assets/a8d6.jpg"),
	#"a8d8": preload("res://assets/a8d8.jpg"),
	#"a8d10": preload("res://assets/a8d10.jpg"),
	#"a8d12": preload("res://assets/a8d12.jpg"),

	"a10d4": preload("res://assets/a10d4.jpg"),
	#"a10d6": preload("res://assets/a10d6.jpg"),
	#"a10d8": preload("res://assets/a10d8.jpg"),
	#"a10d10": preload("res://assets/a10d10.jpg"),
	#"a10d12": preload("res://assets/a10d12.jpg"),

	"a12d4": preload("res://assets/a12d4.jpg"),
	#"a12d6": preload("res://assets/a12d6.jpg"),
	#"a12d8": preload("res://assets/a12d8.jpg"),
	#"a12d10": preload("res://assets/a12d10.jpg"),
	#"a12d12": preload("res://assets/a12d12.jpg")
}

var rolled_health = []
var buttongroup1 = ButtonGroup.new()
var buttongroup2 = ButtonGroup.new()
var selectedAttackValue = 0
var selectedDefenseValue = 0
var remainingHealthRoll = 3
var rolledHealth = 0
var players = [] 
var current_player_index = 0

func _ready():
	warning_label.visible = false
	confirm_button.disabled = true
	var arr = get_children()
	for button in arr:
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
		
func change_texture():
	if((selectedAttackValue != 0 and selectedDefenseValue != 0) or selectedAttackValue == 20 or selectedDefenseValue == 20):
		charTexture.texture = images["a" + str(selectedAttackValue) + "d" + str(selectedDefenseValue)]
		
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
	change_texture()


func _on_confirm_button_mouse_entered() -> void:
	if(confirm_button.disabled):
		warning_label.visible = true

func _on_confirm_button_mouse_exited() -> void:
	if(confirm_button.disabled):
		warning_label.visible = false
		
func start_game():
	get_tree().change_scene_to_file("res://scenes/encounter_scene.tscn")
	

func reset_screen_for_next_player():
	rolledHealth = 0
	selectedAttackValue = 0
	selectedDefenseValue = 0
	remainingHealthRoll = 3

	health_result.text = "Roll to determine health"
	health_label.text = "Remaining Roll: 3"
	roll_health_button.disabled = false
	confirm_button.disabled = true
	warning_label.visible = false

	for btn in buttongroup1.get_buttons():
		btn.modulate = Color(1,1,1)
	
	for btn in buttongroup2.get_buttons():
		btn.modulate = Color(1,1,1)
		
	charTexture.texture = null

func _on_confirm_button_pressed() -> void:
	var new_player = CharacterData.new()
	new_player.character_name = "Player %d" % (current_player_index + 1)
	new_player.health = rolledHealth
	new_player.attack_power = selectedAttackValue
	new_player.defense = selectedDefenseValue
	new_player.sprite_texture = charTexture.texture 

	players.append(new_player)
	current_player_index += 1

	if(current_player_index < Global.selected_character_count):
		reset_screen_for_next_player()
	else:
		start_game()
