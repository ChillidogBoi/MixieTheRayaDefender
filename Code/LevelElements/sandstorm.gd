@tool
class_name Sandstorm
extends Sprite2D

## Changing this size, changes the size of the texture and the collision shape
@export var size: Vector2 = Vector2.ONE:
	set(value):
		if internal_collision_shape == null:
			await RenderingServer.frame_post_draw
		size = value
		internal_collision_shape.shape.size = value
		texture.width = int(value.x)
		texture.height = int(value.y)
## The force with which a body is propelled toward Vector2.UP.
## Negative value will result in the body being pushed downward.
@export_range(-10000.0, 10000.0) var strength := 0.0
## Whether the body's accumulated speed is allowed to leave the area.
@export var launch_at_end := false

@export_subgroup("Internal", "internal_")
@export var internal_collision_shape: CollisionShape2D

## List of bodies to propel.
var held_bodies: Array[CharacterBody2D]

## Add body to list.
func _on_area_2d_body_entered(body: CollisionObject2D):
	if Engine.is_editor_hint(): return
	if not body is CharacterBody2D: return
	
	held_bodies.append(body)
	if body.has_signal("entered_sandstorm"): body.entered_sandstorm.emit()

## Remove body from list.
func _on_area_2d_body_exited(body: CollisionObject2D):
	if Engine.is_editor_hint(): return
	if not body is CharacterBody2D: return
	
	held_bodies.erase(body)
	if body.has_signal("exited_sandstorm"): body.exited_sandstorm.emit()
	if not launch_at_end: body.velocity.y = -strength

## Apply forces.
func _physics_process(delta):
	for n in held_bodies:
		n.velocity.y -= strength * delta
