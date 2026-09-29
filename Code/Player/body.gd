extends CharacterBody2D

@export var ground_ray: RayCast2D

const MAX_GROUND_SPEED = 750.0
const MAX_AIR_SPEED = 450.0
const ACCELERATION = 12.5

const JUMP_STRENGTH = 320.0
const MAX_JUMP_TIME = 0.25
const COYOTE_TIME = 0.125

var current_ground_speed: float = 0.0
