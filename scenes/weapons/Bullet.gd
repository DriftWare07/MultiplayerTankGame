extends RayCast2D
class_name Bullet

var my_owner : PhysicsBody2D
@export var damage = 10.0
@export var speed = 50.0
@export var richochetChance = 30.0
@export var fireSound : AudioStream

func _ready() -> void:
	
	var s = AudioStreamPlayer.new()
	get_tree().root.add_child(s)
	s.stream = fireSound
	s.bus = "sfx"
	s.play()

func _physics_process(delta: float) -> void:
	move_local_x(speed*delta)
	if is_colliding():
		hit(get_collider())


func hit(body):
	if body != my_owner:
		
		if body is Entity:
			if body.team == my_owner.team:
				return
			body.damage(damage)
			queue_free()
		
		if randf_range(0,100) < richochetChance:
			#rotation_degrees += 100 if randi_range(0,1) > 0 else -100
			var dir = Vector2.RIGHT.rotated(rotation)
			rotation = dir.bounce(get_collision_normal()).angle()
			return
		
		
		queue_free()
