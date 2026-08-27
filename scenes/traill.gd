extends Line2D
class_name LineTrail2D

@export var max_points = 150
var last_gp = Vector2.ZERO
##whether the line trail's color matches the color of the parent's modulate.
@export var match_color = false
# Called when the node enters the scene tree for the first time.

@export var points_expire = false
var timer = 0.0

func _ready() -> void:
	top_level = true
	last_gp = global_position
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer -= delta
	default_color = get_parent().modulate
	if get_parent().global_position.distance_to(last_gp) > 10.0:
		last_gp = get_parent().global_position
		add_point(get_parent().global_position)
	
	if timer < 0.0 and points_expire and points.size() > 0:
		timer = 0.1
		remove_point(0)
	
	if points.size() > max_points:
		remove_point(0)
