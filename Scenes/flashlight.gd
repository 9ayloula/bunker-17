extends SpotLight3D
const Max_battery=100.0
const DRAIN_RATE=2.0
var is_on=false
var battery=Max_battery
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible=is_on
func _process(delta: float) -> void:
	if is_on and battery>0:
		battery=battery-(DRAIN_RATE * delta)
		print(battery)
	if battery<=0:
		visible=false
		is_on=false
		battery=max(battery,0.0)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func toggle()->void:
	if battery>0:
		is_on=not is_on
		visible=is_on
	
func recharge()->void:
	battery=Max_battery
