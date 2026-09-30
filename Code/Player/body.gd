extends CharacterBody2D

signal entered_sandstorm
signal exited_sandstorm
signal entered_grindrail(rail_follower: PathFollow2D)

@export var ground_ray: RayCast2D
@export var left_wall_jump_area: Area2D
@export var right_wall_jump_area: Area2D

const MAX_GROUND_SPEED = 625.0
const MAX_AIR_SPEED = 450.0
const ACCELERATION = 12.5
const FRICTION = 25.0

const WALL_SLIDE_GRAVITY = 0.25
const WALL_JUMP_STRENGTH = Vector2(360.0, 240.0)
const WALL_SCALE_STRENGTH = 480.0
const WALL_JUMP_TIME = 0.375

const JUMP_STRENGTH = 320.0
const MAX_JUMP_TIME = 0.25
const COYOTE_TIME = 0.125

const RAIL_SPEED = 1080.0

var current_ground_speed: float = 0.0

func is_near_wall() -> bool:
	var bodies: Array[Node2D] = left_wall_jump_area.get_overlapping_bodies()
	bodies.append_array(right_wall_jump_area.get_overlapping_bodies())
	
	while bodies.has(self):
		bodies.erase(self)
	
	return bodies.size() > 0
