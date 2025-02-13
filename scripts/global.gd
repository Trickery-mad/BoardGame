extends Node

var selected_character_count = 1 

func get_number_accordingto_dice(dice_name: String) -> int:
	match dice_name:
		"a_d4", "d_d4":
			return 4
		"a_d6", "d_d6":
			return 6
		"a_d8", "d_d8":
			return 8
		"a_d10", "d_d10":
			return 10
		"a_d12", "d_d12":
			return 12
		"a_d20", "d_d20":
			return 20
		_:
			return -1

	
