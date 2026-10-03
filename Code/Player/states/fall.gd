extends PlayerState

var go_to_wallslide := false
var timer: float = 0.0
var rotated := false

func test(_delta: float, _new_input: int, _old_input: int) -> String:
	if _new_input & 0b010000 > 0 and _old_input & 0b010000 == 0:
		if body.is_on_floor() or body.ground_ray.is_colliding():
			return "Jump"
	if body.is_on_floor(): return "Walk"
	if go_to_wallslide: return "WallSlide"
	
	return "current"

func enter_function(_delta: float, _new_input: int, _old_input: int):
#	body.up_direction = Vector2.UP # This will need to be changed when we implement rotating gravity.
	go_to_wallslide = false

func physics_function(_delta: float, _new_input: int, _old_input: int):
	timer += _delta
	body.current_falling_speed += body.get_gravity() * _delta
	do_player_horizontal_movement(_new_input, body.MAX_AIR_SPEED)
	
	if not rotated and timer > body.FLOOR_TWEEN and body.get_gravity().sign():
		rotated = true
		body.rotation_tween = create_tween()
		body.rotation_tween.tween_property(
			body, "global_rotation",
			body.get_gravity().sign().angle_to(Vector2.DOWN),
			body.FLOOR_TWEEN
		)
	
	if body.is_near_wall(): go_to_wallslide = true

func exit_function(_delta: float, _new_input: int, _old_input: int):
	#Set body.velocity to 0, so jumps are consistant
	#and walking off of something doesn't give us a lot of downward momentum.
	if not go_to_wallslide: body.current_falling_speed = Vector2.ZERO
