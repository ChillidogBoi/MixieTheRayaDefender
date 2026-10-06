class_name PlayerState
extends Node

## Whether the state can be overridden by external forces (i.e. grindrails).
@export var overrides_overrides := false
## The CharacterBody2D with the constants used by PlayerStates for Movement.
@export var body: Mixie

## Returns the StringName of another PlayerState under the same parent StateMachine to change to.
## Returns "current" if there is no need to change. _new_input and _old_input are bitmaps as follows:
## pause = 128, special_attack = 64, melee_attack = 32, jump = 16, up = 8, down = 4, left = 2, right = 1
func test(_delta: float, _new_input: int, _old_input: int) -> String:
	return "current"

## Called when the state is the new current_state of the StateMachine (on the physics process).
## Use this to start animations, reset values and anything else that only needs to be done once.
## _new_input and _old_input are bitmaps as follows:
## pause = 128, special_attack = 64, melee_attack = 32, jump = 16, up = 8, down = 4, left = 2, right = 1
func enter_function(_delta: float, _new_input: int, _old_input: int):
	pass

## Called every frame on the idle process. Prefer physics_function() over this for anything involving body.
## _new_input and _old_input are bitmaps as follows:
## pause = 128, special_attack = 64, melee_attack = 32, jump = 16, up = 8, down = 4, left = 2, right = 1
func idle_function(_delta: float, _old_input: int):
	pass

## Called every physics frame. Preferred over idle_function() for anything involving body.
## _new_input and _old_input are bitmaps as follows:
## pause = 128, special_attack = 64, melee_attack = 32, jump = 16, up = 8, down = 4, left = 2, right = 1
func physics_function(_delta: float, _new_input: int, _old_input: int):
	pass

## Called after another state has been chosen (on the physics process).
## _new_input and _old_input are bitmaps as follows:
## pause = 128, special_attack = 64, melee_attack = 32, jump = 16, up = 8, down = 4, left = 2, right = 1
func exit_function(_delta: float, _new_input: int, _old_input: int):
	pass

## Helper function to apply the directional speed in body.current_ground_speed to the player.velocity.
## If it is fed a non-zero _new_input it will apply that to the body.current_ground_speed as a bitmap:
## (left = 2, right = 1) before applying body.current_ground_speed to the player.velocity.
## !!!Calls body.move_and_slide()!!!
func do_player_horizontal_movement(_new_input: int, speed_limit: float, dont_consider_walls := false):
	var direction: int = (_new_input & 0b01) - ((_new_input & 0b10) >> 1) # Calculate input.
	
	if direction == 0: body.current_ground_speed = move_toward(
		body.current_ground_speed, 0.0, body.FRICTION
	)
	
	if (body.current_ground_speed + (direction * body.ACCELERATION)) * direction <= speed_limit:
		body.current_ground_speed += direction * body.ACCELERATION # Apply acceleration.
	
	if body.is_on_wall() and not dont_consider_walls: # Don't continue to accelerate into walls.
		if body.get_wall_normal().x < 0: body.current_ground_speed = clamp(
			body.current_ground_speed, speed_limit * -2, 0
		)
		else: body.current_ground_speed = clamp(
			body.current_ground_speed, 0, speed_limit * 2
		)
	# Apply "horizontal" speed towards whatever direction Mixie's facing
	var temp_vel := Vector2(body.current_ground_speed, 0).rotated(body.global_rotation)
	# Apply vertical (falling) speed directly.
	body.velocity = temp_vel + body.current_falling_speed
	body.move_and_slide()

## Creates a new tween in body.rotation_tween to rotate to new_rotation.
## new_rotation should be a rotatable distance from Vector2.UP.
func do_player_rotation(new_rotation: Vector2, apply_as_up_direction: bool = true):
	var new_rota_f: float = wrapf(Vector2.UP.angle_to(new_rotation), -PI, PI)
	if apply_as_up_direction: body.up_direction = new_rotation
	
	if is_equal_approx(new_rota_f, body.rotation_tween_target): return
	if body.rotation_tween != null: body.rotation_tween.kill()
	body.rotation_tween_target = new_rota_f
	var start_rot: float = body.global_rotation
	if sign(body.global_rotation) != sign(body.rotation_tween_target):
		if abs(body.global_rotation) > PI / 2: start_rot -= TAU * sign(body.global_rotation)
	
	body.rotation_tween = create_tween()
	body.rotation_tween.tween_method(
		func(value:float): body.global_rotation = value,
		start_rot, body.rotation_tween_target, body.FLOOR_TWEEN
	)
