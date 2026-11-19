
extends StaticBody3D

const OPEN_SPEED = 2.0

var prompt_text = "Open door"
var is_open = false
var closed_y = 0.0
@export var locked:bool=false
@export var required_item:String=""

func _ready() -> void:
	closed_y = rotation.y

func interact() -> void:
	if locked:
		if Inventory.has_item(required_item):
			locked = false
		else:
			print("door locked")
			return
	is_open = not is_open

func _physics_process(delta: float) -> void:
	var target_y = closed_y + deg_to_rad(90) if is_open else closed_y
	rotation.y = move_toward(rotation.y, target_y, OPEN_SPEED * delta)
