extends RigidBody2D
class_name Entity

@export var max_health = 5.0
@export var sprite : AnimatedSprite2D
var hp

var dead = false

signal damaged
signal died



func _ready() -> void:
	hp = max_health

func damage(dmg):
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(10,10,10), 0.05)
	tween.tween_property(self, "modulate", Color(1,1,1), 0.05)
	
	hp -= dmg
	damaged.emit()
	if hp <= 0.0:
		die()

func die():
	
	died.emit()
	dead = true
	queue_free()
