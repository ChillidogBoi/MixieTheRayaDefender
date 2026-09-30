class_name PlayerState
extends Node

@export var body: CharacterBody2D

func test(_delta: float, _new_input: int, _old_input: int) -> String:
	return "current"

func enter_function(_delta: float, _new_input: int, _old_input: int):
	pass
func idle_function(_delta: float, _new_input: int, _old_input: int):
	pass
func physics_function(_delta: float, _new_input: int, _old_input: int):
	pass
func exit_function(_delta: float, _new_input: int, _old_input: int):
	pass


func do_player_horizontal_movement(_new_input: int, speed_limit: float):
	var direction: int = (_new_input & 0b01) - ((_new_input & 0b10) >> 1)
	if (body.current_ground_speed + (direction * body.ACCELERATION)) * direction <= speed_limit:
		body.current_ground_speed += direction * body.ACCELERATION
	if body.is_on_wall():
		if body.get_wall_normal().x < 0: body.current_ground_speed = clamp(
			body.current_ground_speed, speed_limit * -2, 0
		)
		else: body.current_ground_speed = clamp(
			body.current_ground_speed, 0, speed_limit * 2
		)
	body.velocity.x = body.current_ground_speed
	body.move_and_slide()
