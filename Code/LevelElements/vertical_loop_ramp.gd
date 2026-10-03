class_name VerticalLoopRamp
extends StaticBody2D

const DEBUG_ENABLED_COLOR = Color(0, 1, 0, 1)
const DEBUG_DISABLED_COLOR = Color(1, 0, 0, 0.5) 

@export var debug: bool

@export_subgroup("Internal", "i_")
@export var i_right_collision: CollisionPolygon2D
@export var i_left_collision: CollisionPolygon2D
@export var i_right_debug: Polygon2D
@export var i_left_debug: Polygon2D

func _ready():
	i_right_debug.visible = false
	i_left_debug.visible = false
	if debug:
		i_right_debug.visible = true
		i_right_debug.color = DEBUG_ENABLED_COLOR
		i_left_debug.visible = true
		i_left_debug.color = DEBUG_DISABLED_COLOR
	
	i_right_collision.disabled = false
	i_left_collision.disabled = true


func _on_left_area_entered(body):
	print(body.name)
	if not body.has_signal("entered_vertical_loop_ramp"): return
	body.entered_vertical_loop_ramp.emit()
	if debug:
		i_right_debug.color = DEBUG_DISABLED_COLOR
		i_left_debug.color = DEBUG_ENABLED_COLOR
	
	i_right_collision.set_deferred("disabled", true)
	i_left_collision.set_deferred("disabled", false)
	
	await get_tree().process_frame
	print("left")


func _on_right_area_entered(body):
	print(body.name)
	if not body.has_signal("entered_vertical_loop_ramp"): return
	body.entered_vertical_loop_ramp.emit()
	if debug:
		i_right_debug.color = DEBUG_ENABLED_COLOR
		i_left_debug.color = DEBUG_DISABLED_COLOR
	
	i_right_collision.set_deferred("disabled", false)
	i_left_collision.set_deferred("disabled", true)
	
	await get_tree().process_frame
	print("right")
