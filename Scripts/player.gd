extends CharacterBody3D

const WALK_SPEED = 5.0
const SPRINT_SPEED = 7.0
const CROUCH_SPEED = 2.5
const DECELERATION = 30.0
const MOUSE_SENSITIVITY = 0.003

const STAND_HEIGHT = 1.8
const CROUCH_HEIGHT = 1.2
const STAND_HEAD_Y = 1.6
const CROUCH_HEAD_Y = 1.0
const CROUCH_TRANSITION_SPEED=5

var current_speed = WALK_SPEED
var crouching = false

@onready var head = $Head
@onready var collision = $Player_Collision
@onready var ceiling_check= $CeilingCheck
@onready var Interact_check=$Head/Interact_ray
@onready var prompt=$CanvasLayer/Label


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		head.rotation.x += -event.relative.y * MOUSE_SENSITIVITY
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-85), deg_to_rad(85))
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode==Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode=Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	# 1. Decide speed (one chain, one decision)
	crouching = Input.is_action_pressed("crouch") or (crouching and ceiling_check.is_colliding())
	if crouching:
		current_speed = CROUCH_SPEED
	elif Input.is_action_pressed("sprint"):
		current_speed = SPRINT_SPEED
	else:
		current_speed = WALK_SPEED

	# 2. Decide posture (written once)
	var height = CROUCH_HEIGHT if crouching else STAND_HEIGHT
	collision.shape.height = height
	collision.position.y = height / 2.0

	var target_head_y = CROUCH_HEAD_Y if crouching else STAND_HEAD_Y
	head.position.y = move_toward(head.position.y, target_head_y, CROUCH_TRANSITION_SPEED * delta)

	# 3. Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 4. Movement
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)
		velocity.z = move_toward(velocity.z, 0, DECELERATION * delta)
	move_and_slide()
	handle_interaction()
	
	
func handle_interaction() -> void:
	prompt.visible=false
	if Interact_check.is_colliding():
		var object=Interact_check.get_collider()
		if object and object.is_in_group("interactable"):
			prompt.visible=true
			prompt.text=object.prompt_text
			if Input.is_action_just_pressed("interact"):
				object.interact()
