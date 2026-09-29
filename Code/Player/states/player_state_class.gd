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
