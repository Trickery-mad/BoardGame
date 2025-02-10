extends Control

@onready var health_result = $Control/HealthResult

var rolled_health = []
var buttongroup = ButtonGroup.new()

func _ready():
	var arr = get_children()
	for button in arr[0].get_children():
		if button is Button :
			if button.name.begins_with("a_") or button.name.begins_with("d_"):
				button.button_group = buttongroup
				button.connect("pressed", dice_pressed.bind(button))

func roll_health():
	# Roll 3d20, take the highest
	rolled_health = [randi_range(1, 20), randi_range(1, 20), randi_range(1, 20)]
	rolled_health.sort()
	health_result.text = "Health: %d (%d, %d)" % [rolled_health[2], rolled_health[1], rolled_health[0]]


func _on_button_pressed() -> void:
	roll_health()
	
func dice_pressed(button : Button) -> void:
	button.modulate = Color(0, 1, 0)  # Green
