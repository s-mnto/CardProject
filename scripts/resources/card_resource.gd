class_name CardResource extends Resource

enum Suits { Spades, Clubs, Diamonds, Hearts }

var suit_type: Suits
var value: int = 0

func _get_rank_values(_value: int) -> String:
	match _value:
		11: return "J"
		12: return "Q"
		13: return "K"
		14: return "A"
		_: return str(_value)
