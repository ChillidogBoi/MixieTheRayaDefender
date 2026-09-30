@tool
extends Sprite2D

@export var size: Vector2 = Vector2.ONE:
	set(value):
		if internal_collision_shape == null:
			await RenderingServer.frame_post_draw
		size = value
		internal_collision_shape.shape.size = value
		texture.width = int(value.x)
		texture.height = int(value.y)
@export var strength := 0.0
@export var launch_at_end := false

@export_subgroup("Internal", "internal_")
@export var internal_collision_shape: CollisionShape2D

var in_editor := true
var held_bodies: Array[CharacterBody2D]


func _ready():
	await get_parent().ready
	in_editor = false

func _on_area_2d_body_entered(body: CollisionObject2D):
	if in_editor: return
	if not body is CharacterBody2D: return
	
	held_bodies.append(body)
	if body.has_signal("entered_sandstorm"): body.entered_sandstorm.emit()

func _on_area_2d_body_exited(body: CollisionObject2D):
	if in_editor: return
	if not body is CharacterBody2D: return
	
	held_bodies.erase(body)
	if body.has_signal("exited_sandstorm"): body.exited_sandstorm.emit()
	if not launch_at_end: body.velocity.y = -strength

func _physics_process(delta):
	for n in held_bodies:
		n.velocity.y -= strength * delta
