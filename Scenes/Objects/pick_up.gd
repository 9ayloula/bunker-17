extends StaticBody3D

@export var item_name: String = "keycard"
var prompt_text = ""
signal picked_up(item_name: String)

func _ready() -> void:
	prompt_text = "[E] Take " + item_name

func interact() -> void:
	Inventory.add_item(item_name)
	picked_up.emit(item_name)
	queue_free()
