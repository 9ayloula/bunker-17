extends OmniLight3D


func _on_light_switch_light_toggled(is_on: bool) -> void:
		visible = is_on
