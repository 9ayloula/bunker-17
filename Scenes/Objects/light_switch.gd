
extends StaticBody3D

signal light_toggled(is_on: bool)

var prompt_text = "Toggle light"
var is_on = true

func interact():
	is_on = not is_on
	light_toggled.emit(is_on)
