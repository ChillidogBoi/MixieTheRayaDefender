extends Node

@export var body: CharacterBody2D
@export var current_state: PlayerState
var old_inputs: int = 0

func _ready():
	for c: PlayerState in get_children():
		c.body = body

func _physics_process(delta):
	var new_inputs: int = get_inputs()
	var new_state: String = current_state.test(delta, new_inputs, old_inputs)
	
	if new_state != "current":
		current_state.exit_function(delta, new_inputs, old_inputs)
		current_state = find_child(new_state)
		current_state.enter_function(delta, new_inputs, old_inputs)
	
	current_state.physics_function(delta, new_inputs, old_inputs)
	old_inputs = new_inputs

func get_inputs() -> int:
	var inputs := 0
	if not Input.is_anything_pressed(): return 0
	if Input.is_action_pressed("right"): inputs |= 0b01
	if Input.is_action_pressed("left"):
		if inputs & 0b01 == 0: inputs |= 0b10
		else: inputs &= 0b00
	if Input.is_action_pressed("down"): inputs |= 0b0100
	if Input.is_action_pressed("up"):
		if inputs & 0b0100 == 0: inputs |= 0b1000
		else: inputs &= 0b0011
	
	if Input.is_action_pressed("jump"): inputs |= 0b010000
	if Input.is_action_pressed("melee_attack"): inputs |= 0b100000
	if Input.is_action_pressed("special_attack"): inputs |= 0b01000000
	if Input.is_action_pressed("pause"): inputs |= 0b10000000
	
	return inputs
